# Docker Basics

To fully understand what Distroless is, one must first comprehend the concept of a Docker image. A Docker image is a lightweight, standalone, executable package that encompasses all the necessities to run a piece of software, including the code, runtime, system tools, libraries, and settings.

Docker images are built from a Dockerfile, a script containing a series of instructions used to generate the image.

## Distroless Image

Distroless images contain only your application and its runtime dependencies. They do not contain package managers, shells or any other programs you would expect to find in a standard Linux distribution.

Distroless Docker images are a stripped-down version of regular Docker images. In essence, they only contain the absolute essentials required to run an application. This means they lack the usual operating system tools and shells. They are not devoid of an OS, but they carry only the OS’s minimal runtime components.

## Benefits of Distroless

The main benefit of using Distroless is enhanced security. This heightened security is achieved through several attributes inherent to Distroless:

### Reduced Attack Surface:

By excluding unnecessary tools, binaries, and shell, Distroless images offer a smaller surface for potential attacks. There’s simply less in the image that can be exploited.

### Minimized Vulnerabilities:

With fewer components in the image, there are fewer potential points of failure. This can reduce the number of vulnerabilities and the frequency of required patches.

### No Shell:

Distroless images don’t contain a shell. This means if an attacker manages to get into the container, they won’t have a shell to execute further malicious commands, making it more challenging to move laterally or escalate privileges.

### Originated from Google:

Being a Google project, Distroless benefits from the company’s vast expertise in cloud security and infrastructure. This pedigree can instill confidence in users prioritizing security.

## Useful commands

1. Build the docker image

```
docker build -t servercrust/cloud-run-app .
```

2. Run the docker image

```
docker run --init -p 8080:8080 -t servercrust/cloud-run-app
```

The --init option is optional

## Multistage build

A multistage build is a feature in Docker that allows you to use multiple FROM statements in your Dockerfile. Each FROM instruction can use a different base
image, and begins a new stage of the build.

### Advantages:

1. Smaller final images: You can use one stage to build your application with all necessary build tools, and then copy only the resulting artifacts into a final, lean runtime image.

2. Improved security: By not including build tools and intermediate files in the final image, you reduce the attack surface of your deployed containers.

3. Better organization: You can divide your build process into logically separated stages, making your Dockerfile easier to understand and maintain.
4. Efficient caching: Each stage can be cached separately, speeding up subsequent builds.

In this Dockerfile, we are using a multistage build with four stages:

1. Planner stage: Uses cargo-chef to create a recipe for dependencies.
2. Cacher stage: Builds dependencies based on the recipe.
3. Builder stage: Compiles the actual application.
4. Final stage: Creates the runtime image with just the compiled application.

This approach allows you to have all the necessary build tools in the earlier stages, but end up with a small, efficient final image that contains only what's necessary to run your application.

## Cargo Chef

Cargo Chef is a tool designed to speed up Rust Docker builds by separating the building of dependencies from the building of your application code. It works in the following way:

1. Dependency Planning: Cargo Chef analyzes your project and creates a "recipe" file that contains information about your project's dependencies, but not the actual source code.
2. Dependency Building: Using this recipe, Cargo Chef can build all of your project's dependencies without needing the actual source code.
3. Caching: Docker can cache this dependency-building step, which means that unless your dependencies change, this step doesn't need to be repeated in subsequent builds.
4. Application Building: Finally, when building your actual application code, all the dependencies are already compiled, significantly speeding up the process.

## The main benefits of using Cargo Chef are:

1. Faster Builds: By separating dependency compilation from application compilation, it allows for more efficient use of Docker's caching mechanism.
2. Reduced Build Times: Especially beneficial in CI/CD pipelines or when frequently rebuilding your application with minor changes.
3. Smaller Images: It helps in creating smaller final images by clearly separating build dependencies from runtime dependencies.

### Creating a least privilege user

Creating a least privilege user is a security best practice in container environments. Here are the key reasons:

## Principle of Least Privilege:

This security concept states that any user, program, or process should have only the bare minimum privileges necessary to perform its function. This limits the potential damage if the container is compromised.

## Benefits of least privilege user

1. Reduce attack surface:
   Running processes as a non-root user limits what an attacker can do if they manage to exploit a vulnerability in your application.

2. Prevent privilege escalation:
   If an attacker gains control of a process running as root, they effectively have full control over the container and potentially the host system. A non-root user has far fewer capabilities.

3. Comply with security policies:
   Many organizations and cloud platforms require containers to run as non-root users as part of their security policies.

4. Limit accidental damage: Even without malicious intent, processes running as root can accidentally modify or delete critical system files.

5. Container isolation: While containers provide isolation, running as a non-root user adds an extra layer of separation between the application and the host system.
