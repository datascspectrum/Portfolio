-- Lets take a look of the tables in our Database
Select *
from [Portfolio Project]..CovidDeaths

Select *
from [Portfolio Project]..CovidVaccinations



-- CovidDeaths
--1
Select date, Continent, location, population, total_cases, total_deaths
from [Portfolio Project]..CovidDeaths
where continent is not null
order by location asc, date asc

--2
Select date, Continent, location, population, total_cases, reproduction_rate
from [Portfolio Project]..CovidDeaths
where continent is not null
order by location asc, date asc

--3
Select date, Continent, location, population, weekly_icu_admissions, weekly_hosp_admissions
from [Portfolio Project]..CovidDeaths
where continent is not null
order by location asc,date asc

-- CovidVaccinations
--4
Select date, Continent, location, people_vaccinated,people_fully_vaccinated
from [Portfolio Project]..CovidVaccinations
where continent is not null
order by location, date asc

--5
Select date, Continent, location, stringency_index, human_development_index
from [Portfolio Project]..CovidVaccinations
where continent is not null
order by location, date asc

--Views
--A1 Table 1
Create view GlobalDeathPercentage as 
Select location, SUM(new_cases) as total_cases, SUM (cast(new_deaths as int)) as total_deaths, 
SUM (cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where continent is not null
group by location


Select *
from GlobalDeathPercentage

--A2 Table 2
Create view Continent_deaths as
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
where continent is null
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
group by location

Select *
from Continent_deaths


--A3 Table 3

Create view Historical_casesvsdeaths as
Select location, date, new_cases, new_deaths
from [Portfolio Project]..CovidDeaths
where continent is not null


Select *
from Historical_casesvsdeaths
order by date asc



--A4 Table 4

Create view ICUVSVAC as
Select dea.date, dea.location, dea.weekly_icu_admissions, vac.new_vaccinations
from [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
from ICUVSVAC
order by date asc



--A5 Table 5
Create view DeathsvsStringency as
Select dea.location, MAX(cast(dea.total_deaths as bigint)) as TotalDeathCount,(MAX(cast(dea.total_deaths as bigint))/dea.population)*100 as DeathPercentage,
AVG(vac.stringency_index) as Stringency
from [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
where dea.continent is not null
group by dea.location, dea.population

Select *
FROM DeathsvsStringency
order by location asc




--A6 table 6
Create view HighestInfectionCount as
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX(cast(total_deaths as bigint)) as TotalDeathCount,  
Max((total_cases)/population)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%Venezuela%'
where continent is not null
Group by Location, population


Select *
from HighestInfectionCount
Order by location ASC





-- TOTAL DATABASE

Select dea.date, dea.continent, dea.location, dea.population, dea.new_cases, dea.new_deaths, dea.weekly_icu_admissions, 
vac.new_vaccinations, vac.stringency_index, dea.total_cases, dea.total_deaths
from [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by dea.date asc














