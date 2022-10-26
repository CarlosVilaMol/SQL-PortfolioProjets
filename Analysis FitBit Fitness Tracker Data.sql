create database proyecto_google

select
	count(*)
from resumen_datos

select
	ID,
    max(TotalSteps) as Pasos_maximos_diarios,
	min(TotalSteps)as Pasos_minimos_diarios,
    max(TotalDistanceKm) as Km_max,
    min(TotalDistanceKm) as Km_min,
    max(Calories) as calorias_max,
    min(Calories) as calorias_min
from resumen_datos
group by 
	ID
    
    
-- I check some average of different values like total steps, or calories
select
	ID,
	avg(TotalSteps) as AVG_pasos_diarios,
    avg(TotalDistanceKm) as AVG_Km_diarios,
    avg(Calories) as AVG_Calorias_diarias
from resumen_datos
group by
	ID
resumen_datos


-- I check if exist some relation between minutes of physical activity 
-- per day and minutes asleep
select
	resumen_datos.ID,
    (VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes) as Horas_actividad,
    TotalTimeInBed as Horas_sueño
from resumen_datos
join
	tiempo_sueño on resumen_datos.ID=tiempo_sueño.ID AND resumen_datos.ActivityDate=tiempo_sueño.SleepDay


select
	resumen_datos.ID,
   avg(VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes) as Horas_actividad_promedio,
    avg(TotalTimeInBed) as Horas_sueño_promedio
from resumen_datos
join
	tiempo_sueño on resumen_datos.ID=tiempo_sueño.ID AND resumen_datos.ActivityDate=tiempo_sueño.SleepDay

group by
	resumen_datos.ID

-- I create a temporaly table to work easyer with some data tables

create temporary table resumen_min_actividad (
 select
	resumen_datos.ID,
	ActivityDate,
    VeryActiveMinutes as min_actividad_intensa,
    FairlyActiveMinutes as min_actividad_media,
    LightlyActiveMinutes as min_actividad_ligera, 
    SedentaryMinutes as min_sedentarios,
    TotalTimeInBed as min_dormido,
    (VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes+SedentaryMinutes+TotalTimeInBed) as Horas_total_dia
    
from resumen_datos
join
	tiempo_sueño on resumen_datos.ID=tiempo_sueño.ID AND resumen_datos.ActivityDate=tiempo_sueño.SleepDay   
group by
	resumen_datos.ID,
	resumen_datos.ActivityDate

)

-- To improve the reliability of the dates, I just select the days where the 
-- sum of all the minutes of activity (high intensity exercise, 
-- light intensity exercise, minutes asleep) are 1440 (plus/less 20)(24H)

select*
from
	resumen_min_actividad
where horas_total_dia>1420 and horas_total_dia<1460

select
	avg(min_actividad_intensa),
    avg(min_actividad_media),
    avg(min_actividad_ligera), 
    avg(min_sedentarios),
    avg(min_dormido)
from resumen_min_actividad
where horas_total_dia>1420 and horas_total_dia<1460

-- I check the relation between calories and different items, like to do
-- more or less than 10.000 steps/day, asleep time, minutes of activity
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

    
select
(min_actividad_intensa+min_actividad_media+min_actividad_ligera) as Min_activos_dia,
TotalTimeInBed,
calories
from resumen_min_actividad
join resumen_datos on resumen_min_actividad.id=resumen_datos.id and resumen_min_actividad.ActivityDate=resumen_datos.ActivityDate
join tiempo_sueño on resumen_min_actividad.id=tiempo_sueño.id and resumen_min_actividad.ActivityDate=tiempo_sueño.SleepDay
where horas_total_dia>1420 and horas_total_dia<1460
group by
	resumen_datos.id,
    resumen_datos.ActivityDate

