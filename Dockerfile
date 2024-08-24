# separate building of dependencies from building of application
# if we can cache buiding dependencies we can greatly reduce build time
# if you make a small code change it doesnt need to compile and download dependencies
# it can used the cached versions of that image

# stage 1 - planning - generate recipe file for dependencies
# use the rust official image as our builder
FROM rust AS planner
WORKDIR /app
RUN cargo install cargo-chef
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

# stage 2 -build our dependencies
FROM rust AS cacher
WORKDIR /app
RUN cargo install cargo-chef
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

# stage 3 - use the rust official docker image as builder
FROM rust AS builder

# create least prividedge user
ENV USER=web
ENV UID=1001

# creates a user named "web" with UID 1001, no password, 
# no home directory, and no login shell.
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

# copy the app into the docker image
COPY . /app

# set the work directory
WORKDIR /app

# copy dependencies - all deps will be prebuilt - no need o download deps
COPY --from=cacher /app/target target
COPY --from=cacher /usr/local/cargo /usr/local/cargo

# build the app
RUN cargo build --release

# stage 4 - use google distroless as runtime image
FROM gcr.io/distroless/cc-debian12

# Import from the builder
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# copy app from builder
COPY --from=builder /app/target/release/cloud-run-actix-hello /app/cloud-run-actix-hello
WORKDIR /app

# specify the user in final stage
USER web:web

CMD ["./cloud-run-actix-hello"]

