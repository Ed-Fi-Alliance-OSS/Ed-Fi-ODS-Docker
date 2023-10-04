# PgSql MultiTenant with ODS Context Configuration Example
This configuration shows a basic example of a multi tenant configuration with an explicit data segmentation strategy based on the school year. Deployment has one Admin, Security per tenant, and one ODS per school year. ODS for the school year is selected based on the school year in the API route segment. See Multi-Tenant Configuration and Context-Based Routing for Year-Specific ODS for more information.

Includes the following web applications:
* Ed-Fi Web API