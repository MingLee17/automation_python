--------ALL_ALL_VENDTRANS--------
---MISSING CHECK
SELECT to_char(TRANSDATE,'YYYY-MM') trans_month, count(*) trans_count
FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_VENDTRANS
WHERE TRANSDATE >= '2021-01-01'
GROUP BY trans_month
ORDER BY trans_month;

