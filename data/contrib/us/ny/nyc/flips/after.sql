SELECT *
INTO deriv
FROM deeds
  WHERE recorded_datetime >= '2003-01-01'
  AND doc_type in ('DEED', 'DEEDO')
  AND document_amt > 100000
;

CREATE INDEX document_id on deriv (document_id);
CREATE INDEX bbl ON deriv (bbl);

SELECT document_id, count(distinct bbl) INTO acris_real_property_dupes FROM deriv GROUP BY document_id;
CREATE INDEX document_id_key on acris_real_property_dupes (document_id);

DELETE FROM deriv
WHERE document_id IN
  (SELECT document_id FROM acris_real_property_dupes WHERE "count" > 1);

SELECT
  before.document_id before_document_id,
  before.bbl bbl,
  before.document_date before_document_date,
  before.document_amt before_document_amt,
  before.recorded_datetime before_recorded_datetime,
  before.party_type before_party_type,
  before.name before_name,
  before.addr1 before_addr1,
  before.addr2 before_addr2,
  before.country before_country,
  before.city before_city,
  before.state before_state,
  before.zip before_zip,
  after.document_id after_document_id,
  after.document_date after_document_date,
  after.document_amt after_document_amt,
  after.recorded_datetime after_recorded_datetime,
  after.party_type after_party_type,
  after.name after_name,
  after.addr1 after_addr1,
  after.addr2 after_addr2,
  after.country after_country,
  after.city after_city,
  after.state after_state,
  after.zip after_zip,
  after.cd, after.ct2010, after.cb2010, after.council, after.zipcode,
  after.address, after.unitsres, after.unitstotal, after.yearbuilt,
  after.condono, after.geom
INTO flips_raw
FROM deriv before, deriv after
WHERE after.document_date - before.document_date BETWEEN 1 and 730
  AND before.document_amt * 1.5 < after.document_amt
  AND before.bbl = after.bbl;

SELECT bbl,
  MAX(before_document_date) before_document_date,
  MAX(after_document_date) after_document_date,
  MAX(before_document_amt) before_document_amt,
  MAX(after_document_amt) after_document_amt,
  MAX(after_document_amt::float) / MAX(before_document_amt) ratiopricediff,
  MAX(after_document_date) - MAX(before_document_date) dayspast,
  SUBSTR(STRING_AGG(CASE WHEN before_party_type = 1 THEN before_name ELSE NULL END, '|'), 0, 255) AS sellers_before,
  SUBSTR(STRING_AGG(CASE WHEN before_party_type = 2 THEN before_name ELSE NULL END, '|'), 0, 255) AS buyers_before,
  SUBSTR(STRING_AGG(CASE WHEN after_party_type = 1 THEN after_name ELSE NULL END, '|'), 0, 255) AS sellers_after,
  SUBSTR(STRING_AGG(CASE WHEN after_party_type = 2 THEN after_name ELSE NULL END, '|'), 0, 255) AS buyers_after,
  MAX(after.cd) cd,
  MAX(after.ct2010) ct2010,
  MAX(after.cb2010) cb2010,
  MAX(after.council) council,
  MAX(after.zipcode) zipcode,
  MAX(after.address) address,
  MAX(after.unitsres) unitsres,
  MAX(after.unitstotal) unitstotal,
  MAX(after.yearbuilt) yearbuilt,
  MAX(after.condono) condono,
  MAX(after.geom) geom
INTO flips
FROM flips_raw
GROUP BY bbl;
