-----------RECEIPTS_DAILY_STATE-----------
CREATE OR REPLACE TABLE COLES.LIQUORLAND.RECEIPTS_DAILY_STATE
AS
SELECT
ITEMIDSKU,
UNITOFMEASURE,
DATE1,
BRANDID,
SUM(SUM_VAL_VIC) AS SUM_VAL_VIC,
SUM(SUM_QTY_VIC) AS SUM_QTY_VIC,
SUM(SUM_VAL_NSW) AS SUM_VAL_NSW,
SUM(SUM_QTY_NSW) AS SUM_QTY_NSW,
SUM(SUM_VAL_QLD) AS SUM_VAL_QLD,
SUM(SUM_QTY_QLD) AS SUM_QTY_QLD,
SUM(SUM_VAL_TAS) AS SUM_VAL_TAS,
SUM(SUM_QTY_TAS) AS SUM_QTY_TAS,
SUM(SUM_VAL_ACT) AS SUM_VAL_ACT,
SUM(SUM_QTY_ACT) AS SUM_QTY_ACT,
SUM(SUM_VAL_NT) AS SUM_VAL_NT,
SUM(SUM_QTY_NT) AS SUM_QTY_NT,
SUM(SUM_VAL_SA) AS SUM_VAL_SA,
SUM(SUM_QTY_SA) AS SUM_QTY_SA,
SUM(SUM_VAL_WA) AS SUM_VAL_WA,
SUM(SUM_QTY_WA) AS SUM_QTY_WA,
SUM(SUM_VAL_TTL) AS SUM_VAL_TTL,
SUM(SUM_QTY_TTL) AS SUM_QTY_TTL
FROM COLES.LIQUORLAND.VIEW_RECEIPTS_DAILY_BY_STATE
GROUP BY
ITEMIDSKU,
UNITOFMEASURE,
DATE1,
BRANDID;