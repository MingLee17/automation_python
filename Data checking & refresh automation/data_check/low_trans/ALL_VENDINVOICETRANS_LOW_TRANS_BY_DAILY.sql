--------ALL_VENDINVOICETRANS--------
---LOW TRANS BY DAILY
WITH DAILY_SLS AS (select INVOICEDATE, count(*) cnt
from COLES_CLEAN.LIQUORLAND_MERCH.ALL_VENDINVOICETRANS group by INVOICEDATE)
select * from 
(select '2021-01-01'::date + row_number() over(order by 0) day_d
from table(generator(rowcount => 1000))) a
left join DAILY_SLS  b on a.day_d=b.INVOICEDATE
LEFT JOIN (SELECT ROUND(AVG(cnt)*0.25,2) AVG_cnt_25,
    ROUND(AVG(cnt),2) AVG
    FROM DAILY_SLS) C
WHERE B.CNT IS NULL OR B.CNT<AVG_cnt_25
ORDER BY a.day_d; ------ RETURN 138 RESULTS

