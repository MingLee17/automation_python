-----------NO_INFO-----------
CREATE OR REPLACE TABLE COLES.LIQUORLAND.CD_NO_INFO
AS
SELECT
CASE
WHEN LENGTH(TRIM(BRAND_STATE))-LENGTH(REPLACE(TRIM(BRAND_STATE), '-', '')) = 2 THEN TRIM(STATE)
WHEN LENGTH(TRIM(BRAND_STATE))-LENGTH(REPLACE(TRIM(BRAND_STATE), '-', '')) = 1 THEN SPLIT_PART(TRIM(BRAND_STATE),'-',2)
ELSE TRIM(STATE)
END AS STATE,
BRANDID,
DESCRIPTION,
STARTDATE::DATE AS STARTDATE,
ENDDATE::DATE AS ENDDATE,
REBATESCANLINE,
REBATENO,
ITEMID,
UNITOFMEASURE,
CRITERIA,
REBATEREFID,
REFTABLEID,
REFRECID,
REBATEPOSTED,
CLAIMREFID,
CLAIMTABLEID,
PRODUCTCATEGORY,
REVERSALCLAIMREFID,
CLM_PER_UNIT,
CLM_QTY,
CLM_VAL,
CD_TYPE,
REBATE_ENTITLEMENT_NUM,
MULTIPLIER_NUM,
0 AS ENTITLEMENT_AMT,
0 AS CLM_WET,
'NO INFO' AS REBATESCANCLASS,
0 AS REVERSED,
'NO INFO' AS VENDOR_NUMBER,
'NO INFO' AS VENDOR_NAME
FROM
(SELECT
A.STATE,
A.BRAND_STATE,
A.BRANDID,
A.DESCRIPTION,
A.STARTDATE,
A.ENDDATE,
A.REBATESCANLINE,
A.REBATENO,
A.ITEMID,
A.UNITOFMEASURE,
A.CRITERIA,
A.REBATEREFID,
A.REFTABLEID,
A.REFRECID,
A.REBATEPOSTED,
A.CLAIMREFID,
A.CLAIMTABLEID,
A.PRODUCTCATEGORY,
A.REVERSALCLAIMREFID,
A.CLM_PER_UNIT,
A.CLM_QTY,
A.CLM_VAL,
(C.REBATETYPE || C.REBATESCANMETHOD)::VARCHAR AS CD_TYPE,
NULLIF (SPLIT_PART(SPLIT_PART(A.REBATESCANLINE, ',', 3), ':',2),'')::NUMBER(38,2) AS REBATE_ENTITLEMENT_NUM,
NULLIF (SPLIT_PART(SPLIT_PART(A.REBATESCANLINE, ',', 4), ':',2),'')::NUMBER(38,2) AS MULTIPLIER_NUM
FROM
(SELECT
	STATE,
	BRAND_STATE,
	BRANDID,
	DESCRIPTION,
	STARTDATE AS STARTDATE,
	ENDDATE AS ENDDATE,
	REBATESCANLINE,
	REBATENO,
	ITEMID,
	UNITOFMEASURE,
	CRITERIA,
	REBATEREFID,
	REFTABLEID,
	REFRECID,
	REBATEPOSTED,
	CLAIMREFID,
	CLAIMTABLEID,
	PRODUCTCATEGORY,
	REVERSALCLAIMREFID,
	CASE WHEN SUM(CLM_QTY) = 0 THEN 0 ELSE SUM(CLM_VAL)/SUM(CLM_QTY) END AS CLM_PER_UNIT,
	SUM(CLM_QTY) AS CLM_QTY,
	SUM(CLM_VAL) AS CLM_VAL
    FROM
(SELECT
	L.ADDRESSSTATE AS STATE,
	L.STATE AS BRAND_STATE,
	B.BRANDID,
	CH.DESCRIPTION,
	CH.STARTDATE AS STARTDATE,
	CH.ENDDATE AS ENDDATE,
	RCD.REBATESCANLINE,
	CD.REBATENO,
	RCMSTOREID,
	ITEMID,
	UPPER(CH.UNITID) AS UNITOFMEASURE,
	CD.CRITERIA,
	CLAIMBASE AS CLM_QTY,
	CLAIMAMOUNT AS CLM_VAL,
	REBATEREFID,
	REFTABLEID,
	REFRECID,
	REBATEPOSTED,
	CLAIMREFID,
	CLAIMTABLEID,
	PRODUCTCATEGORY,
	REVERSALCLAIMREFID
FROM (SELECT * FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_LIQ_REBATETRANS A
    WHERE A.REBATENO NOT IN (SELECT DISTINCT B.REBATENO FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_LIQ_REBATEDATETRANS B)) CD
	LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMSTORE L
	ON CD.RCMSTOREID = L.STOREID AND UPPER(L.CURRENTRECORD) = 'CURRENT RECORD'
	LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMBRAND B
	ON L.DIMBRANDID = B.DIMBRANDID
	LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_LIQ_REBATETABLE CH
	ON CD.REBATENO = CH.REBATENO
	LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMREBATESCANDEAL RCD
	ON CD.REBATENO = RCD.REBATENO) T
    GROUP BY
STATE,
BRAND_STATE,
BRANDID,
DESCRIPTION,
STARTDATE,
ENDDATE,
REBATESCANLINE,
REBATENO,
ITEMID,
UNITOFMEASURE,
CRITERIA,
REBATEREFID,
REFTABLEID,
REFRECID,
REBATEPOSTED,
CLAIMREFID,
CLAIMTABLEID,
PRODUCTCATEGORY,
REVERSALCLAIMREFID) A
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMREBATESCANDEAL C
ON A.REBATENO = C.REBATENO
) T2;