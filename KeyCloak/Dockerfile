FROM quay.io/keycloak/keycloak:23.0.6

# Make the realm configuration available for import
COPY realm-and-users.json /opt/keycloak/data/import/

# The Keycloak server is configured to listen on port 28080
EXPOSE 28080
EXPOSE 8443

# Import the realm on start-up
CMD ["start-dev --import-realm"]
