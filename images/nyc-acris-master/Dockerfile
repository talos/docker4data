FROM scratch

COPY dump /

# # download data
# wget http://www.opendatacache.com/data.cityofnewyork.us/api/views/bnx9-e6tj/rows.csv -O /csv/nyc_acris_master.csv
# 
# # import it into database
# scripts/load.sh -u -s ',' nyc_acris_master
# 
# # dump it into /dump
# time gosu postgres pg_dump -d postgres -F custom -Z 9 -t nyc_acris_master -f /dump/master
