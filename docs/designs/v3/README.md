# Ed-Fi-Docker Version 3

## Change to Docker First Mentality

The original official release of Ed-Fi tools in Docker containers occurred only
in this repository: it contained the Dockerfiles for the ODS/API and Admin App,
as well as sample Docker Compose configuration files that demonstrate how to run
these tools in various modes. Some unwanted side effects emerged from that
pattern:

- Docker support for new releases was separate from application release, and
  lagged behind by several months.
- The Ed-Fi Docker repositories are labeled with version numbers that correspond
  to this repository, rather than corresponding to the technology version in
  that container. Example: to get ODS/API version 6.1, you must know to look for
  tag `v2.3.0` on repository
  [edfialliance/ods-api-web-api](https://hub.docker.com/r/edfialliance/ods-api-web-api/tags).

Beginning with Data Import, the Dockerfile stayed with the source code
repository. This pattern is now being extended to all Ed-Fi products. For
example, the July 27, 2023 release of ODS/API version 7 is tagged as `7.0` (and
`7.0.27`). This signals a formal change to a "Docker first" - or at least,
"Docker at the same time" mentality for Ed-Fi technology.

What, then, becomes of _this repository_?

## Sample Configuration

With "release 3" of this repository, the goal of the repository continues to be
showcasing how to use Ed-Fi in containers, while removing the tactic of creating
those container images within the repository.

## Tentative Work Breakdown

1. Remove all Dockerfiles and related GitHub actions from this repo.
2. Add GitHub Actions jobs to run `docker compose config -q`
   ([reference](https://docs.docker.com/engine/reference/commandline/compose_config/))
   for each Compose file, to validate logical correctness of the file. Would be
   helpful to write a script to execute this, which would translate the output
   message format to GitHub messages. Thus errors would trigger a failed build.
3. Begin grouping compose files and helper scripts by ODS/API version, so users
   do not need to go through old tags to find compose files for older releases.
   Create a directory for ODS/API 6.1 and move existing compose files there.
   Ensure the container contains appropriate  documentation for steering the
   user to the right files.
4. Create a directory for ODS/API 7.0 and add configurations demonstrating
   various tenancy and instance modes. Update in-repo documentation.
5. Add Admin API 2.0 to (all of?) these compose files when it becomes available.
   Update docs.
6. Add Admin App 4.0 to single-tenant compose files when it becomes available.
   Update docs.
7. Add Data Import in one or more compose file. Update docs.
