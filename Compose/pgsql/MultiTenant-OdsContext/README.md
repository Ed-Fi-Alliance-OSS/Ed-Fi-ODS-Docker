# PgSql MultiTenant with ODS Context Configuration Example
This configuration shows a basic example of a multi tenant configuration with an explicit data segmentation strategy based on the school year. Deployment has one Admin, Security per tenant, and one ODS per school year. ODS for the school year is selected based on the school year in the API route segment.

Includes the following web applications:
* Ed-Fi Web API
* Ed-FI ODS Admin Api

See [Ed-Fi Docker Compose Architecture](https://docs.ed-fi.org/reference/docker/ed-fi-docker-compose-architecture) for more information.
