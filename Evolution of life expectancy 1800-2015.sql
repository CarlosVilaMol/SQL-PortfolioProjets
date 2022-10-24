-- I start with a general exploration of the dates

select *
from `life expectancy`

select *
from `life expectancy`
group by entity

select 
	entity,
    min(year) as First_year, max(year) as Last_year
from `life expectancy`
group by entity

select 
	entity,
    min(life_expectancy) as min_life_expectancy, max(life_expectancy) as max_life_expectancy
from `life expectancy`
group by entity

-- I find some error in the column life_expenctancy, India in 1918 has a 
-- life expectancy of 81 years, but in the previous and following years, 
-- the life expectancy was around 24 years. Therefore, I correct the number

update `life expectancy`
set life_expectancy=24
where entity="india" and year=1918

-- I start the data exploration, searching some interesting things like:

-- Which was the year when the population of the differents countries arrived 
-- to the life expectancy of 60 year?

select*
from `life expectancy`
where life_expectancy >=60 
group by entity
order by year asc


-- Life expectancy each 50 years
select*
from`life expectancy`
group by
	entity,
    year=1800,
    year=1850,
    year=1900,
    year=1950,
    year=2000
order by year asc


-- Evolution of life expectancy each 50 years
select 
	entity,
    concat(min(year),"-", max(year)) as Periodo,
    min(life_expectancy) as minima_vida,
    max(life_expectancy) as max_vida,
	(max(life_expectancy) - min(life_expectancy)) as aumento
 from`life expectancy`
 group by 
	entity, 
	year>1800 and year<1850, 
    year>1850 and year<1900,
    year>1900 and year<1950,
    year>1950 and year<2000,
    year<2000
order by aumento desc

-- I create a temporary table to help me work with the data more easily.

create temporary table tabla_temporal3 as (
select*
from`life expectancy`
group by
	entity,
    year=1800,
    year=1850,
    year=1900,
    year=1950,
    year=2000
order by year asc)

-- To better understanding of the data, I create a pivot table, 
-- with the years in sequences of 50 years

SELECT 
	entity,
	MAX(IF(year=1800 or year=1801 or year=1802, life_expectancy, NULL)) AS "1800",
	MAX(IF(year=1850, life_expectancy, NULL)) AS "1850",
	MAX(IF(year=1900, life_expectancy, NULL)) AS "1900",
	MAX(IF(year=1950, life_expectancy, NULL)) AS "1950",
	MAX(IF(year=2000, life_expectancy, NULL)) AS "2000"
FROM tabla_temporal3
GROUP BY entity

-- I save the tables of the queries to use it in the next step to make the
-- data visualizations through Tableau
