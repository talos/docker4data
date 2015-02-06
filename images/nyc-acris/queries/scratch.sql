select count(*), date_part('year', document_date) as year
from acris_master
where document_date > '2000-01-01'
group by year
order by year;

select count(*), addr1, STRING_AGG(name, ',')
from acris_parties
group by addr1
order by count(*)
desc limit 20;
