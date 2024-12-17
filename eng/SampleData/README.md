# Sample data.

We created this short script in order to be able to have some sample data on any of the ods databases.
The final goal is to be able to generate some e2e tests.

## How it works.

Once the Docker containers are up and running, we need to execute an extra script `./SampleData.sh`. 
Internally, this file does a docker exec, so everything happens internally in the Docker container.

At a high level, it is going to do 2 things:

1. Download, unzip and restore the 7z Postgres backup file.

2. Since these backups (for example Northridge) don't have the `changeversion` column, we need to execute some extra scripts in order to add that column. Otherwise the Ods Api won't work.
To do this we download the corresponding arfect from Azure.

## Steps to populate the databases

1. Follow the regular steps to run the containers on Postgres with multitenant mode.

2. Create a .env file using `.env.example` as a reference. If you just rename the file, it should work as well.

3. Open a bash terminal, go to this folder, and run the following command on bash terminal 

```bash
./SampleData.sh
```

## Some other notes.

At this point it has been tested on PGSQL Multitenant environment.

Given that the 7z Postgres backup does not have the tpdm extension, when running the Docker containers the flah TPDM_ENABLED should be set to false.
