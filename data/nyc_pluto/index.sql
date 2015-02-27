UPDATE nyc_pluto
  SET geom = ST_Transform(
    ST_SetSRID(ST_MakePoint(xcoord,ycoord), 2263) , 4326);
ALTER TABLE nyc_pluto ADD PRIMARY KEY ("bbl");
