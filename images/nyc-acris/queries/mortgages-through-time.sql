/*
 * Mortgage lending took a dive after the financial crisis.  Take a look at how
 * bad it was.
 */

SELECT
  COUNT(DISTINCT document_id) AS cnt,
  DATE_PART('year', document_date)
FROM acris
WHERE doc_type = 'MORTGAGE'
  AND document_date >= '2000-01-01'
GROUP BY DATE_PART('year', document_date)
ORDER BY DATE_PART('year', document_date);
