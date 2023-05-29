/* Top 5 states with max domestic tourist in 2021 and 2022 */
select top 5 max(_2021_Domestic) as maxtourist,MAX(_2022_R_Domestic),State_UT FROM [domestic and foreign]
where not State_UT='Total' group by State_UT order by maxtourist desc

 /*Top 5 states with max foreign tourist in 2021 and 2022 */
 select top 5 max(_2021_foreign) as maxtourist,MAX(_2022_R_Foreign),State_UT FROM [domestic and foreign]
 where not State_UT='Total' group by State_UT order by maxtourist desc
 
/* Highest Growth Rate FOR DOMESTIC*/
select top 1 max(growth_rate_Domestic) as domesticrat,State_UT from [domestic and foreign]
group by state_ut order by domesticrat desc


/* Highest Growth Rate FOR foreign*/
select top 1 max(growth_rate_foreign) as foreignrate,State_UT from [domestic and foreign] 
group by state_ut order by foreignrate desc

/* lowest Growth Rate FOR DOMESTIC*/
select top 1 min(growth_rate_Domestic) as domesticrat,State_UT from [domestic and foreign]
group by state_ut order by domesticrat 

/* lowest Growth Rate FOR foreign*/
select top 1 min(growth_rate_foreign) as foreignrate,State_UT from [domestic and foreign]
group by state_ut order by foreignrate 

/* no of arrivals from different nationality*/
select sum(arrivals) as total_arrivals,nationality from [foreign tourism]
where not country_of_nationality='Total' and not nationality='Grand Total'group by nationality order by total_arrivals desc

/* no of arrivals from different country*/
select country_of_nationality,arrivals from [foreign tourism]
where not country_of_nationality in ('total','Grand total','others') order by arrivals desc

/*People coming from all different nationality*/
select distinct(nationality) from [foreign tourism] 
where not nationality in('Grand total','not classified elsewhere')

/* 5th highest arrival from a country*/
select * from (select country_of_nationality,arrivals,ROW_NUMBER() over (order by arrivals desc) as rn from [foreign tourism]
where not  country_of_nationality in ('others','total','Grand total') )temp where temp.rn=5

/* Top 5 average arrivals by nationality */

select top 5 nationality,avg(arrivals) as avg_arrivals  from [foreign tourism] 
where not Country_of_Nationality in ('others','Total','Grand Total') group by Nationality order by avg_arrivals desc

/* nationalities with arrivals more than the avg arrivals*/
/* 1. With subquery approach */
select nationality,arrivals from [foreign tourism] where arrivals> (select avg(arrivals) as avg_arrivals from [foreign tourism])
and  not nationality='Grand Total' order by Arrivals desc

/*2. CTE approach */
WITH average_arrivals as (
select avg(arrivals) as avg_arr from [foreign tourism])
select nationality,arrivals from [foreign tourism],average_arrivals
where [foreign tourism].Arrivals>[average_arrivals].avg_arr and not [foreign tourism].Nationality='Grand Total'
order by Arrivals desc

/*Growth rate with greater growth rate than the average growth rate is said to be over devoloping less than average is 
said to be under devoloping rest are breakeven*/
-- For domestic--
with average_growth_rate as(
select avg(growth_rate_Domestic) as avg_growth_rate from [domestic and foreign])
select State_ut,
Case
    when [domestic and foreign].growth_Rate_Domestic > [average_growth_rate].avg_growth_rate
	then 'over devoloping state'
	else 'Under devoloping state'
	end  state_type
	from [domestic and foreign],[average_growth_rate] where not State_UT='Total'
