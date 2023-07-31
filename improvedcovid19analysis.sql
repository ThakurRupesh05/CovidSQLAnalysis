-- I have create two Temporary Table #CovidDeathsData and #CovidVaccinationData
-- This is a First Temporary Table

-- Covid Deaths Data Temporary Table
drop table if exists dbo.#CovidDeathsData
select *
into #CovidDeathsData
from (
	select continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths
	from CovidDeaths
	) as temp

-- Covid Vaccinations Data Temporary Table
drop table if exists dbo.#CovidVaccinationData
select *
into #CovidVaccinationData
from (
	select continent, location, date, total_tests, new_tests, people_fully_vaccinated, new_vaccinations,
	sum(new_vaccinations) over (partition by location order by location, date) as total_vaccinations
	from CovidVaccination
	) as temp


-- Showing World Data on total cases, total deaths and Death Percentage

select location, max(population) as population, MAX(total_cases) as total_cases, 
	MAX(total_deaths) as total_deaths, MAX(total_deaths)/MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where location = 'World'
group by location

-- Showing people who has taken complete dose of the vaccinations.

select CDD.location, MAX(CDD.population) as total_population,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.location = 'World'
group by CDD.location

-- Now we will see data on each individual year separately
-- Year 2020, Monthly Data on total cases and total deaths

select location, DATEPART(YEAR, date) as year, DATEPART(MONTH, date) as months,
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths) / MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where location = 'World' and DATEPART(YEAR, date) = 2020
group by location, DATEPART(month, date), DATEPART(YEAR, date)
order by months


-- Showing how much pepole are fully vaccinated

select CDD.location, DATEPART(YEAR, CDD.date) as year, DATEPART(MONTH, CDD.date) as months,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.location = 'World' and DATEPART(YEAR, CDD.date) = 2020
group by CDD.location, DATEPART(MONTH, CDD.date), DATEPART(YEAR, CDD.date)
order by months


-- Year 2021, Monthly Data

select location, DATEPART(YEAR, date) as year, DATEPART(MONTH, date) as months, 
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths) / MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where location = 'World' and DATEPART(YEAR, date) = 2021
group by location, DATEPART(month, date), DATEPART(YEAR, date)
order by months


-- Showing how much pepole are fully vaccinated

select CDD.location, DATEPART(YEAR, CDD.date) as year, DATEPART(MONTH, CDD.date) as months,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.location = 'World' and DATEPART(YEAR, CDD.date) = 2021
group by CDD.location, DATEPART(MONTH, CDD.date), DATEPART(YEAR, CDD.date)
order by months

-- Year 2022, Monthly Data

select location, DATEPART(YEAR, date) as year, DATEPART(MONTH, date) as months, 
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths) / MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where location = 'World' and DATEPART(YEAR, date) = 2022
group by location, DATEPART(month, date), DATEPART(YEAR, date)
order by months


-- Showing how much pepole are fully vaccinated

select CDD.location, DATEPART(YEAR, CDD.date) as year, DATEPART(MONTH, CDD.date) as months,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.location = 'World' and DATEPART(YEAR, CDD.date) = 2022
group by CDD.location, DATEPART(MONTH, CDD.date), DATEPART(YEAR, CDD.date)
order by months

-- Year 2023, Monthly Data

select location, DATEPART(YEAR, date) as year, DATEPART(MONTH, date) as months, 
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths) / MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where location = 'World' and DATEPART(YEAR, date) = 2023
group by location, DATEPART(month, date), DATEPART(YEAR, date)
order by months


-- Showing how many pepole are fully vaccinated till now

select CDD.location, DATEPART(YEAR, CDD.date) as year, DATEPART(MONTH, CDD.date) as months,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.location = 'World' and DATEPART(YEAR, CDD.date) = 2023
group by CDD.location, DATEPART(MONTH, CDD.date), DATEPART(YEAR, CDD.date)
order by months


-- Continent Data
-- Now we will see data based on different continents

select location, max(population) as population, MAX(total_cases) as total_cases, 
	MAX(total_deaths) as total_deaths, MAX(total_deaths)/MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where continent is null 
	and location in ('Asia', 'Africa', 'Europe', 'North America', 'Oceania', 'South America')
group by location
order by location

-- Showing total cases, total deaths, death percentage and case percentage by year on each continent

select location, MAX(population) as population, DATEPART(YEAR, date) as year,
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths)/MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where continent is null 
	and location in ('Asia', 'Africa', 'Europe', 'North America', 'Oceania', 'South America')
group by location, DATEPART(YEAR, date)
order by location

-- Show how many people are fully vaccinated on each continent year by year

select CDD.location, DATEPART(YEAR, CDD.date) as year,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.continent is null 
	and CDD.location in ('Asia', 'Africa', 'Europe', 'North America', 'Oceania', 'South America')
group by CDD.location, DATEPART(YEAR, CDD.date)
order by location, year


-- Country Data
-- Showing total cases, total deaths, death percentage and case percentage

select location, max(population) as population, MAX(total_cases) as total_cases, 
	MAX(total_deaths) as total_deaths, MAX(total_deaths)/MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where continent is not null 
group by location
order by location


-- Show how many pepole are fully vaccinated on each country

select CDD.location, MAX(CDD.population) as total_population,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.continent is not null
group by CDD.location
order by location


-- Year 2020, Monthly Data
-- Showing data on total cases, total deaths, death percentage and case percentage on each country

select location, DATEPART(YEAR, date) as year, DATEPART(MONTH, date) as months, 
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths) / MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where continent is not null and DATEPART(YEAR, date) = 2020
group by location, DATEPART(month, date), DATEPART(YEAR, date)
order by location, months


-- Show how many pepole are fully vaccinated on each country

select CDD.location, DATEPART(YEAR, CDD.date) as year,
	MAX(CDD.population) as total_population,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.continent is not null 
	and DATEPART(YEAR, CDD.date) = 2020
group by CDD.location, DATEPART(YEAR, CDD.date)
order by location, year


-- Year 2021, Monthly Data
-- Showing data on total cases, total deaths, death percentage and case percentage on each country

select location, DATEPART(YEAR, date) as year, DATEPART(MONTH, date) as months, 
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths) / MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where continent is not null and DATEPART(YEAR, date) = 2021
group by location, DATEPART(month, date), DATEPART(YEAR, date)
order by location, months


-- Show how many pepole are fully vaccinated on each country

select CDD.location, DATEPART(YEAR, CDD.date) as year,
	MAX(CDD.population) as total_population,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.continent is not null 
	and DATEPART(YEAR, CDD.date) = 2021
group by CDD.location, DATEPART(YEAR, CDD.date)
order by location, year


-- Year 2022, Monthly Data
-- Showing data on total cases, total deaths, death percentage and case percentage on each country

select location, DATEPART(YEAR, date) as year, DATEPART(MONTH, date) as months, 
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths) / MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where continent is not null and DATEPART(YEAR, date) = 2022
group by location, DATEPART(month, date), DATEPART(YEAR, date)
order by location, months


-- Show how many pepole are fully vaccinated on each country

select CDD.location, DATEPART(YEAR, CDD.date) as year,
	MAX(CDD.population) as total_population,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.continent is not null 
	and DATEPART(YEAR, CDD.date) = 2022
group by CDD.location, DATEPART(YEAR, CDD.date)
order by location, year


-- Year 2023, Monthly Data
-- Showing data on total cases, total deaths, death percentage and case percentage on each country

select location, DATEPART(YEAR, date) as year, DATEPART(MONTH, date) as months, 
	MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths,
	MAX(total_deaths) / MAX(total_cases) * 100 as DeathPercentage,
	MAX(total_cases)/MAX(population) * 100 as CasePercentage
from #CovidDeathsData
where continent is not null and DATEPART(YEAR, date) = 2023
group by location, DATEPART(month, date), DATEPART(YEAR, date)
order by location, months


-- Show how many pepole are fully vaccinated on each country

select CDD.location, DATEPART(YEAR, CDD.date) as year,
	MAX(CDD.population) as total_population,
	MAX(CVD.people_fully_vaccinated) as people_fully_vaccinated
from #CovidDeathsData as CDD
join #CovidVaccinationData as CVD
	on CDD.location=CVD.location
	and CDD.date=CVD.date
where CDD.continent is not null 
	and DATEPART(YEAR, CDD.date) = 2023
group by CDD.location, DATEPART(YEAR, CDD.date)
order by location, year