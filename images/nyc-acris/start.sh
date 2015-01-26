#!/bin/bash

echo "Gunzipping data..."
gunzip -v /raw/*.csv.gz

echo "Creating tables..."
gosu postgres psql < schema.sql

echo "Importing data..."
#pgloader pgloader.load

bin/bash
