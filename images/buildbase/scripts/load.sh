UNIQUE=0
SEPARATOR=','
TABLE="${@: -1}"
INFILE=/share/${TABLE}.csv
while getopts "us:" opt; do
  case $opt in
    u) UNIQUE=1 ;;
    s) SEPARATOR=$OPTARG ;;
  esac
done

gosu postgres psql < /share/${TABLE}.schema

gosu postgres echo "
LOAD CSV FROM stdin
  INTO postgresql://postgres@localhost/postgres?$TABLE
  WITH skip header = 1,
       fields terminated by '$SEPARATOR';
" | tee /scripts/pgloader.load

if [ $UNIQUE ]; then
  gosu postgres tail -n +2 $INFILE | sort | uniq | pgloader /scripts/pgloader.load
else
  gosu postgres tail -n +2 $INFILE | pgloader /scripts/pgloader.load
fi

exit 0
