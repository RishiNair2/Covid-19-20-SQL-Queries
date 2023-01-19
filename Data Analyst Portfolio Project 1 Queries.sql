--Looking at Total Cases vs Total Deaths

--Shows the likelihood of dying if you contract COVID in your country
SELECT location, date, total_cases, total_deaths, 
(total_deaths::numeric/total_cases) * 100 AS death_percentage
FROM covid_deaths
WHERE location LIKE '%States%'
ORDER BY 1,2

----Looking at Total Cases vs Population
----Shows what percentage of population got Covid
SELECT location, date, total_cases, total_deaths, population,
(total_cases::numeric/population)*100 AS percentage_population_infected
FROM covid_deaths
WHERE location LIKE '%States%'
ORDER BY 1,2;

-- Looking at countries with the highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count,
    MAX((total_cases::numeric/population))*100 AS percent_population_infected
FROM covid_deaths
GROUP BY location, population
ORDER BY percent_population_infected DESC;

---Showing Countries with Highest Death Count per Population
SELECT location, MAX(CAST(total_deaths as numeric)) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY total_death_count DESC;

-- Let's Break Things Down By Continent/ Showing continents with the highest death count
SELECT continent, MAX(CAST(total_deaths as numeric)) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Global Numbers
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, 
  SUM(CAST(new_deaths as numeric))/SUM(new_cases)*100 as death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, 
vacc.new_vaccinations, 
SUM(vacc.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vacc
ON dea.location = vacc.location AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2,3;
