ALTER TABLE "contrib".us_ny_nyc_pluto ADD COLUMN geom GEOMETRY;
UPDATE "contrib".us_ny_nyc_pluto
  SET geom = ST_Transform(
    ST_SetSRID(ST_MakePoint(xcoord,ycoord), 2263) , 4326);
ALTER TABLE "contrib".us_ny_nyc_pluto ADD PRIMARY KEY ("bbl");
VACUUM ANALYZE "contrib".us_ny_nyc_pluto;
