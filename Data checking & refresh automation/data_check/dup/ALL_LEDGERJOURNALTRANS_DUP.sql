--------ALL_LEDGERJOURNALTRANS--------
---DUP CHECK
SELECT COUNT(RECID), COUNT(DISTINCT RECID),
    COUNT(RECID) - COUNT(DISTINCT RECID) AS DIFF
FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_LEDGERJOURNALTRANS;
