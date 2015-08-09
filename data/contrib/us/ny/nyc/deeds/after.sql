CREATE TABLE deeds_master
AS
SELECT DISTINCT (
       CASE substr(document_id, 0, 3)
          WHEN '20' THEN document_id
          WHEN 'FT' THEN '100' || substr(document_id, 4)
          WHEN 'BK' THEN '000' || substr(document_id, 4)
          ELSE document_ID END)::BIGINT as document_id,
       m.good_through_date, m.document_date,
       m.document_amt, m.recorded_datetime, m.modified_date,
       dcc.doc__type_description, dcc.doc__type as doc_type
 FROM "socrata/data.cityofnewyork.us".acris_real_property_master m,
      "socrata/data.cityofnewyork.us".acris_document_control_codes dcc
WHERE dcc.class_code_description = 'DEEDS AND OTHER CONVEYANCES' AND
      dcc.doc__type = m.doc_type
;

DELETE FROM deeds_master USING deeds_master alias
  WHERE deeds_master.document_id = alias.document_id AND
    deeds_master.good_through_date < alias.good_through_date;

CREATE UNIQUE INDEX deeds_master_docid ON deeds_master (document_id);

CREATE TABLE deeds_parties
AS
SELECT DISTINCT m.document_id, p.good_through_date,
      CASE p.party_type WHEN '1' THEN dcc.party1_type
                        WHEN '2' THEN dcc.party2_type
                        WHEN '3' THEN dcc.party3_type
      ELSE p.party_type END AS party_type,
      p.name, p.addr1, p.addr2, p.country, p.city, p.state, p.zip
FROM "socrata/data.cityofnewyork.us".acris_real_property_parties p,
     deeds_master m,
     "socrata/data.cityofnewyork.us".acris_document_control_codes dcc
WHERE (CASE substr(p.document_id, 0, 3)
          WHEN '20' THEN p.document_id
          WHEN 'FT' THEN '100' || substr(p.document_id, 4)
          WHEN 'BK' THEN '000' || substr(p.document_id, 4)
          ELSE p.document_id END)::BIGINT = m.document_id AND
      m.good_through_date = p.good_through_date AND
      SUBSTR(p.document_id, 4) ~ '^[0-9]+$' AND
      dcc.doc__type = m.doc_type;
CREATE INDEX deeds_parties_docid ON deeds_parties (document_id);

CREATE TABLE deeds_legals
AS
SELECT DISTINCT m.document_id, m.good_through_date,
       (borough * 1000000000) + (block * 10000) + lot as bbl,
       l.easement, l.partial_lot, l.air_rights, l.subterranean_rights,
       l.property_type, l.addr_unit
FROM "socrata/data.cityofnewyork.us".acris_real_property_legals l,
     deeds_master m WHERE (CASE substr(l.document_id, 0, 3)
          WHEN '20' THEN l.document_id
          WHEN 'FT' THEN '100' || substr(l.document_id, 4)
          WHEN 'BK' THEN '000' || substr(l.document_id, 4)
          ELSE l.document_id END)::BIGINT = m.document_id AND
      m.good_through_date = l.good_through_date;
CREATE INDEX deeds_legals_docid ON deeds_legals (document_id);

CREATE MATERIALIZED VIEW deeds AS
SELECT m.*, l.easement, l.partial_lot, l.air_rights, l.subterranean_rights,
       l.property_type, l.addr_unit, party_type,
      p.name, p.addr1, p.addr2, p.country, p.city, p.state, p.zip, pl.cd,
      pl.ct2010, pl.cb2010, pl.council, pl.zipcode, pl.address, pl.unitsres,
      pl.unitstotal, pl.yearbuilt, pl.condono, pl.geom
FROM deeds_legals l, deeds_master m, deeds_parties p, "contrib/us/ny/nyc".pluto pl
WHERE l.document_id = m.document_id
      AND m.document_id = p.document_id
      AND l.bbl = pl.bbl;
