FROM docker.io/golang AS builder
COPY ./ ./
RUN go build -o /app
USER 1000
ENTRYPOINT ["/app"]

# gcr.io/distroless/static
# FROM scratch 
# COPY --from=builder /app /app
# USER 1000
# ENTRYPOINT ["/app"]