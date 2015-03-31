#!/bin/bash -e

if [ ! $1 ]; then
  echo 'Must specify name of data.json in github.com/talos/docker4data to build
as first argument.

    ./build.sh $NAME

'
  exit 1
fi

S3_BUCKET=data.docker4data.com
SQLDUMP=sqldump
NAME=$1

PWD=$(pwd)
TMPDIR=$(mktemp -d /tmp/docker4data-build.XXXX)

# Import the csv using the supplied schema
data_json=https://raw.githubusercontent.com/talos/docker4data/master/data/$NAME/data.json
echo $data_json

chown -R postgres:postgres $TMPDIR
METADATA_DIGEST=$(python /scripts/build.py $data_json $S3_BUCKET/$SQLDUMP $TMPDIR)
echo metadata digest: $METADATA_DIGEST

/scripts/dump.sh $NAME $TMPDIR/$NAME
DATA_DIGEST=$(sha1sum $TMPDIR/$NAME | cut -f 1 -d ' ')
echo data digest: $DATA_DIGEST

OLD_DATA_DIGEST=$(aws s3api head-object \
                  --bucket $S3_BUCKET \
                  --key $SQLDUMP/$NAME \
                  | grep data-sha1-hexdigest | cut -d '"' -f 4)
echo old data digest: $OLD_DATA_DIGEST

if [ "$OLD_DATA_DIGEST" == "$DATA_DIGEST" ]; then
  echo 'not uploading, nothing has changed'
else
  echo 'uploading new data'
  aws s3api put-object \
    --acl public-read \
    --bucket $S3_BUCKET \
    --key $SQLDUMP/$NAME \
    --metadata metadata-sha1-hexdigest=$METADATA_DIGEST \
    --metadata data-sha1-hexdigest=$DATA_DIGEST \
    --body $TMPDIR/$NAME
fi

echo removing data from $TMPDIR
rm -rf $TMPDIR
