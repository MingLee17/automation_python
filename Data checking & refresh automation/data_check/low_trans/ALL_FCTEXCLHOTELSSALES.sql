--------ALL_FCTEXCLHOTELSSALES--------
---LOW TRANS BY DAILY
WITH DAILY_SLS AS (select to_char(TIMEOFSALE,'YYYY-MM-DD') _TIMEOFSALE, count(*) cnt
from COLES_CLEAN.LIQUORLAND_MERCH.ALL_FCTEXCLHOTELSSALES group by _TIMEOFSALE)
select * from 
(select '2021-01-01'::date + row_number() over(order by 0) day_d
from table(generator(rowcount => 800))) a
left join DAILY_SLS  b on a.day_d=b._TIMEOFSALE
LEFT JOIN (SELECT ROUND(AVG(cnt)*0.25,2) AVG_cnt_25,
    ROUND(AVG(cnt),2) AVG 
    FROM DAILY_SLS) C
WHERE B.CNT IS NULL OR B.CNT<AVG_cnt_25
ORDER BY a.day_d; 
