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
DIGEST=$(python /scripts/build.py $data_json $S3_BUCKET/$SQLDUMP $TMPDIR)
echo $DIGEST

/scripts/dump.sh $NAME $TMPDIR/$NAME

#aws s3 cp --acl public-read $TMPDIR/$NAME $S3_BUCKET/$SQLDUMP/$NAME
aws s3api put-object --acl public-read --bucket $S3_BUCKET \
  --key $SQLDUMP/$NAME --metadata metadata-sha1-hexdigest=$DIGEST --body $TMPDIR/$NAME

rm -r $TMPDIR
