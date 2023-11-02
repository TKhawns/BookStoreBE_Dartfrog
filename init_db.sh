#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        CREATE TABLE users (id TEXT,full_name TEXT,email TEXT,password TEXT,role TEXT);
EOSQL

