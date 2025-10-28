# What even is a (docker) Container

## Intro to containers

- chroot - 1982
- everything is a file (everything is actually a process)
- system calls
- aka containers
- Comparisons to VMs and custom runtime

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
- Zip file and Text

`docker build -t test .`
`docker run -p 8080:8080 --rm test`
`docker system prune`

## Do something witin 10 min

- Choose your own adventure, pick a language you know that can listen to a port
- Host it on Radix

## Best practices
Use a non-root user (required @ radix)
Specify Volumes and ports used by app (if applicable)
Try to use read-only filesystem and control tmp/cache/data folders
Prefer scratch, distroless or alpine images to reduce footprint and vulnerabilities

## Honorable mentions

- Docker Compose
- Azure Container Apps
- Dev containers
- dive
- `docker build` is just one example, create container images with `bash`, `buildah` (Radix does this!), or even `terraform`