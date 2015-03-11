/*
 * Mortgage lending took a dive after the financial crisis.  Take a look at how
 * bad it was.
 */

SELECT
  COUNT(DISTINCT document_id) AS cnt,
  DATE_PART('year', recorded_datetime) AS year
  FROM acris_master
  WHERE doc_type = 'MTGE'
    AND recorded_datetime > '2000-01-01'
  GROUP BY year
  ORDER BY year;
