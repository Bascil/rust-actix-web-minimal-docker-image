# Cloud Run Actix Hello

This project demonstrates how to build and run a Rust application using Docker, with a focus on security and efficiency.

## Table of Contents

- [Getting Started](#getting-started)
- [Docker and Multistage Builds](#docker-and-multistage-builds)
- [Distroless Images](#distroless-images)
- [Cargo Chef](#cargo-chef)
- [Security Best Practices](#security-best-practices)

## Getting Started

1. Build the Docker image:

```
docker build -t servercrust/cloud-run-app .
```

2. Run the Docker image:

```
docker run --init -p 8080:8080 -t servercrust/cloud-run-app
```

Note: The `--init` option is optional.

3. Test app using curl

```
curl localhost:8000
```

4. Load test using **wrk** with _8 threads_, _256 connections_ for _30 seconds_ duration (about 50k req/sec)

```
wrk -t8 -c256 -d30s http://localhost:8080
```

```
Running 30s test @ http://localhost:8080
  8 threads and 256 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     4.81ms    4.35ms 144.35ms   87.94%
    Req/Sec     7.39k   839.75    15.28k    80.21%
  1767602 requests in 30.07s, 219.14MB read
Requests/sec:  58780.61
Transfer/sec:      7.29MB
```

## Docker and Multistage Builds

A Docker image is a lightweight, standalone, executable package that includes everything needed to run a piece of software. Images are built from a Dockerfile, which contains instructions to generate the image.

### Multistage Builds

Multistage builds in Docker allow the use of multiple `FROM` statements in a Dockerfile. Each `FROM` instruction begins a new stage of the build, potentially using a different base image.

#### Advantages:

1. Smaller final images
2. Improved security
3. Better organization
4. Efficient caching

Our Dockerfile uses a four-stage build:

1. Planner stage: Creates a dependency recipe using cargo-chef
2. Cacher stage: Builds dependencies based on the recipe
3. Builder stage: Compiles the application
4. Final stage: Creates a lean runtime image

## Distroless Images

Distroless Docker images are minimalist images containing only the essentials to run an application. They lack typical OS tools and shells, resulting in a smaller attack surface and enhanced security.

### Benefits of Distroless:

- Reduced attack surface
- Minimized vulnerabilities
- No shell access for potential attackers
- Backed by Google's expertise in cloud security

## Cargo Chef

Cargo Chef is a tool that optimizes Rust Docker builds by separating dependency building from application code building.

### How it works:

1. Dependency Planning: Creates a "recipe" file of project dependencies
2. Dependency Building: Builds dependencies using the recipe
3. Caching: Allows Docker to cache the dependency-building step
4. Application Building: Compiles application code with pre-built dependencies

### Benefits:

- Faster builds
- Reduced build times
- Smaller images

## Security Best Practices

### Principle of Least Privilege

Creating a least privilege user is crucial for container security. This practice ensures that processes have only the minimum necessary privileges to function.

#### Benefits:

1. Reduced attack surface
2. Prevention of privilege escalation
3. Compliance with security policies
4. Limited accidental damage
5. Enhanced container isolation

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

This project is licensed under the [MIT License](LICENSE).
