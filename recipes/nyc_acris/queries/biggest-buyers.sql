/*
 * It is common pratice to use a special-purpose corporation to buy properties
 * in New York; this makes it difficult to establish who owns a swathe of
 * properties by name only.  However, often filings are done from a single
 * address.  Which filing address was used to purchase the most properties last
 * year?
 */
  --COUNT(DISTINCT cast(borough as bigint) * 1000000000 + block * 10000 + lot) AS cnt,

SELECT
  COUNT(DISTINCT m.document_id) cnt,
  addr1, addr2, STRING_AGG(DISTINCT name, '; ')
  FROM nyc_acris_master m, nyc_acris_parties p
  WHERE doc_type IN ('DEED', 'DEEDO')
    AND DATE_PART('year', document_date) = 2014
    AND party_type = 2
    AND m.document_id = p.document_id
  GROUP BY addr1, addr2
  ORDER BY cnt DESC
  LIMIT 20;

