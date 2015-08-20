CREATE TABLE tax_bills_june15_bbls AS (
SELECT a.bbl,
     MAX(CASE WHEN key = 'Owner name' THEN value END ) AS ownername,
     MAX(CASE WHEN key = 'Mailing address' THEN value END ) AS address,
     MAX(CASE WHEN key = 'tax class' THEN value END ) AS taxclass,
     MAX(CASE WHEN key = 'current tax rate' THEN value END ) AS taxrate,
     MAX(CASE WHEN key = 'estimated market value' THEN value END )::double precision AS emv,
     MAX(CASE WHEN key = 'tax before exemptions and abatements' THEN value END )::double precision AS tbea,
     --billable assessed value ended up in the meta column of tbea
     MAX(CASE WHEN key = 'tax before exemptions and abatements' THEN meta END )::double precision AS bav,
     MAX(CASE WHEN key = 'tax before abatements' THEN value END )::double precision AS tba,
     MAX(CASE WHEN key = 'annual property tax' THEN value END )::double precision AS propertytax,
     --join with condolookup to include condonum if the bbl is for a condo unit or lot
     MAX(b.condono) as condonumber,
     --make a condolot field for easy querying
     CASE 
      WHEN a.bbl % 10000 > 7500 AND a.bbl % 10000 < 7600 THEN 'lot' 
      WHEN a.bbl % 10000 > 1000 AND a.bbl % 10000 < 7000 THEN 'unit' END AS condo

  FROM "contrib/us/ny/nyc".tax_bills_raw a
  LEFT JOIN "contrib/us/ny/nyc".condo_lookup b ON a.bbl = b.bbl
  WHERE activitythrough = '2015-06-05'
  GROUP BY a.bbl
  ORDER BY a.bbl
);
