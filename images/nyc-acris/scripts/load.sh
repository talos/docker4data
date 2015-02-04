UNIQUE=0
SEPARATOR=','
TABLE="${@: -1}"
INFILE=/csv/${TABLE}.csv
while getopts "us:" opt; do
  case $opt in
    u) UNIQUE=1 ;;
    s) SEPARATOR=$OPTARG ;;
  esac
done

echo "
LOAD CSV FROM stdin
  INTO postgresql://postgres@localhost/postgres?$TABLE
  WITH skip header = 1,
       fields terminated by '$SEPARATOR';
" | tee /scripts/pgloader.load

if [ $UNIQUE ]; then
  tail -n +2 $INFILE | sort | uniq | pgloader /scripts/pgloader.load
else
  tail -n +2 $INFILE | pgloader /scripts/pgloader.load
fi

exit 0

#echo $UNIQUE
#echo $SEPARATOR
#echo "
#LOAD CSV FROM stdin
#    INTO postgresql://postgres@localhost/postgres?pluto
#    WITH skip header = 1,
#         fields terminated by '\t';
#" | tee /scripts/pgloader.load
#cat /csv/pluto.csv | pgloader /scripts/pgloader.load
