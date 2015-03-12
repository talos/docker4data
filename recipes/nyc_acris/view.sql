CREATE VIEW nyc_acris
AS SELECT m.*, l.partial_lot, l.air_rights, l.subterranean_rights,
          l.property_type, l.street_number, l.street_name, l.addr_unit,
          p.name, p.party_type, p.addr1, p.addr2, p.country, p.city, p.state,
          p.zip, pl.*
FROM nyc_acris_master m
  JOIN nyc_acris_parties p ON m.document_id = p.document_id
  JOIN nyc_acris_legals l ON l.document_id = m.document_id
  JOIN nyc_pluto pl ON pl.bbl = l.bbl;
