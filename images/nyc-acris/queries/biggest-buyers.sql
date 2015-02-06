/*
 * It is common pratice to use a special-purpose corporation to buy properties
 * in New York; this makes it difficult to establish who owns a swathe of
 * properties by name only.  However, often filings are done from a single
 * address.  Which filing address was used to purchase the most properties last
 * year?
 */

SELECT
  COUNT(DISTINCT borough, block, lot) AS cnt,
  addr1, addr2, GROUP_CONCAT(name)
FROM acris
WHERE doc_type IN ('DEED', 'DEEDO')
GROUP BY addr1, addr2
ORDER BY cnt DESC
LIMIT 20;
