use new_new

--1. Explore whole data
select *
from 
covid_d

--2. Explore whole data by ordering
select *
from 
covid_d
order by 3,4

-- 3. Change column names which are key words
exec sp_rename 'covid_d.population', 'head_count', 'column'
exec sp_rename 'covid_d.location', 'country', 'column'
exec sp_rename 'covid_d.date', 'occured_on', 'column'

--4. Change data_type by altering
alter table covid_d
alter column occured_on date

--5. Use needed columns for a daily basis overview
SELECT country, occured_on, head_count, total_cases, new_cases, total_deaths, new_deaths
FROM     covid_d
WHERE  (continent = 'africa')
ORDER BY country, occured_on

--6. Current figures amongst African Countries
SELECT country, head_count,
	   SUM(CAST(new_cases AS numeric)) AS total_cases,
	   SUM(CAST(new_deaths AS numeric)) AS total_deaths
FROM     covid_d
WHERE  (continent = 'africa')
GROUP BY country, head_count
ORDER BY total_cases DESC

--7. Current figures for Africa as a Continent
SELECT continent, SUM(DISTINCT CAST(head_count AS numeric)) AS head_count,
				  SUM(CAST(new_cases AS numeric)) AS total_cases,
				  SUM(CAST(new_deaths AS numeric)) AS total_deaths
FROM     covid_d
WHERE  (continent = 'africa')
group by continent

--8. Daily death_infection rate per country
SELECT country, occured_on, total_cases, total_deaths,
CAST(total_deaths AS numeric) / CAST(total_cases AS numeric) * 100 AS death_infection_rate
FROM     covid_d
WHERE  (continent = 'africa')
ORDER BY country, occured_on

--9. Total death_infection rate 
SELECT country, head_count, 
       SUM(CAST(new_cases AS numeric)) AS total_cases,
       SUM(CAST(new_deaths AS numeric)) AS total_deaths, 
       SUM(CAST(new_deaths AS numeric))/SUM(CAST(new_cases AS numeric))*100 as current_death_inf_rate
FROM     covid_d
WHERE  (continent = 'africa')
GROUP BY country, head_count
ORDER BY current_death_inf_rate DESC

--10. Current continent death_infection rate
SELECT continent,
       SUM(DISTINCT CAST(head_count AS numeric)) AS head_count,
	   SUM(CAST(new_cases AS numeric)) AS total_cases,
	   SUM(CAST(new_deaths AS numeric)) AS total_deaths,
	   SUM(CAST(new_deaths AS numeric))/SUM(CAST(new_cases AS numeric)) * 100 AS current_death_inf_rate
FROM     covid_d
WHERE  (continent = 'africa')
GROUP BY continent
ORDER BY current_death_inf_rate DESC

--11. Daily population_infection rate per country
SELECT country, occured_on, head_count, total_cases,
       CAST(total_cases AS numeric) / head_count * 100 AS pop_infection_rate
FROM     covid_d
WHERE  (continent = 'africa')
ORDER BY country, occured_on

--12. Current pop_infection_rate
SELECT country, head_count,
       SUM(CAST(new_cases AS numeric)) AS current_total_case,
	   SUM(CAST(new_cases AS numeric) / head_count) * 100 AS pop_infection_rate
FROM     covid_d
WHERE  (continent = 'africa')
GROUP BY country, head_count
ORDER BY pop_infection_rate DESC

--13. current CONTINENT population_infection rate
SELECT continent, 
       SUM(DISTINCT CAST(head_count AS numeric)) AS total_head_count,
	   SUM(CAST(new_cases AS numeric)) AS current_total_cases,
	   SUM(CAST(new_cases AS numeric)) / SUM(DISTINCT CAST(head_count AS numeric)) 
                  * 100 AS continent_inf_rate
FROM     covid_d
WHERE  (continent = 'africa')
GROUP BY continent

--14. max_death_count
SELECT country, SUM(CAST(new_deaths AS numeric)) AS current_deaths
FROM     covid_d
WHERE  (continent = 'africa')
GROUP BY country
ORDER BY current_deaths DESC

--15. Continent max_death_count
SELECT continent, 
SUM(CAST(new_deaths AS numeric)) AS current_deaths
FROM
covid_d
WHERE continent = 'africa'
GROUP BY continent
ORDER BY current_deaths DESC

--16. Current death_population ratio
SELECT country, head_count, 
       MAX(CAST(total_deaths AS numeric)) AS current_deaths,
       MAX(CAST(total_deaths AS numeric)/head_count)*100 AS death_population_ratio
FROM
covid_d
WHERE continent = 'africa'
GROUP BY country, head_count
ORDER BY death_population_ratio DESC

--17. Continent level death_population ratio
SELECT continent,
       SUM(DISTINCT CAST(head_count AS numeric)) AS head_count, SUM(CAST(new_deaths AS numeric)) AS current_deaths, SUM(CAST(new_deaths AS numeric)) / SUM(DISTINCT CAST(head_count AS numeric)) 
                  * 100 AS death_population_ratio
FROM     covid_d
WHERE  (continent = 'africa')
GROUP BY continent
ORDER BY current_deaths DESC

--18. Preview vaccinations
SELECT *
FROM     
covid_v

--19. Change column names which are key words
exec sp_rename 'covid_v.population', 'head_count', 'column'
exec sp_rename 'covid_v.location', 'country', 'column'
exec sp_rename 'covid_v.date', 'occured_on', 'column'

--20. Change data_type by altering
alter table covid_d
alter column occured_on date

--21. Explore whole data by ordering
SELECT *
FROM     covid_v
ORDER BY 3,4

--22. Join both tables on country and date
SELECT *
FROM
covid_d dea
INNER JOIN 
covid_v vac ON dea.country = vac.country
          and dea.occured_on = vac.occured_on
		  WHERE dea.continent = 'africa'
		  ORDER BY 3,4

--23. Daily country population vs vaccinations
SELECT dea.country, dea.occured_on, dea.head_count, vac.total_vaccinations
FROM     covid_d AS dea INNER JOIN
                  covid_v AS vac ON dea.country = vac.country AND dea.occured_on = vac.occured_on
WHERE  (dea.continent = 'africa')
ORDER BY dea.country, dea.occured_on

--24. Total country population vs vaccination
SELECT dea.country, dea.head_count, MAX(CAST(vac.total_vaccinations AS numeric)) AS curr_vac_percountry
FROM     covid_d AS dea INNER JOIN
                  covid_v AS vac ON dea.country = vac.country AND dea.occured_on = vac.occured_on
WHERE  (dea.continent = 'africa')
GROUP BY dea.country, dea.head_count
ORDER BY dea.country, dea.head_count

--25. Total country population vs vaccination ratio
SELECT dea.country, dea.head_count, MAX(CAST(vac.total_vaccinations AS numeric)) AS curr_vac_percountry,
MAX(CAST(vac.total_vaccinations AS numeric))/dea.head_count*100 as country_pop_vac_ratio
FROM     covid_d AS dea INNER JOIN
                  covid_v AS vac ON dea.country = vac.country AND dea.occured_on = vac.occured_on
WHERE  (dea.continent = 'africa')
GROUP BY dea.country, dea.head_count
ORDER BY 4 desc

--26. Continent population vs vaccinations by CTE
WITH POP_VAC (country, head_count, curr_vac_percountry) 
as
(SELECT dea.country, dea.head_count, 
MAX(CAST(vac.total_vaccinations AS numeric)) AS curr_vac_percountry
FROM     covid_d AS dea INNER JOIN
                  covid_v AS vac ON dea.country = vac.country AND dea.occured_on = vac.occured_on
WHERE  (dea.continent = 'africa')
GROUP BY dea.country, dea.head_count
)
SELECT SUM(DISTINCT CAST(head_count AS numeric)) as head_count, 
       SUM(curr_vac_percountry) AS total_vaccinations
FROM 
POP_VAC

--27. continent population vs vaccinations ratio by CTE
WITH POP_VAC_ratio (country, head_count, curr_vac_percountry) 
AS
(SELECT dea.country, dea.head_count, 
MAX(CAST(vac.total_vaccinations AS numeric)) AS curr_vac_percountry
FROM     covid_d AS dea INNER JOIN
         covid_v AS vac ON dea.country = vac.country AND dea.occured_on = vac.occured_on
WHERE  (dea.continent = 'africa')
GROUP BY dea.country, dea.head_count
)
SELECT SUM(DISTINCT cast(head_count as numeric)) AS head_count, 
       SUM(curr_vac_percountry) AS total_vaccinations,
       SUM(curr_vac_percountry)/SUM(DISTINCT CAST(head_count AS numeric))*100 AS POP_VAC_ratio
FROM 
POP_VAC_ratio

--25. view for later usage
CREATE VIEW v_pop_vac_ratio
AS
SELECT dea.country, dea.head_count, 
MAX(CAST(vac.total_vaccinations AS numeric)) AS curr_vac_percountry
FROM     covid_d AS dea INNER JOIN
         covid_v AS vac ON dea.country = vac.country AND dea.occured_on = vac.occured_on
WHERE  (dea.continent = 'africa')
GROUP BY dea.country, dea.head_count


		  

