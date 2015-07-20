#!/bin/bash -e

if [ ! $1 ]; then
  echo 'Must specify name of data.json in github.com/talos/docker4data to
process as first argument.

    ./build.sh $PATH_IN_DATA_DIR

'
  exit 1
fi

S3_BUCKET=data.docker4data.com
SQLDUMP=sqldump
FULLNAME=$1

PWD=$(pwd)
#TMPDIR=$(mktemp -d /tmp/docker4data-build.XXXX)
TMPDIR=/tmp/$FULLNAME
rm -rf $TMPDIR
mkdir -p $TMPDIR

# Import the csv using the supplied schema
echo processing $FULLNAME

chown -R postgres:postgres $TMPDIR
METADATA_DIGEST=$(python /scripts/process.py /docker4data/data/$FULLNAME/data.json $S3_BUCKET/$SQLDUMP $TMPDIR)
echo metadata digest: $METADATA_DIGEST

DUMP=$TMPDIR/dump
/scripts/dump.sh $FULLNAME $DUMP

if [ ! -s $TMPDIR/data ]; then
    echo "WARNING $TMDIR/data is of length 0, aborting"
    exit 1
fi

# Calculate data digest from raw gzipped data, as SQL dumps change.
DATA_DIGEST=$(sha1sum $TMPDIR/data | cut -f 1 -d ' ')
echo data digest: $DATA_DIGEST

KEY=$SQLDUMP/$FULLNAME
OLD_DATA_DIGEST=$(aws s3api head-object \
                  --bucket $S3_BUCKET \
                  --key $KEY \
                  | grep \"data_sha1_hexdigest | cut -d '"' -f 4)
echo old data digest: $OLD_DATA_DIGEST

if [ "$OLD_DATA_DIGEST" == "$DATA_DIGEST" ]; then
  echo 'updating metadata but not data, as it has not changed'
  aws s3api put-object \
    --acl public-read \
    --bucket $S3_BUCKET \
    --key $KEY \
    --metadata "metadata_sha1_hexdigest=$METADATA_DIGEST,data_sha1_hexdigest=$DATA_DIGEST"
else
  echo 'uploading new data'
  aws s3api put-object \
    --acl public-read \
    --bucket $S3_BUCKET \
    --key $KEY \
    --metadata "metadata_sha1_hexdigest=$METADATA_DIGEST,data_sha1_hexdigest=$DATA_DIGEST" \
    --body $DUMP
fi

#echo removing data from $TMPDIR
#rm -rf $TMPDIR
