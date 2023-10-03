# Ed-Fi ODS Docker Compose Examples

## Sandbox 
A Sandbox environment is generally used to support API client developers in developing client applications. It is not intended to be a staging environment for the platform host.

Includes the following web applications:
* Ed-Fi Web API
* Ed-Fi Sandbox Admin
* SwaggerUI

## SingleTenant Configuration
This configuration shows a basic example of a single tenant configuration where a single ODS database serves all data going through the API. While this example has one ODS for demonstration purposes, single tenant deployments can support separate ODS databases per school year and district. See API Client and ODS Instance Configuration for more information.

Includes the following web applications:
* Ed-Fi Web API
* Ed-FI ODS Admin Api

## SingleTenant with ODS Context Configuration
This configuration shows a basic example of explicit data segmentation strategy based on school year, i.e., the school year becomes a required part of the API route segments. See Context-Based Routing for Year-Specific ODS for more information.

Includes the following web applications:
* Ed-Fi Web API
* Ed-FI ODS Admin Api

## MultiTenant Configuration
This configuration is a basic example of multiple tenant configurations, with one Admin, Security, and ODS database per tenant. See Multi-Tenant Configuration for more information.

Includes the following web applications:
* Ed-Fi Web API

## MultiTenant with ODS Context Configuration
This configuration shows a basic example of a multi tenant configuration with an explicit data segmentation strategy based on the school year. Deployment has one Admin, Security per tenant, and one ODS per school year. ODS for the school year is selected based on the school year in the API route segment. See Multi-Tenant Configuration and Context-Based Routing for Year-Specific ODS for more information.

Includes the following web applications:
* Ed-Fi Web API