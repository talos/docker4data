UPDATE nyc_acris_legals
   SET bbl = CAST(CAST(borough AS TEXT) ||
                 RIGHT('00000' || CAST(block AS TEXT), 5) ||
                 RIGHT('0000' || CAST(lot AS TEXT),  4) AS BIGINT);
CREATE INDEX ON nyc_acris_legals ("document_id", "good_through_date");
CREATE INDEX ON nyc_acris_legals ("bbl");
