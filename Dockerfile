# Build image
FROM crystallang/crystal:1.7.2-alpine as builder
WORKDIR /opt
# Cache dependencies
COPY ./shard.yml ./shard.lock /opt/
RUN shards install -v
# Build a binary
COPY . /opt/
RUN crystal build --static --release ./src/app.cr
RUN crystal build --static --release ./src/worker.cr
RUN crystal build --static --release ./src/bundle.cr
# ===============
# Result image with one layer
FROM alpine:latest
WORKDIR /
COPY --from=builder /opt/app .
COPY --from=builder /opt/worker .
COPY --from=builder /opt/bundle .
ENTRYPOINT ["./bundle"]