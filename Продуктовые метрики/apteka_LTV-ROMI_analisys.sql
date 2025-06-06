with t as (
	select 
		card,
		datetime::date as dt,
		summ_with_disc as summ,
		to_char(first_value(datetime::date) over(partition by card order by datetime::date), 'YYYY-MM') as cohort,
		to_char(datetime::date, 'YYYY-MM') as YM
	from bonuscheques
	order by card, dt
),
r as (
	select 
		cohort, 
		round(avg(floor(random()*(900000))+100000)) as spent
	from t
	group by cohort
	order by cohort
)
select 
	t.cohort,
	min(spent) as spent,
	sum(case when ym <= '2021-07' then summ end) as "2021-07 LTV",
	round((sum(case when ym <= '2021-07' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2021-07 ROMI",
	sum(case when ym <= '2021-08' then summ end) as "2021-08 LTV",
	round((sum(case when ym <= '2021-08' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2021-08 ROMI",
	sum(case when ym <= '2021-09' then summ end) as "2021-09 LTV",
	round((sum(case when ym <= '2021-09' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2021-09 ROMI",
	sum(case when ym <= '2021-10' then summ end) as "2021-10 LTV",
	round((sum(case when ym <= '2021-10' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2021-10 ROMI",
	sum(case when ym <= '2021-11' then summ end) as "2021-11 LTV",
	round((sum(case when ym <= '2021-11' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2021-11 ROMI",
	sum(case when ym <= '2021-12' then summ end) as "2021-12 LTV",
	round((sum(case when ym <= '2021-12' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2021-12 ROMI",
	sum(case when ym <= '2022-01' then summ end) as "2022-01 LTV",
	round((sum(case when ym <= '2022-01' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2022-01 ROMI",
	sum(case when ym <= '2022-02' then summ end) as "2022-02 LTV",
	round((sum(case when ym <= '2022-02' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2022-02 ROMI",
	sum(case when ym <= '2022-03' then summ end) as "2022-03 LTV",
	round((sum(case when ym <= '2022-03' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2022-03 ROMI",
	sum(case when ym <= '2022-04' then summ end) as "2022-04 LTV",
	round((sum(case when ym <= '2022-04' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2022-04 ROMI",
	sum(case when ym <= '2022-05' then summ end) as "2022-05 LTV",
	round((sum(case when ym <= '2022-05' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2022-05 ROMI",
	sum(case when ym <= '2022-06' then summ end) as "2022-06 LTV",
	round((sum(case when ym <= '2022-06' then summ end)-min(spent))*100.0/min(spent)) || '%' as "2022-06 ROMI"	
from t
join r on t.cohort=r.cohort
group by t.cohort
order by t.cohort




