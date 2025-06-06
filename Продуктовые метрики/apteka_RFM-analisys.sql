with filtered as (
	select datetime::date as dt,
	            card,
	            summ_with_disc as summ,
	            doc_id
          from bonuscheques b
          where length(card) < 14
),
grouped as (
	select card as clients,
	            max(dt) as last_visit,
	            count(distinct doc_id) as cnt_purchases,
	            sum(summ) as sum_purchases
	from filtered
	group by card
),
agg as (
	select clients,
	             last_visit,
	             date('2022-07-13') - last_visit as diff_days,
	             cnt_purchases,
	             sum_purchases
          from grouped
),
perc as (
select 'perc_of_day' as perc_name,
        percentile_disc(0.33) within group (order by diff_days) as "33%",
	             percentile_disc(0.66) within group (order by diff_days) as "66%"
          from agg
          union
          select 'perc_of_cnt' as perc_name,
	             percentile_disc(0.33) within group (order by cnt_purchases),
	             percentile_disc(0.66) within group (order by cnt_purchases)
          from agg
          union
          select 'perc_of_sum' as perc_name,
	             percentile_disc(0.33) within group (order by sum_purchases),
	             percentile_disc(0.66) within group (order by sum_purchases)
          from agg
),
rfm as (
	select clients,
	            diff_days,
	            case
	              when diff_days < 83 then '1'
	              when diff_days < 178 then '2'
	   	else '3'
	             end as "r_(recency)",
	             cnt_purchases,
	             case
	              when cnt_purchases = 1 then '3'
	              when cnt_purchases <= 3 then '2'
	   	else '1'
	             end as "f_(frequency)",   
	             sum_purchases,
	             case
	              when sum_purchases < 921 then '3'
	              when sum_purchases < 2395 then '2'
	              else '1'
	             end as "m_(monetary)"
         from agg
)
select category,
	   count(clients)
from (select clients,
	         concat("r_(recency)" || "f_(frequency)" || "m_(monetary)") as category
            from rfm
) t
group by category
order by category
