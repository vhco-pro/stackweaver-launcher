# Launcher image Dockerfile
# This builds the stackweaver-launcher image: the launcher process alone, which registers with an
# agent pool or as Hosted capacity and places every OpenTofu run, Ansible job and sync in its
# engine's job image on the container and Kubernetes drivers (one-launcher spec, A4). It carries
# no OpenTofu, Python or Ansible: the jobs run in the job images.
# NOTE: This Dockerfile must be built from the repository root (context = repo root)
#
# Example: docker build -f runner-images/launcher/Dockerfile -t stackweaver-launcher:latest .

# Build stage
FROM golang:1.27.3-alpine@sha256:b8c9b82affbbb82a020bbcf998dad2ba9516944ac7e883524642a481a9505e9c AS builder
ENV GOPRIVATE=github.com/michielvha/stackweaver

WORKDIR /app

RUN apk add --no-cache git

# Copy go modules first for caching
COPY backend/go.mod backend/go.sum ./
RUN --mount=type=secret,id=netrc,target=/root/.netrc go mod download

COPY backend/ .

# VERSION is the release the binary reports at registration.
ARG VERSION=dev
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags "-X main.version=${VERSION}" -o stackweaver-launcher ./cmd/launcher

# Runtime stage - Chainguard wolfi-base: zero-CVE target, has shell + apk, glibc-based
FROM cgr.dev/chainguard/wolfi-base@sha256:c2a4815b6ca49b9bbafd451b4bde690d567a86b2b6b54877faac8082a7bc4296

# What the launcher process itself runs: git and cosign for the populator's cache verifiers
# (#933, D7), and nftables and iptables for the container driver's one-shot jobs-network firewall
# writer, which runs this image with /bin/sh (#933, D5; OD15).
RUN apk add --no-cache ca-certificates git cosign iptables ip6tables nftables

# The same uid 1001 as the job images, so a shared cache volume stays readable.
RUN addgroup -g 1001 stackweaver && \
    adduser -D -u 1001 -G stackweaver -h /home/stackweaver stackweaver

# The launcher's node-local, read-only cache copy (RUNNER_CACHE_DIR): owned by the image's user, so
# a named volume mounted here starts out writable by the launcher.
RUN mkdir -p /var/cache/stackweaver-launcher && chown stackweaver:stackweaver /var/cache/stackweaver-launcher

COPY --from=builder /app/stackweaver-launcher /usr/local/bin/stackweaver-launcher

USER stackweaver
WORKDIR /home/stackweaver

# `stackweaver-launcher healthcheck` answers from the launcher's /readyz.
ENTRYPOINT ["/usr/local/bin/stackweaver-launcher"]
