source ./.env

cat <<EOF | docker exec --interactive --user root ed-fi-db-ods-tenant1 sh
apk add --update --no-cache p7zip
cd /tmp
wget $PGSQL_BACKUPFILE_URL
7z e ./$PGSQL_BACKUPFILE_7Z_FILENAME
psql --host=localhost --port 5432 --username=$POSTGRES_USER -c "drop database if exists \"EdFi_Ods\" WITH (FORCE);" -c "create database \"EdFi_Ods\";"
psql --host=localhost --port 5432 --username=$POSTGRES_USER --dbname="EdFi_Ods" -f './$PGSQL_BACKUPFILE_SQL_FILENAME';
rm ./$PGSQL_BACKUPFILE_SQL_FILENAME $PGSQL_BACKUPFILE_7Z_FILENAME

wget https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.RestApi.Databases.Standard.$PGSQL_CHANGEVERSION_DATA_STANDARD/versions/$PGSQL_CHANGEVERSION_VERSION/content -O $PGSQL_CHANGEVERSION_SCRIPTS_FILENAME
unzip $PGSQL_CHANGEVERSION_SCRIPTS_FILENAME -d ./EdFi.Suite3.RestApi.Databases.Standard/

cd /tmp/EdFi.Suite3.RestApi.Databases.Standard/Ed-Fi-ODS/Application/EdFi.Ods.Standard/Standard/$PGSQL_CHANGEVERSION_DATA_STANDARD/Artifacts/PgSql/Structure/Ods/Changes
psql --host=localhost --port 5432 --username=$POSTGRES_USER --dbname="EdFi_Ods" -f './0010-CreateChangesSchema.sql';
psql --host=localhost --port 5432 --username=$POSTGRES_USER --dbname="EdFi_Ods" -f './0020-CreateChangeVersionSequence.sql';
psql --host=localhost --port 5432 --username=$POSTGRES_USER --dbname="EdFi_Ods" -f './0030-AddColumnChangeVersionForTables.sql';
psql --host=localhost --port 5432 --username=$POSTGRES_USER --dbname="EdFi_Ods" -f './0070-AddIndexChangeVersionForTables.sql';
EOF