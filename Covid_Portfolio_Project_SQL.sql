Select *
from [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
order by location, date ;

--Select *
--from [ProjectPortfolio].[dbo].[CovidVaccinations]
--where continent is not null
--order by location, date;


--Selecting the Data to be used.

Select Location, date, total_cases, new_cases, total_deaths, population
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
order by location, date;

--Looking at the Total Cases against the Total confirmed Deaths.

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
order by location, date;

--likelihood of dying in my country i.e Ghana

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [ProjectPortfolio].[dbo].[CovidDeaths]
where location like 'Ghana'
order by location, date;


--Looking at the Total Cases against the Population
--Finding out what percentage of population are infected
Select Location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
order by location, date;

--Infected Population Ratio in my country i.e Ghana

Select Location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
From [ProjectPortfolio].[dbo].[CovidDeaths]
Where location like 'Ghana'
order by location, date;

--looking at the Countries with the highest infection rates in comparison to population

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
Group by location, population
order by PercentPopulationInfected Desc;

--Looking at Countries with Highest death Count per population
Select Location, Max(cast(total_deaths as int)) as TotaldeathCount
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
Group by location, population
order by TotaldeathCount Desc;


--Looking at death Count per population of my country i.e Ghana
Select Location, Max(cast(total_deaths as int)) as TotaldeathCount
From [ProjectPortfolio].[dbo].[CovidDeaths]
where location like 'Ghana'
Group by location, population
order by TotaldeathCount Desc;

---Let's Break things down by Continent now.
--Looking at Continent with Highest death Count per population
--Select location, Max(cast(total_deaths as int)) as TotaldeathCount
--From [ProjectPortfolio].[dbo].[CovidDeaths]
--where continent is null
--Group by location
--order by TotaldeathCount Desc;

--Looking at Countries with Highest death rate per population
Select Location, population, Max(cast(total_deaths as int)) as TotaldeathCount, Max((total_deaths/population))*100 as PercentPopulationDead
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
Group by location, population
order by PercentPopulationDead Desc;

--Looking at death rate per population of my country i.e. Ghana
Select Location, population, Max(cast(total_deaths as int)) as TotaldeathCount, Max((total_deaths/population))*100 as PercentPopulationDead
From [ProjectPortfolio].[dbo].[CovidDeaths]
where location like 'Ghana'
Group by location, population
order by PercentPopulationDead Desc;


--looking at the continent with the highest death rates
Select continent, Max(cast(total_deaths as int)) as TotaldeathCount
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
Group by continent
order by TotaldeathCount Desc;


--Looking at the Global numbers

Select date, sum(new_cases)as TotalCases, sum(cast (new_deaths as int)) as TotalDeaths, (sum(cast (new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
Group by date
order by date, TotalCases;

--Looking at the Ultimate summation of TotalCases, TotalDeath across the world

Select sum(new_cases)as TotalCases, sum(cast (new_deaths as int)) as TotalDeaths, (sum(cast (new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From [ProjectPortfolio].[dbo].[CovidDeaths]
where continent is not null
order by TotalCases, TotalDeaths;


--A refresher on the second table i.e. CovidVacinations Table

Select *
from [ProjectPortfolio].[dbo].[CovidVaccinations];

--Joining the two tables CovidDeaths and CovidVacinations

Select *
from [ProjectPortfolio].[dbo].[CovidDeaths] as dea
Join [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
	ON dea.location = vac.location
	and dea.date = vac.date;


--looking at Total Population Vs Vaccinations.

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from [ProjectPortfolio].[dbo].[CovidDeaths] as dea
Join [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by dea.location, dea.date;

--looking at Total Population Vs Vaccinations.

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(Convert(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingVaccinated
From [ProjectPortfolio].[dbo].[CovidDeaths] as dea
Join [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by dea.location, dea.date;


--Looking at ICUPatients vs Total death 
Select Location, Max(cast(icu_patients as int)) as TotalIcuPatients, Max(total_deaths) as Total_death
From [ProjectPortfolio].[dbo].[CovidDeaths]
group by location
order by TotalIcuPatients Desc;


--looking at the population density vs the Total Cases
Select dea.Location, max(dea.total_cases) as TotalCases, max(vac.population_density) as PopulationDensity
From [ProjectPortfolio].[dbo].[CovidDeaths] dea
Join [ProjectPortfolio].[dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.location
order by PopulationDensity Desc;

---looking at Population Density vs Positive test rate
Select Location, max(population_density) as PopulationDensity, avg(cast(positive_rate as float))*1000 as PositiveRatePerThousand
from [ProjectPortfolio].[dbo].[CovidVaccinations]
where continent is not null and positive_rate is not null
group by Location
order by PopulationDensity Desc;

---looking at handwashing_facilities vs Total Death
Select dea.location, Max(vac.handwashing_facilities) as HandwashingFacilities, Max(dea.total_deaths) as TotalDeaths
from [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
Join [ProjectPortfolio].[dbo].[CovidDeaths] as dea
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and vac.handwashing_facilities is not null
Group by dea.Location
Order by HandwashingFacilities;


--looking at handwashing Facilities vs Total Cases
Select dea.location, Max(vac.handwashing_facilities) as HandwashingFacilities, max(dea.total_cases) as TotalCases
from [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
Join [ProjectPortfolio].[dbo].[CovidDeaths] as dea
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and vac.handwashing_facilities is not null
Group by dea.Location
Order by HandwashingFacilities;




--Using CTE to obtain percentage RollingVaccinations

With PopvVac(Continent, Location, Date, Population, New_vaccinations, RollingVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(Convert(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingVaccinated
From [ProjectPortfolio].[dbo].[CovidDeaths] as dea
Join [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)

Select *, (RollingVaccinated/Population)*100
from PopvVac



--Using a Temp Table

Drop Table If exists #PercentPopVacinated
Create Table #PercentPopVacinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVaccinated numeric
)

Insert into #PercentPopVacinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(Convert(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingVaccinated
From [ProjectPortfolio].[dbo].[CovidDeaths] as dea
Join [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

Select *, (RollingVaccinated/Population)*100
from #PercentPopVacinated




--Creating View to Store Data for later Visualizations

Create View PercentagePopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(Convert(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingVaccinated
From [ProjectPortfolio].[dbo].[CovidDeaths] as dea
Join [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

--Creating a View for Future Visualisation 
Create View TotalPopvsVacination  as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(Convert(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingVaccinated
From [ProjectPortfolio].[dbo].[CovidDeaths] as dea
Join [ProjectPortfolio].[dbo].[CovidVaccinations] as vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;