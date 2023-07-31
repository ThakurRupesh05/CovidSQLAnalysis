-- I have create two Temporary Table #CovidDeathsData and #CovidVaccinationData
-- This is a First Temporary Table
drop table if exists dbo.#CovidDeathsData
select *
into #CovidDeathsData
from (
	select continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths
	from CovidDeaths
	) as temp

-- This a Second Temporary Table
drop table if exists dbo.#CovidVaccinationData
select *
into #CovidVaccinationData
from (
	select continent, location, date, total_tests, new_tests, people_fully_vaccinated, new_vaccinations,
	sum(new_vaccinations) over (partition by location order by location, date) as total_vaccinations
	from CovidVaccination
	) as temp

-- Data Exploration

-- World Death Data
-- Showing total cases, total deaths and death rate in the World
-- I have used max function to get the maximum value because there are duplicate values in the table
select MAX(population) as total_population, MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths, 
(max(total_deaths)/max(total_cases)) * 100 as DeathRate
from #CovidDeathsData
where location = 'World'
group by location

-- Total Cases vs Total Deaths in the World
-- Showing daily death rate along with total cases and total deaths.
select date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathRate
from #CovidDeathsData
where location = 'World'

--Total Cases vs Vaccination in the World
--Showing total cases, new vaccination and total vaccination
select #CovidDeathsData.date, #CovidDeathsData.population, #CovidDeathsData.total_cases,
	cast(#CovidVaccinationData.new_vaccinations as int) as new_vaccination, 
	cast(#CovidVaccinationData.total_vaccinations as bigint) as total_vaccination
from #CovidDeathsData
join #CovidVaccinationData on #CovidDeathsData.location = #CovidVaccinationData.location
	and #CovidDeathsData.date = #CovidVaccinationData.date
where #CovidDeathsData.location = 'World'


-- Total Cases and Total Death by Continent
-- Continent Data 
-- Showing total cases, total deaths and death rate
select continent, sum(distinct total_cases) as total_cases, 
	sum(distinct total_deaths) as total_deaths, 
	(sum(distinct total_deaths)/sum(distinct total_cases)) * 100 as DeathRate
from #CovidDeathsData
where continent is not null
group by continent
order by continent 


-- Total Population vs Total Vaccination
-- Showing Population and Total Vaccination and vaccination percentage 
select #CovidDeathsData.continent, sum(distinct #CovidDeathsData.population) as total_population,
	sum(cast(#CovidVaccinationData.total_vaccinations as bigint)) as total_vaccinations
from #CovidDeathsData
join #CovidVaccinationData on #CovidDeathsData.location = #CovidVaccinationData.location
	and #CovidDeathsData.date = #CovidVaccinationData.date
where #CovidDeathsData.continent is not null
group by #CovidDeathsData.continent

-- Country wise data

select location, date, population, total_cases, new_cases, total_deaths, new_deaths
from #CovidDeathsData
where continent is not null

-- Total Cases vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DateRate
from #CovidDeathsData
where continent is not null

--Total Cases vs Population
select location, population, total_cases, (total_cases/population) * 100 as CaseRate
from #CovidDeathsData
where continent is not null

--Infaction Rate
select location, population, max(total_cases) as highest, MAX((total_cases/population)) * 100 as InfactionRate
from #CovidDeathsData
where continent is not null
group by location, population
order by InfactionRate desc

-- Total Deaths
select location, population, MAX(total_deaths) as DeathCount, (MAX(total_deaths)/population) * 100 as DeathPercentage
from #CovidDeathsData
where continent is not null
group by location, population
order by DeathCount desc

-- Total Vaccination
select #CovidDeathsData.location, #CovidDeathsData.population,
	max(cast(#CovidVaccinationData.new_vaccinations as bigint)) as total_vaccinations
from #CovidDeathsData
join #CovidVaccinationData on #CovidDeathsData.continent=#CovidVaccinationData.continent
	and #CovidDeathsData.date=#CovidVaccinationData.date
group by #CovidDeathsData.location, #CovidDeathsData.population
order by location