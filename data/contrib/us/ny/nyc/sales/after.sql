CREATE TABLE sales
AS
SELECT * FROM "socrata/data.cityofnewyork.us".acris_real_property_master,
              "socrata/data.cityofnewyork.us".acris_real_property_legals,
              "socrata/data.cityofnewyork.us".acris_real_property_parties;
