# PRD: Ed-Fi ODS Docker Deployment

| Field | Value |
|---|---|
| **Status** | Reverse-engineered from existing application |
| **ODS/API Version Scope** | v7.x only |
| **Repository** | [Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker) |
| **License** | Apache 2.0 |
| **Images** | [hub.docker.com/u/edfialliance](https://hub.docker.com/u/edfialliance) |
| **Tech Docs** | [docs.ed-fi.org/reference/docker](https://docs.ed-fi.org/reference/docker/) |
| **Sources** | README.md, docs/GETTING_STARTED.md, .env.example, docs/reference/7-docker/readme.mdx, docs/reference/7-docker/ed-fi-docker-compose-architecture.mdx |

> **Note:** This PRD reflects *current shipped behavior* inferred from source files, documentation, and compose configuration. Claims are tagged with their source. Future requirements and open questions are distinguished from current functionality.

---

## 1. Product Overview

Ed-Fi ODS Docker is a set of Docker Compose files, helper PowerShell scripts, a Mustache-based compose generator, and pre-built container images that enable platform operators to deploy the Ed-Fi ODS/API stack — including Web API, Admin API, Sandbox Admin, SwaggerUI, and supporting databases — on Linux containers without requiring manual configuration of each component.

The repository does **not** contain the application source code for those services; Docker images are built in their respective application repositories and distributed via the `edfialliance` account on Docker Hub. This repository provides the *orchestration layer*: compose files, environment templates, a reverse-proxy configuration, and a connection-pooling setup.

---

## 2. Strategic Alignment

- **Mission fit:** The Ed-Fi Alliance's mission is to accelerate K-12 education data exchange. Lowering the barrier to deploy and evaluate the ODS/API broadens adoption among SEAs, LEAs, and software vendors. *(Source: Ed-Fi Alliance mission; README context)*
- **Developer experience:** API client developers need a rapid, realistic sandbox to build against before connecting to production. *(Source: architecture doc — Sandbox configuration purpose)*
- **Operational flexibility:** Platform hosts need deployment options ranging from single-district to multi-tenant SEA-scale, with explicit data segmentation by school year. *(Source: architecture doc — five configuration modes)*
- **Cloud-readiness:** Containers allow deployment on any OCI-compatible runtime — Docker Desktop, Podman, AWS ECS, GKE, Azure Container Instances. *(Source: readme.mdx Step 5 note)*

---

## 3. Target Users and Personas

### 3.1 API Client Developer
- **Goal:** Stand up a working Ed-Fi ODS/API sandbox quickly to develop and test a client application against realistic data.
- **Technical depth:** Moderate — comfortable with Docker and environment variables but not necessarily an Ed-Fi platform expert.
- **Pain point:** Manual database setup and IIS configuration are time-consuming and error-prone.
- **Success:** Swagger UI, Sandbox Admin, and ODS/API are accessible within minutes of cloning the repo.

### 3.2 Platform Host / SEA/LEA IT Operator
- **Goal:** Deploy a production-grade (or production-adjacent) ODS/API for one or more school districts or tenants.
- **Technical depth:** High — manages infrastructure, certificates, database credentials.
- **Pain point:** Wiring together NGINX, PgBouncer, multiple databases, and the API across tenants is complex and poorly documented elsewhere.
- **Success:** Stable, scalable multi-tenant deployment with isolated ODS databases per tenant and school year, accessible over HTTPS.

### 3.3 Ed-Fi Alliance / Open-Source Contributor
- **Goal:** Maintain compose templates and generator; ensure new ODS/API releases have corresponding Docker support.
- **Technical depth:** Expert.
- **Success:** Release tags on this repo correspond 1:1 with ODS/API release tags; CI validates compose files.

---

## 4. Jobs to Be Done

| # | When… | I want to… | So that… |
|---|---|---|---|
| JTBD-1 | I want to evaluate the Ed-Fi ODS/API | spin up a sandbox with populated sample data and SwaggerUI | I can explore API capabilities without production data |
| JTBD-2 | I am building an API client application | create isolated sandbox environments for my team | each developer can test independently |
| JTBD-3 | I am a platform host deploying for one district | bring up a single-tenant ODS/API with Admin API | I can manage API clients and review data via a supported interface |
| JTBD-4 | I need year-over-year data segmentation | route API traffic by school year to separate ODS databases | data from different school years does not mix |
| JTBD-5 | I host data for multiple districts (SEA) | deploy a multi-tenant environment with per-tenant databases | each district's data is isolated and independently manageable |
| JTBD-6 | I need multi-tenant + year-specific routing | combine tenant and ODS context routing | each tenant's each school year maps to its own ODS |
| JTBD-7 | I need to customize beyond the examples | generate a compose file for my exact tenant/year combination | I am not constrained to the two-tenant, two-year example |
| JTBD-8 | I run SQL Server instead of PostgreSQL | deploy the Web API and Sandbox Admin against an external MSSQL instance | I can use my organization's licensed SQL Server infrastructure |

---

## 5. Enterprise / System Context

```
Internet / Client Browser
        │  HTTPS :443
        ▼
┌────────────────────────────┐
│  NGINX Web Gateway         │  SSL termination, reverse proxy,
│  (ods-api-web-gateway)     │  route dispatch, potential load balancing
└───────────┬────────────────┘
            │ Internal Docker network
   ┌─────────┼──────────────────────────────────┐
   ▼         ▼                                  ▼
[Web API] [Admin API]            [Sandbox Admin] [SwaggerUI]
   │         │                        │
   ▼         ▼                        ▼
[PgBouncer] [PgBouncer-Admin]   [PgBouncer-Sandbox]
   │         │                        │
   ▼         ▼                        ▼
[db-ods]  [db-admin (EdFi_Admin    [db-sandbox (populated
           + EdFi_Security)]        template)]
```

- All containers share an internal Docker bridge network; only the NGINX gateway exposes port 443 externally by default. *(Source: architecture doc)*
- Database volumes should be mapped outside the Docker network for data permanency. *(Source: architecture doc note on cylinders in diagrams)*
- SSL certificates live in the `ssl/` directory and are mounted into the gateway container. *(Source: readme.mdx Step 4; generate-cert.sh)*

---

## 6. Functional Requirements

### 6.1 Deployment Configurations

**FR-CFG-1:** The system SHALL support a **Sandbox** deployment mode that includes the Ed-Fi Web API, Sandbox Admin web application, and SwaggerUI, backed by a pre-populated PostgreSQL ODS database.
*(Source: architecture doc — Sandbox Configuration)*

**FR-CFG-2:** The system SHALL support a **SingleTenant** deployment mode that includes the Ed-Fi Web API and Admin API, backed by PostgreSQL ODS and Admin databases.
*(Source: architecture doc — SingleTenant Configuration)*

**FR-CFG-3:** The system SHALL support a **SingleTenant with ODS Context** deployment mode that routes API traffic to year-specific ODS databases based on a school year path segment.
*(Source: architecture doc — SingleTenant with ODS Context Configuration)*

**FR-CFG-4:** The system SHALL support a **MultiTenant** deployment mode with isolated Admin, Security, and ODS databases per tenant.
*(Source: architecture doc — MultiTenant Configuration)*

**FR-CFG-5:** The system SHALL support a **MultiTenant with ODS Context** deployment mode combining per-tenant isolation and year-specific ODS routing.
*(Source: architecture doc — MultiTenant with ODS Context Configuration)*

**FR-CFG-6 (REMOVED):** ~~SQL Server support~~ — See Section 9 (Out of Scope). SQL Server compose files present in the repository are not a supported configuration for v7.x and are explicitly out of scope for new feature work.

### 6.2 Container Images

**FR-IMG-1:** The system SHALL provide NGINX-based reverse-proxy images (`ods-api-web-gateway`, `ods-api-web-gateway-sandbox`) built on Alpine Linux, distributed via Docker Hub under `edfialliance`. *(Source: architecture doc component table)*

**FR-IMG-2:** The system SHALL provide PostgreSQL 13.12 database images pre-initialized with the Ed-Fi minimal template (`ods-api-db-ods`), populated template (`ods-api-db-sandbox`), and Admin/Security databases (`ods-api-db-admin`). *(Source: architecture doc)*

**FR-IMG-3:** The system SHALL include both TPDM (Teacher Preparation Data Model) and core Ed-Fi data model in the ODS database images, with TPDM controllable via the `TPDM_ENABLED` environment variable. *(Source: architecture doc; .env.example)*

**FR-IMG-4 (OUT OF SCOPE):** ~~SQL Server-compatible Web API images~~ — See Section 9. The Alliance does not and SHALL NOT distribute SQL Server database container images due to Microsoft's license restrictions on redistribution. SQL Server Web API image variants (tagged `-mssql`) are a legacy artifact; no new SQL Server image work is in scope for v7.x.

### 6.3 Networking and SSL

**FR-NET-1:** The system SHALL terminate HTTPS traffic at the NGINX gateway container on port 443. *(Source: architecture doc)*

**FR-NET-2:** The system SHALL NOT expose database ports outside the Docker network by default. An `.override.yml.example` file SHALL be provided for each configuration to enable optional database port exposure. *(Source: README.md — Exposed Ports section)*

**FR-NET-3:** The system SHALL require a valid SSL certificate mounted at the `ssl/` directory. A `generate-cert.sh` helper script SHALL be provided to create a self-signed certificate suitable for non-production use. *(Source: readme.mdx Step 4; GETTING_STARTED.md Step 4)*

**FR-NET-4:** Virtual path routing for API, Sandbox Admin, Admin API, and Swagger SHALL be configurable via environment variables (`ODS_VIRTUAL_NAME`, `SANDBOX_ADMIN_VIRTUAL_NAME`, `ADMIN_API_VIRTUAL_NAME`, `DOCS_VIRTUAL_NAME`). *(Source: .env.example)*

### 6.4 Connection Pooling

**FR-POOL-1:** The system SHALL include PgBouncer as the default server-side connection pooler for all PostgreSQL-backed configurations. *(Source: README.md — Connection Pooling Options)*

**FR-POOL-2:** PgBouncer SHALL be configured with auth_file security using credentials provided via environment variables (`POSTGRES_USER`, `POSTGRES_PASSWORD`). *(Source: README.md — PGBouncer security)*

**FR-POOL-3:** PgBouncer log verbosity SHALL default to quiet mode (`PGBOUNCER_EXTRA_FLAGS="--quiet"`) to prevent sensitive credentials from appearing in logs. *(Source: README.md — PGBouncer logging)*

**FR-POOL-4:** The system SHALL support optional npgsql client-side connection pooling as an alternative to PgBouncer, configurable via `NPG_POOLING_ENABLED` and per-pool-size environment variables. Client-side pooling SHALL be disabled by default. *(Source: README.md — Connection Pooling Options)*

**FR-POOL-5:** Documentation SHALL describe the steps required to remove PgBouncer and replace it with direct database connections. *(Source: README.md — "To remove PGBouncer" section)*

### 6.5 Configuration and Environment Variables

**FR-ENV-1:** All configurable parameters SHALL be set via environment variables in a `.env` file. An `.env.example` file SHALL document all supported variables with descriptions. *(Source: README.md; .env.example)*

**FR-ENV-2:** The ODS connection string encryption key (`ODS_CONNECTION_STRING_ENCRYPTION_KEY`) SHALL be a Base64-encoded 256-bit AES key, required at startup. *(Source: GETTING_STARTED.md Step 2)*

**FR-ENV-3:** Admin API authentication SHALL require `AUTHORITY`, `ISSUER_URL`, and `SIGNING_KEY` environment variables. *(Source: .env.example)*

**FR-ENV-4:** Health check endpoints SHALL be configurable per service (`API_HEALTHCHECK_TEST`, `SANDBOX_HEALTHCHECK_TEST`, `SWAGGER_HEALTHCHECK_TEST`, `ADMIN_API_HEALTHCHECK_TEST`). Defaults SHALL point to `http://localhost/health`. *(Source: .env.example)*

### 6.6 Compose Generator

**FR-GEN-1:** The system SHALL provide a Mustache-based Docker Compose generator (`edfialliance/ods-compose-generator`) capable of producing customized compose files for:
- SingleTenant with arbitrary school year ODS contexts
- MultiTenant with arbitrary tenants
- MultiTenant with arbitrary tenants and school year ODS contexts
*(Source: readme.mdx — Generating Compose File sections)*

**FR-GEN-2:** The generator SHALL accept a `parameters.yml` input file and write output to a mapped volume, supporting parameterization of `odsContextRouteTemplate`, `contextKey`, tenant IDs, tokens/years, and optional PgBouncer port exposure. *(Source: readme.mdx parameter documentation)*

### 6.7 Operational Scripts

**FR-OPS-1:** The system SHALL provide PowerShell scripts for each deployment configuration to bring up (`*-up.ps1`) and tear down (`*-clean.ps1`) environments. *(Source: README.md; readme.mdx Step 5)*

**FR-OPS-2:** The `-Engine` parameter on `*-up.ps1` and `*-clean.ps1` scripts SHALL select between PostgreSQL (default) and SQL Server. *(Source: readme.mdx Step 5)*

**FR-OPS-3:** Application log files SHALL be written to a host-mounted volume path configured via `LOGS_FOLDER`. *(Source: readme.mdx Step 7)*

---

## 7. Non-Functional Requirements

### 7.1 Security

**NFR-SEC-1:** Database ports SHALL NOT be exposed to external networks by default. *(FR-NET-2)*

**NFR-SEC-2:** PgBouncer configuration files containing database credentials SHALL NOT appear in logs by default. *(FR-POOL-3)*

**NFR-SEC-3:** ODS connection strings SHALL be encrypted at rest using AES-256. *(FR-ENV-2)*

**NFR-SEC-4:** Admin API authentication SHALL use signed JWTs with configurable issuer and authority. *(FR-ENV-3)*

**NFR-SEC-5:** The repository SHALL maintain an OpenSSF Scorecard badge and comply with Ed-Fi Alliance security contribution guidelines. *(Source: README.md OpenSSF badge)*

**NFR-SEC-6:** Default credentials in `.env.example` SHALL be clearly labeled as insecure placeholders requiring replacement before any non-local deployment. *(Source: readme.mdx warning in Step 3)*

### 7.2 Compatibility

**NFR-COMPAT-1:** All container images SHALL be built on Alpine Linux to minimize image size and attack surface. *(Source: architecture doc)*

**NFR-COMPAT-2:** Compose files SHALL be compatible with Docker Compose v2 CLI syntax and SHALL be generally transferable to other OCI-compatible runtimes (e.g., Podman). *(Source: readme.mdx — "generally transferable" note)*

**NFR-COMPAT-3:** Each major release of this repository SHALL correspond to a supported ODS/API version. The README SHALL include a version compatibility matrix. *(Source: README.md version table)*

**NFR-COMPAT-4 (OUT OF SCOPE):** SQL Server support is out of scope. See Section 9.

### 7.3 Observability

**NFR-OBS-1:** Each service container SHALL expose a `/health` HTTP endpoint. The default health check configuration SHALL use this endpoint. *(Source: .env.example)*

**NFR-OBS-2:** Application logs SHALL be accessible from the host at the configured `LOGS_FOLDER` path. *(Source: readme.mdx Step 7)*

### 7.4 Reliability

**NFR-REL-1:** PgBouncer SHALL prevent database connection exhaustion in multi-process and multi-container deployments where client-side pooling would otherwise exceed PostgreSQL's default 100-connection limit. *(Source: README.md — Connection Pooling Options discussion)*

### 7.5 Operations and SDLC

**NFR-SDLC-1:** Compose files SHALL be validated via a CI process (`validate-compose-files.ps1`). *(Source: repository root file listing)*

**NFR-SDLC-2:** The repository SHALL follow Ed-Fi Alliance [Code Contribution Guidelines](https://docs.ed-fi.org/community/sdlc/code-contribution-guidelines/). *(Source: README.md — Contributing section)*

**NFR-SDLC-3:** An `.editorconfig` SHALL be present to enforce consistent file formatting across contributors. *(Source: repository root file listing)*

---

## 8. System Architecture

| Component | Image | Runtime | Purpose |
|---|---|---|---|
| Web Gateway | `ods-api-web-gateway` | NGINX 1.25.1 on Alpine | Reverse proxy, SSL termination, route dispatch |
| Web Gateway (Sandbox) | `ods-api-web-gateway-sandbox` | NGINX 1.25.1 on Alpine | Same as above + SwaggerUI + Sandbox Admin routes |
| ODS Web API | `ods-api-web-api` | .NET on Alpine | Core Ed-Fi REST API (PostgreSQL) |
| ODS Web API (MSSQL) | `ods-api-web-api:<TAG>-mssql` | .NET on Alpine | Core Ed-Fi REST API (SQL Server) |
| Admin API | `ods-admin-api` | .NET on Alpine | Management API for API clients / ODS instances |
| Sandbox Admin | `ods-api-web-sandbox-admin` | .NET on Alpine | Web UI for creating/managing sandbox environments |
| Swagger UI | `ods-api-web-swaggerui` | Node on Alpine | Interactive API documentation |
| ODS DB (minimal) | `ods-api-db-ods` | PostgreSQL 13.12 | ODS with minimal template + TPDM |
| ODS DB (populated) | `ods-api-db-sandbox` | PostgreSQL 13.12 | ODS with Grand Bend sample data |
| Admin DB | `ods-api-db-admin` | PostgreSQL 13.12 | EdFi_Admin + EdFi_Security databases |
| Admin API DB | `ods-admin-api-db` | PostgreSQL 13.12 | EdFi_Admin (with Admin API tables) + EdFi_Security |
| PgBouncer | `bitnami/pgbouncer` | Alpine | Server-side PostgreSQL connection pooler |
| Compose Generator | `ods-compose-generator` | Alpine (Mustache) | Generates customized compose files from parameters |

### 8.1 Data Ownership

- Each ODS database (minimal, populated, per-tenant, per-year) owns its own Ed-Fi data model schema.
- `EdFi_Admin` owns API client credentials, ODS instance routing table, and (in Admin API mode) application registrations.
- `EdFi_Security` owns claim sets and authorization rules.
- Connection string encryption key must be held by the operator outside Docker.

### 8.2 Compose File Layout

```
Compose/
  pgsql/
    compose-sandbox-env.yml
    SingleTenant/
    SingleTenant-OdsContext/
    MultiTenant/
    MultiTenant-OdsContext/
  mssql/
    compose-sandbox-env.yml
    SingleTenant/
Compose-Generator/
  Alpine/                         # Mustache templates + generator Dockerfile
Web-Gateway/                      # NGINX configs for non-sandbox gateway
Web-Gateway-Sandbox/              # NGINX configs for sandbox gateway
PgBouncer/                        # PgBouncer config templates
ssl/                              # Mounted SSL certificate (git-ignored)
```

---

## 9. Out of Scope and Known Limitations

- **ODS/API v6.x and earlier:** This PRD covers v7.x only. Prior versions are documented separately at the v2.x Docker page and are not maintained in this PRD.

- **Microsoft SQL Server:** SQL Server is explicitly out of scope. Microsoft's license terms prohibit redistribution of SQL Server in a pre-configured container image, so the Alliance cannot provide MSSQL database images. SQL Server compose files present in the repository are legacy artifacts. Operators requiring SQL Server must provision databases themselves, and the Alliance provides no support or guarantees for that path.

- **Production hardening:** The Alliance explicitly does not provide production deployment guidance. Operators must review and adapt configurations for their environment. *(Source: readme.mdx warning block)*
- **NGINX load balancing and traffic logging:** Described as "potential" features requiring manual reconfiguration of the gateway container; not enabled out of the box. *(Source: architecture doc component table)*
- **Data Import:** The `data-import` image exists but is not included in any out-of-the-box compose configuration. Must be deployed separately. *(Source: architecture doc — Additional Images)*
- **Analytics Middle Tier:** Same as Data Import — maintained separately, not included. *(Source: architecture doc — Additional Images)*
- **SQL Server container images:** The Alliance does not distribute pre-configured MSSQL database containers; operators must provision databases themselves. *(Source: readme.mdx Step 2b)*
- **Multi-cloud orchestration:** Kubernetes, Helm charts, ECS task definitions, and other cloud-native orchestration formats are not provided. Containers can be deployed there but the compose files are not designed for it. *(Inferred — no such files in repository)*
- **Horizontal scaling / HA:** The gateway notes "potential load balancing" but no multi-replica API configuration is provided out of the box. *(Source: architecture doc)*
- **Automated certificate renewal (Let's Encrypt / ACME):** Not included; operators manage certificates manually. *(Inferred from generate-cert.sh scope)*
- **Monitoring / alerting integration:** No Prometheus exporters, Grafana dashboards, or alerting configurations are included. *(Inferred from absence in repo)*

---

## 10. Glossary

| Term | Definition |
|---|---|
| **ODS** | Operational Data Store — the PostgreSQL or SQL Server database holding Ed-Fi student/education data |
| **Ed-Fi ODS/API** | The core REST API that exposes the ODS via the Ed-Fi data standard |
| **Admin API** | REST API for managing API clients, claim sets, and ODS instance routing; successor to Admin App |
| **Sandbox Admin** | Web application for creating and managing sandbox ODS environments for API client developers |
| **SwaggerUI** | Web-based interactive documentation for the ODS/API |
| **TPDM** | Teacher Preparation Data Model — an Ed-Fi extension for educator prep program data |
| **SingleTenant** | One logical deployment serving a single district or organization |
| **MultiTenant** | One deployment serving multiple independent tenants (e.g., districts), each with isolated databases |
| **ODS Context** | A URL route segment (e.g., school year) that selects which ODS database serves a given API request |
| **PgBouncer** | Lightweight PostgreSQL connection pooler that sits between the application and database |
| **Grand Bend** | Fictional school district used in the "populated template" sample data |
| **Minimal template** | ODS database pre-loaded with only core Ed-Fi descriptors and no student data |
| **Populated template** | ODS database pre-loaded with Grand Bend sample student data |
| **MSSQL** | Microsoft SQL Server |
| **NFR** | Non-Functional Requirement |
| **JTBD** | Job To Be Done |

---

## 11. Open Questions and Decision Log

| # | Question | Status |
|---|---|---|
| OQ-1 | Should the Alliance provide Kubernetes / Helm artifacts in this repository or in a separate one? | **Open** — not addressed in current sources |
| OQ-2 | ~~Is SQL Server support intended to remain "experimental" indefinitely?~~ | **Closed** — SQL Server is out of scope due to Microsoft redistribution license restrictions. |
| OQ-3 | Should the Compose Generator be redesigned to support a broader set of parameters (e.g., replica count for HA, cloud-specific volume drivers)? | **Open** |
| OQ-4 | What is the support lifecycle for ODS/API v7.x Docker images — how long after a new ODS/API release must a corresponding Docker release be available? | **Open** |
| OQ-5 | Are there plans to move from PostgreSQL 13.12 to a newer PostgreSQL version in the database images? | **Open** |
| OQ-6 | Should automated SSL certificate renewal be included (e.g., Certbot sidecar) for non-development deployments? | **Open** |
| OQ-7 | The MultiTenant compose examples are hard-coded to two tenants (Tenant1/Tenant2) and two years (2022/2023). Should the generator replace these static examples entirely? | **Open** |
