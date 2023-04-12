/* 
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables , Windows Functions, Aggregate Funtion, Creating Views, Converting Data Types 

*/



Select *
From ..CovidDeaths
Where continent is not null 
order by 3,4;



-- Selecting Data for Project

Select Location, date, total_cases, new_cases, total_deaths, population
From dbo.CovidDeaths
Where continent is not null 
order by 1,2;



--We are going to be looking at the Total Cases vs Total Deaths 
-- Shows likehood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, ((Cast(total_deaths as float))/(Cast(total_cases as float )))*100 as DeathPercentage
From dbo.CovidDeaths
Where Location like '%canada%'
and continent is not null 
order by 1,2



-- This is the Total Cases vs Population 
-- Shows what percentage of population that was infected with covid 

Select Location, date, Population, total_cases,((Cast(total_cases as float ))/ population)*100 as PercentPopulationInfected
From dbo.CovidDeaths
--Where location like '%states%'
order by 1,2



-- Looking at Countries with Highest Infection Rate compared to Population 

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((cast(total_cases as  float))/population)*100 as PercentPopulationInfected
From dbo.CovidDeaths
--Where location like '%canada%'
Group by Location, Population
order by PercentPopulationInfected desc



-- Showing Countries with Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From dbo.CovidDeaths
--Where location like '%canada%'
Where continent is not null
Group by Location
order by TotalDeathCount desc



-- Showing Continent with the Highest Death Count 

Select Continent, MAX(Total_deaths) as TotalDeathCount
From dbo.CovidDeaths
--Where location like '%canada%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(cast(new_deaths as float ))/SUM(new_cases)*100 as DeathPercentage
From dbo.CovidDeaths
--Where Location like 'Canada'
Where continent is not null
order by 1,2;


-- Showing the total cases with date 
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(cast(new_deaths as float ))/SUM(new_cases)*100 as DeathPercentage
From dbo.CovidDeaths
--Where Location like 'Canada'
Where continent is not null
Group By date
order by 1,2;



--JOING THE COVID DEATH TABLE AND THE COVIDVACCINATION TABLE
--Looking at the total population vs the number of people who where vaccinated 
Select  death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
SUM (cast (vaccine.new_vaccinations as float )) Over ( Partition by death.Location order by death.location, death.date) as RollingPeopleVaccinated
From dbo.CovidDeaths death
Join dbo.CovidVaccination vaccine 
    on death.location = vaccine.location
    and death.date = vaccine.date 
    where death.continent is not null
    and vaccine.new_vaccinations is not null
       order by 2,3;



-- USE CTE to perform calculation on Partition By in Previous query

with PopulationvsVaccine (continent, Location, Date , Population, new_vaccinations, RollingPeopleVaccinated)
AS
(
Select  death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
SUM (cast (vaccine.new_vaccinations as float )) Over ( Partition by death.Location order by death.location, death.date) as RollingPeopleVaccinated
From dbo.CovidDeaths death
Join dbo.CovidVaccination vaccine 
    on death.location = vaccine.location
    and death.date = vaccine.date 
    where death.continent is not null
    and vaccine.new_vaccinations is not null
       --order by 2,3  
)

Select* ,(RollingPeopleVaccinated/population)*100
From PopulationvsVaccine



-- TEMP TABLE 
    Drop Table if exists #PercentPopulationVaccinated
    Create Table  #PercentPopulationVaccinated
    (
        Continent nvarchar(255),
        Location  nvarchar(255),
        Date datetime,
        Population numeric,
        New_vaccinations numeric,
        RollingPeopleVaccinated numeric

    )

    Insert into #PercentPopulationVaccinated
    Select  death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
    SUM (cast (vaccine.new_vaccinations as int )) Over ( Partition by death.Location order by death.location, death.date) as RollingPeopleVaccinated
    From dbo.CovidDeaths death
    Join dbo.CovidVaccination vaccine 
        on death.location = vaccine.location
        and death.date = vaccine.date 
        --where death.continent is not null
        and vaccine.new_vaccinations is not null
        --order by 2,3 

    Select* ,(RollingPeopleVaccinated/Population)*100
    From #PercentPopulationVaccinated



    --Creating view to store data for later visulization
    Create View PercentPopulationVaccinated as
    Select  death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
    SUM (cast (vaccine.new_vaccinations as float )) Over ( Partition by death.Location order by death.location, death.date) as RollingPeopleVaccinated
    --, (RollingPeopleVacinated/population)*100
    From dbo.CovidDeaths death
    Join dbo.CovidVaccination vaccine 
        on death.location = vaccine.location
        and death.date = vaccine.date 
        where death.continent is not null
        and vaccine.new_vaccinations is not null
        

    









