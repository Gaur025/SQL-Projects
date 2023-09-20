select * from CovidDeaths
order by 3,4;

--select * from CovidVaccinations
--order by 3,4;

-- select data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths
order by 1,2;

-- Looking at Total Cases vs Total Deaths
-- Shows the liklihood of dying if you contract covid in your country

Select Location, date, Cast(total_cases as float) as TotalCases, Cast(total_deaths as float) as TotalDeaths, (Cast(total_deaths as float)/Cast(total_cases as float))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2;


-- Looking at total cases vs Population
-- Shows what percentage of population got covid

--Select Location, date, CAST(total_cases as int) as TotalCases, CAST(population as int) as Population, (CAST(total_cases as int)/CAST(population as int))*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where location like '%states%'
--order by 1,2;


Select Location, date, total_cases as TotalCases, population as Population, (total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2;

-- Looking at countries with highest infection rate compared to population

Select Location, date, Max(total_cases) as HighestInfectionCount, population, (Max(total_cases)/population)*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
group by location, population
order by PercentagePopulationInfected desc;

-- Showing the countries with the highest death count per population

Select Location, Max(Cast(total_deaths as int)) as HighestDeathCount from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is NOT NULL
group by location
order by HighestDeathCount desc;

--LETS BREAK THINGS DOWN BY CONTINENT
-- Showing the continents with the highest death count


Select location, Max(Cast(total_deaths as int)) as HighestDeathCount from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is NOT NULL
group by location
order by HighestDeathCount desc;


-- GLOBAL NUMBERS
-- Showing the total cases each day around the world
Select date, SUM(new_cases)    -- Cast(total_cases as float) as TotalCases, Cast(total_deaths as float) as TotalDeaths, (Cast(total_deaths as float)/Cast(total_cases as float))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is NOT NULL
group by date
order by 1,2;

-- total deaths around the world each day
Select date, SUM(new_cases), SUM(CAST(new_deaths as int))    -- Cast(total_cases as float) as TotalCases, Cast(total_deaths as float) as TotalDeaths, (Cast(total_deaths as float)/Cast(total_cases as float))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is NOT NULL
group by date
order by 1,2;

-- Death percentage each day
-- Total Death Percentage
Select SUM(CAST(new_cases as float)) as TotalCases, SUM(CAST(new_deaths as float)) as TotalDeaths, (SUM(CAST(new_deaths as float))/SUM(CAST(new_cases as float))) as DeathPercentage    -- Cast(total_cases as float) as TotalCases, Cast(total_deaths as float) as TotalDeaths, (Cast(total_deaths as float)/Cast(total_cases as float))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is NOT NULL
--group by date
order by 1,2;

--ACCESSING THE TABLE 'COVID VACCINATIONS'

--JOINING THE TWO TABLES
SELECT * FROM PortfolioProject..CovidDeaths DEA JOIN PortfolioProject..CovidVaccinations VAC ON DEA.location = VAC.location
AND DEA.date = VAC.date

--LOOKING AT TOTAL POPULATION VS VACCINATIONS
SELECT DEA.CONTINENT, DEA.LOCATION, DEA.date, DEA.population, VAC.new_vaccinations
FROM PortfolioProject..CovidDeaths DEA JOIN PortfolioProject..CovidVaccinations VAC ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3


--

SELECT DEA.CONTINENT, DEA.LOCATION, DEA.date, DEA.population, VAC.new_vaccinations, SUM(CAST(new_vaccinations AS bigint)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION, DEA.DATE) AS ROLLINGPEOPLEVACCINATED

FROM PortfolioProject..CovidDeaths DEA JOIN PortfolioProject..CovidVaccinations VAC ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3

--TEMP TABLE
-- USE CTE

WITH POPVSVAC (CONTINENT, LOCATION, DATE, POPULATION, NEW_VACCINATIONS, ROLLINGPEOPLEVACCINATED)
AS
(
SELECT DEA.CONTINENT, DEA.LOCATION, DEA.date, DEA.population, VAC.new_vaccinations, SUM(CAST(new_vaccinations AS bigint)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION, DEA.DATE) AS ROLLINGPEOPLEVACCINATED
FROM PortfolioProject..CovidDeaths DEA JOIN PortfolioProject..CovidVaccinations VAC ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
--ORDER BY 2,3