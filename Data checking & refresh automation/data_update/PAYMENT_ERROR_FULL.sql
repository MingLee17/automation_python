-----------PAYMENT_ERROR_FULL-----------
CREATE OR REPLACE TABLE COLES.LIQUORLAND.PAYMENT_ERROR_FULL
AS
SELECT O.REBATENO,
UPPER(I.DATAAREAID) AS DATAAREAID,
(I.REBATETYPE || I.REBATESCANMETHOD) AS REBATE_TYPE,
I.DESCRIPTION, I.ACTIVEINDICATOR, I.UNIT, I.REBATESCANLINE, I.CALCULATIONBASIS,
I.STARTDATE::DATE AS STARTDATE, I.ENDDATE::DATE AS ENDDATE,
I.DATEMODIFIED, I.REBATESCANCLASS, I.ACCRUALSONLY, I.REPORTED, I.INCLUDEINSUPPLIER,
A.ENDVENDACCOUNT, VD.NM AS VENDOR_NAME
FROM (SELECT DISTINCT A.REBATENO 
        FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_LIQ_REBATETRANS A
        WHERE A.REBATENO IN (SELECT REBATENO FROM (SELECT REBATENO, 
                                                            COUNT(DISTINCT REBATEDATETRANSREFRECID) AS COUNTDATETRANS 
                                                    FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_LIQ_REBATETRANS
                                                    GROUP BY REBATENO HAVING COUNTDATETRANS = 1))
        AND A.REBATEDATETRANSREFRECID = 0) O
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMREBATESCANDEAL I
ON O.REBATENO = I.REBATENO
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_LIQ_REBATETABLE A
ON O.REBATENO = A.REBATENO
LEFT JOIN (SELECT DISTINCT ACCOUNTNUMBER, "Name" AS NM FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMVENDOR
            WHERE UPPER(CURRENTRECORD) = 'CURRENT RECORD') VD
ON A.ENDVENDACCOUNT = VD.ACCOUNTNUMBER
--WHERE I.ENDDATE >= '2021-01-01'
ORDER BY A.ENDVENDACCOUNT, O.REBATENO;