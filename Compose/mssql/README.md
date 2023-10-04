# Ed-Fi ODS Docker MsSQL Compose Examples
The following configurations provide API, Admin App, and SwaggerUI containers. Admin, Security, and ODS databases must be created in one or more MsSql server instances and provide the Server, User, and Passwords in the proper .env variables.

## [Sandbox](compose-sandbox-env.yml)
A Sandbox environment is generally used to support API client developers in developing client applications. It is not intended to be a staging environment for the platform host.

Includes the following web applications:
* Ed-Fi Web API
* Ed-Fi Sandbox Admin
* SwaggerUI

## [SingleTenant Configuration](compose-single-tenant-env.yml)
This configuration shows a basic example of a single tenant configuration where a single ODS database serves all data going through the API. While this example has one ODS for demonstration purposes, single tenant deployments can support separate ODS databases per school year and district. See API Client and ODS Instance Configuration for more information.

Includes the following web applications:
* Ed-Fi Web API
* Ed-FI ODS Admin Api
