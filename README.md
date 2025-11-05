# What even is a (docker) Container

## Intro to containers

- chroot - 1982
- everything is a file (everything is actually a process)
- system calls
- aka containers
- Comparisons to VMs and custom runtime

## Lets build!

- Choose your own adventure, pick a language you know that can listen to a port
- Demo Layers optimization
- Host it on Radix

## Intro to dockerfile

- Layers
- Metadata
  - **FROM**
  - RUN
  - COMMAND
  - USER
  - WORKDIR
  - Bonus:
    - ENTRYPOINT
    - ADD
    - VOLUME
    - PORT
    - STOPSIGNAL (default SIGTERM)
    - RUN --mount=type=secret,id=aws,target=/root/.aws/credentials aws s3 cp s3://... ...
- Build Context
- Zip file and Text

`docker build -t test .`
`docker run -p 8080:8080 --rm test`
`docker system prune`

Reference: https://docs.docker.com/reference/dockerfile/

## Best practices
Use a non-root user (required @ radix)
Specify Volumes and ports used by app (if applicable)
Try to use read-only filesystem and control tmp/cache/data folders
Prefer scratch, distroless or alpine images to reduce footprint and vulnerabilities

## Honorable mentions

- .dockerignore
- Docker Compose
- Omnia Radix
- Azure Container Apps
- Dev containers
- dive
- docker image inspect ...
- `docker build` is just one example, create container images with `bash`, `buildah` (Radix does this!), or even `terraform`
- Container Registries and OCI regisitries
- Signed images

## Common issues

- Read only filesystem, much safer, but it might be tricky to know where an app writes to (temporary files, cache, data). Use `VOLUME` and specify folders that should be mounted in, and avoid writing to the filesystem without using them.  (Servers/Nodes generally have limited space that are shared across containers)
- Permissions, normally your default user id is 1000, and running with that user in container avoids a lot of filesystem issues, but also opens up a vulnerability if a container escape happens.
- User must be a id, not a name, so `USER nginx` will only work in Docker, but not in Kubernetes. Use `USER 1000` instead, we usually use `USER 65534` for a common `nobody` account.
- 