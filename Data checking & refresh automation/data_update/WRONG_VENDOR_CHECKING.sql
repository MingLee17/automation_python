-----------WRONG_VENDOR_CHECKING-----------
CREATE OR REPLACE TABLE COLES.LIQUORLAND.WRONG_VENDOR_CHECKING
AS
SELECT DISTINCT C.VENDOR_NUMBER, C.VENDOR_NAME, C.REBATENO, C.ITEMID, C.STARTDATE, C.ENDDATE, C.BRANDID, C.STATE, P.ORDERACCOUNT, P.INVOICEACCOUNT
FROM COLES.LIQUORLAND.CD_FULL C
LEFT JOIN
	(SELECT DISTINCT ORDERACCOUNT, INVOICEACCOUNT, PACKINGSLIPID, ITEMID,
	DELIVERYDATE, DIMENSION5_ AS BRANDID, DESTSTATE AS STATE
	FROM COLES.LIQUORLAND.VENDOR_PACKING) P
ON P.ITEMID = C.ITEMID
AND P.BRANDID = C.BRANDID
AND P.STATE = C.STATE
AND P.DELIVERYDATE BETWEEN C.STARTDATE AND C.ENDDATE;