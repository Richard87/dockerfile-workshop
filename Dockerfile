FROM golang:latest AS builder
COPY ./ ./
RUN go build -o app
USER 1000
ENTRYPOINT ["/hello-world/app"]

# gcr.io/distroless/static
# FROM scratch 
# COPY --from=builder /app /app
# USER 1000
# ENTRYPOINT ["/app"]