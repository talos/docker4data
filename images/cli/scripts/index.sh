#!/bin/bash -e

###### socrata metadata non-batch
#
# curl -XDELETE http://127.0.0.1:9200/socrata
# curl -XPUT http://127.0.0.1:9200/socrata
# curl -XPUT http://127.0.0.1:9200/socrata/metadata/_mapping -d@map.json
# 
# for metadata in output/*/*; do
#   echo $metadata
#   id=$(basename ${metadata} .json)
#   portal=$(echo ${metadata} | cut -d '/' -f 2)
#   key=${portal}.${id}
#   curl -XPUT http://127.0.0.1:9200/socrata/metadata/$key -d @$metadata
#   echo ''
# done

# curl –XGET http://127.0.0.1:9200/socrata/metadata/_mapping?pretty=true
#
#



###### docker4data metadata non-batch
# 
# curl -XDELETE http://127.0.0.1:9200/docker4data
# curl -XPUT http://127.0.0.1:9200/docker4data
# 
# for dataset in ~/docker4data/data/* ; do #/data.json; do
#   #portal=$(echo ${metadata} | cut -d '/' -f 2)
#   #key=${portal}.${id}
# 
#   id=$(basename ${dataset})
#   curl -XPUT http://127.0.0.1:9200/docker4data/metadata/$id -d @$dataset/data.json
#   echo ''
# done
# curl –XGET http://127.0.0.1:9200/docker4data/metadata/_mapping?pretty=true
#
#


######## docker4data metadata batch

mkdir /git
cd /git && git clone https://github.com/talos/docker4data.git

#service elasticsearch start
/docker-entrypoint.sh elasticsearch &

echo Waiting for elasticsearch to start...
while : ; do
  curl -s http://127.0.0.1:9200 && break
  sleep 1
done

curl -XPUT http://127.0.0.1:9200/docker4data
python /scripts/index.py /git/docker4data/data/
#service elasticsearch stop
