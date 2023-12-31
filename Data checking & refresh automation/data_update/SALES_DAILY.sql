-----------SALES_DAILY-----------
CREATE OR REPLACE TABLE COLES.LIQUORLAND.SALES_DAILY
AS
SELECT ITEMIDSKU, UNITOFMEASURE, BRANDID, DATE1,
SUM(SLS_QTY_VIC) AS SLS_QTY_VIC, SUM(SLS_VAL_VIC) AS SLS_VAL_VIC,
SUM(SLS_QTY_NSW) AS SLS_QTY_NSW, SUM(SLS_VAL_NSW) AS SLS_VAL_NSW,
SUM(SLS_QTY_QLD) AS SLS_QTY_QLD, SUM(SLS_VAL_QLD) AS SLS_VAL_QLD,
SUM(SLS_QTY_TAS) AS SLS_QTY_TAS, SUM(SLS_VAL_TAS) AS SLS_VAL_TAS,
SUM(SLS_QTY_ACT) AS SLS_QTY_ACT, SUM(SLS_VAL_ACT) AS SLS_VAL_ACT,
SUM(SLS_QTY_NT) AS SLS_QTY_NT, SUM(SLS_VAL_NT) AS SLS_VAL_NT,
SUM(SLS_QTY_SA) AS SLS_QTY_SA, SUM(SLS_VAL_SA) AS SLS_VAL_SA,
SUM(SLS_QTY_WA) AS SLS_QTY_WA, SUM(SLS_VAL_WA) AS SLS_VAL_WA,
SUM(SLS_QTY_TTL) AS SLS_QTY_TTL, SUM(SLS_VAL_TTL) AS SLS_VAL_TTL
FROM (SELECT *,
CASE WHEN STATE='VIC' THEN ITEMQUANTITY ELSE 0 END AS SLS_QTY_VIC, CASE WHEN STATE='VIC' THEN TOTALLINESALE_EX ELSE 0 END AS SLS_VAL_VIC,
CASE WHEN STATE='NSW' THEN ITEMQUANTITY ELSE 0 END AS SLS_QTY_NSW, CASE WHEN STATE='NSW' THEN TOTALLINESALE_EX ELSE 0 END AS SLS_VAL_NSW,
CASE WHEN STATE='QLD' THEN ITEMQUANTITY ELSE 0 END AS SLS_QTY_QLD, CASE WHEN STATE='QLD' THEN TOTALLINESALE_EX ELSE 0 END AS SLS_VAL_QLD,
CASE WHEN STATE='TAS' THEN ITEMQUANTITY ELSE 0 END AS SLS_QTY_TAS, CASE WHEN STATE='TAS' THEN TOTALLINESALE_EX ELSE 0 END AS SLS_VAL_TAS,
CASE WHEN STATE='ACT' THEN ITEMQUANTITY ELSE 0 END AS SLS_QTY_ACT, CASE WHEN STATE='ACT' THEN TOTALLINESALE_EX ELSE 0 END AS SLS_VAL_ACT,
CASE WHEN STATE='NT' THEN ITEMQUANTITY ELSE 0 END AS SLS_QTY_NT, CASE WHEN STATE='NT' THEN TOTALLINESALE_EX ELSE 0 END AS SLS_VAL_NT,
CASE WHEN STATE='SA' THEN ITEMQUANTITY ELSE 0 END AS SLS_QTY_SA, CASE WHEN STATE='SA' THEN TOTALLINESALE_EX ELSE 0 END AS SLS_VAL_SA,
CASE WHEN STATE='WA' THEN ITEMQUANTITY ELSE 0 END AS SLS_QTY_WA, CASE WHEN STATE='WA' THEN TOTALLINESALE_EX ELSE 0 END AS SLS_VAL_WA,
ITEMQUANTITY AS SLS_QTY_TTL,
TOTALLINESALE_EX AS SLS_VAL_TTL
FROM COLES.LIQUORLAND.SALES_ALL_FINAL) S
GROUP BY ITEMIDSKU, UNITOFMEASURE, BRANDID, DATE1;