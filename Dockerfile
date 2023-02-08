# Build image
FROM crystallang/crystal:1.7.2-alpine as builder
WORKDIR /app
# Cache dependencies
COPY ./shard.yml ./shard.lock /app/
RUN shards install -v
# Build a binary
COPY . /app/
RUN crystal build --verbose --release --static ./src/app.cr
# ===============
# Result image with one layer
FROM alpine:latest
WORKDIR /
COPY --from=builder /app/app .
ENTRYPOINT ["./app -p ${PORT}"]