FROM golang:1.16-alpine3.13 AS build

WORKDIR /src

COPY . .
RUN apk add gcc \
            make \
            musl-dev
RUN make build 

FROM alpine:3.13
LABEL maintainers="joshvanl"
LABEL description="cert-manager CSI Driver"

# Add util-linux to get a new version of losetup.
RUN apk add util-linux
COPY --from=build /src/bin/cert-manager-csi /cert-manager-csi
ENTRYPOINT ["/cert-manager-csi"]
