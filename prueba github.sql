-- CAMBIAR EL NOMBRE DE UNA COLUMNA
ALTER TABLE `life expectancy` RENAME COLUMN `Life expectancy` TO `Life_expectancy`; -- Cambiar el nombre de una columna
ALTER TABLE info_biometrica RENAME info_bio;

-- ELIMINAR DUPLICADOS
select
	distinct Entity -- Para eliminar duplicados
from `life expectancy`

-- ELIMINAR TABLA
drop table `resumen_datos`

-- CONTAR NUMEROS DE FILAS
select
	count(*)
from resumen_datos
-- ELIMINAR LOS SIGNOS DE PUNTUACIÓN EN NUMEROS
SELECT REPLACE(1.3,'.', '')
from resumen_datos
where calories=1.3

-- BUSCAR MINIMO Y MAXIMO DE UN RANGO DE VALORES
select
	Entity,
    min(Life_expectancy) as esperanza_minima, max(Life_expectancy) as esperanza_max
from `life expectancy`
group by Entity


-- CREAR UNA TABLA TEMPORAL
create temporary table tabla_temporal as (
select
	Entity,
    min(Life_expectancy) as esperanza_minima, max(Life_expectancy) as esperanza_max

from `life expectancy`
group by Entity);


-- CREANDO UNA TABLA DINAMICA
SELECT 
	entity,
	MAX(IF(year=1800 or year=1801 or year=1802, life_expectancy, NULL)) AS "1800",
	MAX(IF(year=1850, life_expectancy, NULL)) AS "1850",
	MAX(IF(year=1900, life_expectancy, NULL)) AS "1900",
	MAX(IF(year=1950, life_expectancy, NULL)) AS "1950",
	MAX(IF(year=2000, life_expectancy, NULL)) AS "2000"
FROM tabla_temporal3
GROUP BY entity


-- COMANDO CONCAT PARA UNIR DOS CADENAS DE TEXTO
select 
	entity,
    concat (min(year),"-", max(year)) as Periodo,
    min(life_expectancy) as minima_vida,
    max(life_expectancy) as max_vida
 from`life expectancy`
 where year>1850 and year<1900
 group by entity
 
 
 -- HACER UNA RESTA 
 
 select 
	entity,
    concat (min(year),"-", max(year)) as Periodo,
    min(life_expectancy) as minima_vida,
    max(life_expectancy) as max_vida,
	(max(life_expectancy) - min(life_expectancy)) as aumento
 from`life expectancy`
 where 
	year>1800 and year<1850
 group by entity
 
 
 -- SELECCIONANDO Y AGRUPANDO POR DISTINTOS PERIODOS 
 select 
	entity,
    concat (min(year),"-", max(year)) as Periodo,
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
    
-- MODIFICAR O ELIMINAR UN VALOR DE LA TABLA (X DEFECTO ESTA DESACTIVADO, EDIT.....PREFERENCES....SQL EDITOR....SAFE
update `life expectancy`
set life_expectancy=24
where entity="india" and year=1918

update resumen_datos
set calories=1300
where calories=1.3

-- JOIN
select
	resumen_datos.ID,
    (VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes) as Horas_actividad,
    TotalTimeInBed as Horas_sueño
from resumen_datos
join
	tiempo_sueño on resumen_datos.ID=tiempo_sueño.ID AND resumen_datos.ActivityDate=tiempo_sueño.SleepDay
    
-- SUBCONSULTAS
select
	 (
	select
		avg(calories)
	from resumen_datos
	where totalsteps<5000) as calorias_menos_5000_pasos, 
    (select
		avg(calories)
	from resumen_datos
	where totalsteps>5000 and totalsteps<10000) as calorias_entre_5000_10000_pasos,
    (select
		avg(calories)
	from resumen_datos
	where totalsteps>10000) as calorias_mas_10000_pasos
    from resumen_datos
    limit 1
