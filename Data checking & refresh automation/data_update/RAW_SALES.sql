-----------RAW_SALES-----------
CREATE OR REPLACE TABLE COLES.LIQUORLAND.RAW_SALES
AS
SELECT
SS.FCTEXCLHOTELSSALESID,
DD."Date" AS DATE1,
SS.TIMEOFSALE,
SS.DIMHOUROFDAYID,
SS.DATECREATED,
DIMREBATEDATEID,
DS.ITEMIDSKU,
DS.ITEMNAME,
DS.ITEMCATEGORY,
DS.UNITOFMEASURE,
DC.CHANNEL,
DSR.CLASSIFICATION,
DSR.REASONCODE,
HU.BRANDID AS STOREBRANDID,
HU.STATE,
DST.STORENAME,
SS.DIMTILLOPERATORID,
DBR.BRANDID,
DSTT.SALESTRANSACTIONTYPE,
DV.ACCOUNTNUMBER,
DV."Name" AS VENDOR_NAME,
SALETRANSACTIONNUMBER,
SALETRANSACTIONLINENUMBER,
ITEMQUANTITY,
ITEMPRICE,
TOTALLINEDISCOUNTS,
TOTALLINESALE,
AVERAGEITEMSELLPRICE,
TOTALLINEGST,
ITEMCOGS,
TOTALLINECOGS,
DIMPROMOPRICEADVDISC1ID,
DIMPROMOPRICEADVDISC2ID,
DIMPROMOPRICEADVDISC3ID,
DIMPROMOPRICEADVDISC4ID,
PROMO1DISCOUNT,
PROMO2DISCOUNT,
PROMO3DISCOUNT,
PROMO4DISCOUNT,
DIMFLYBUYSID,
DIMTEAMMEMBERID,
TEAMMEMBERDISCOUNT,
PRICEOVERRIDEDISCOUNT,
CELLARSHAREDISCOUNT,
WINECLUBCARDNUMBER,
ITEMQUANTITYSINGLES
FROM
(SELECT * FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_FCTEXCLHOTELSSALES
WHERE DIMDATEID::NUMBER(6,0)>=44195 --BETWEEN 44195 AND 44863
) SS
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMDATE DD
ON SS.DIMDATEID = DD.DIMDATEID
LEFT JOIN (SELECT DISTINCT DIMSALEITEMID, ITEMIDSKU, ITEMCATEGORY, UNITOFMEASURE, TRIM(UPPER(FIRST_VALUE(ITEMNAME) OVER (PARTITION BY ITEMIDSKU ORDER BY LENGTH(ITEMNAME) DESC))) AS ITEMNAME FROM COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMSALEITEM) DS
ON SS.DIMSALEITEMID = DS.DIMSALEITEMID 
--AND (SS.TIMEOFSALE > ROWEFFECTIVEFROM AND SS.TIMEOFSALE <= ROWEFFECTIVETO)
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMCHANNEL DC
ON SS.DIMCHANNELID = DC.DIMCHANNELID
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMSALEREASONCODE DSR
ON SS.DIMSALEREASONCODEID = DSR.DIMSALEREASONCODEID
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMSTORE DST
ON SS.DIMSTOREID = DST.DIMSTOREID
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMSALESTRANSACTIONTYPE DSTT
ON SS.DIMSALESTRANSACTIONTYPEID = DSTT.DIMSALESTRANSACTIONTYPEID
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMVENDOR DV
ON SS.DIMVENDORID = DV.DIMVENDORID
LEFT JOIN COLES.LIQUORLAND.VIEW_DIMSTORE HU
--COLES.LIQUORLAND.LIQUOR_20210101_20221031_DIMSTORE_HU_UPDATED HU
ON SS.DIMSTOREID = HU.DIMSTOREID
LEFT JOIN COLES_CLEAN.LIQUORLAND_MERCH.ALL_DIMBRAND DBR
ON SS.DIMBRANDID = DBR.DIMBRANDID; --6M2S
