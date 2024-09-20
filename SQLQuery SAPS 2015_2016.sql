SELECT *
  FROM [SAPS 2015/2016].[dbo].[CrimeStats]

  alter table [SAPS 2015/2016].[dbo].[CrimeStats]
  drop column _2010_2011, _2011_2012, _2012_2013, _2013_2014,_2014_2015

--Total population

select sum(population) Total_Population
from [SAPS 2015/2016].[dbo].[Provinces]

--Total number of stations

SELECT count(distinct station) as Total_Number_Stations
FROM [SAPS 2015/2016].[dbo].[CrimeStats]

--total number of crimes

SELECT sum(_2015_2016) TotalCrime 
FROM [SAPS 2015/2016].[dbo].[CrimeStats]

--what is the murder rate per 100 000?

with TotalMurder as (
SELECT Category, sum(_2015_2016) as Total_Murder
FROM [SAPS 2015/2016].[dbo].[CrimeStats]
where Category = 'murder'
group by Category)
				 

SELECT	Total_Murder * 1.0/ (select sum(population) from [SAPS 2015/2016].[dbo].[Provinces]) *100000 as MurderRate
FROM TotalMurder

--What is the Provincial distribution?

SELECT Province,  sum(_2015_2016*1) as _2015_2016
FROM [SAPS 2015/2016].[dbo].[CrimeStats]
group by Province

--what are the top 5 stations?

SELECT top 5 (Station), sum(_2015_2016) as Top_5_Stations 
FROM [SAPS 2015/2016].[dbo].[CrimeStats]
group by Station
order by Top_5_Stations  desc

--what are the top 5 crimes?

SELECT top 5 Category, sum(_2015_2016) as Top_Crimes_by_Caategory
FROM [SAPS 2015/2016].[dbo].[CrimeStats]
group by Category
order by Top_Crimes_by_Caategory desc


--what is the murder rate by provinces (per 100 000)?
	
with cte as(
select b.Province, a.Population, sum(_2015_2016) as Total_Murder
from [SAPS 2015/2016].[dbo].[Provinces] a join
[SAPS 2015/2016].[dbo].[CrimeStats] b
on a.Province =b.Province
where Category = 'murder'
group by b.Province,a.population)

select	province, (Total_Murder*1.0/Population *100000) Murder_Rate_By_Province_Per_100000
from cte
order by Murder_Rate_By_Province_Per_100000 desc

--Sexual Offences per 100000 

with SexualOffences as (
SELECT Category, sum(_2015_2016) as Sexual_Offences 
FROM [SAPS 2015/2016].[dbo].[CrimeStats]
where Category = 'Sexual Offences'
group by Category)
				 

SELECT	Sexual_Offences * 1.0/ (select sum(population) from [SAPS 2015/2016].[dbo].[Provinces]) *100000 as Sexual_Offences_Per_100000
FROM SexualOffences

--what is the Total_Sexual_Offences per capita by provinces?
	
with cte as(
select b.Province, a.Population, sum(_2015_2016) as Total_Sexual_Offences
from [SAPS 2015/2016].[dbo].[Provinces] a join
[SAPS 2015/2016].[dbo].[CrimeStats] b
on a.Province =b.Province
where Category = 'Sexual Offences'
group by b.Province,a.population)

select	province, (Total_Sexual_Offences*1.0/Population *100000) Sexual_Offences_By_Province_Per_100000
from cte
order by Sexual_Offences_By_Province_Per_100000 desc

