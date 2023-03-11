Select *
From Covid19..CovidDeaths
Where continent is not null 
order by 3,4

SELECT TOP 10 * FROM Covid19.dbo.CovidDeaths
ORDER BY 3,4

-- Selecionar os dados que serão utilizados
SELECT location, date, population, total_cases, new_cases, total_deaths
FROM Covid19..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Totais de casos vs total de mortes
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'Porcentagem de mortes'
FROM Covid19..CovidDeaths
WHERE location = 'Brazil'
ORDER BY 5 desc

-- Totais de casos vs população
SELECT location, date, population, total_cases, (total_cases/population)*100 as 'Porcentagem de casos'
FROM Covid19..CovidDeaths
WHERE location = 'Brazil'
ORDER BY [Porcentagem de casos] desc

-- Países com a maior taxa de casos

SELECT location, population, MAX(total_cases) as 'Máx de Casos', MAX(total_cases/population)*100 as 'Porcentagem de casos'
FROM Covid19..CovidDeaths
--WHERE date BETWEEN '2020-01-22' and '2021-05-04'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY [Porcentagem de casos] desc

-- Países com maior taxa de mortes por população

SELECT location, population, max(cast(total_deaths as bigint)) as 'Máx de mortes', max(total_deaths/population)*100 as 'Porcentagem de mortes'
FROM Covid19..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY [Porcentagem de mortes] desc

-- Visão por continente

SELECT continent, max(cast(total_deaths as bigint)) as 'Máx de mortes', max(total_deaths/population)*100 as 'Porcentagem de mortes'
FROM Covid19..CovidDeaths
WHERE continent IS NOT NULL and date BETWEEN '2020-01-22' and '2021-05-04'
GROUP BY continent
ORDER BY [Porcentagem de mortes] desc


-- Visão global

SELECT date, sum(cast(new_deaths as bigint)) as 'Sum de mortes', sum(new_cases) as 'Sum de Casos' ,sum(cast(new_deaths as bigint))/SUM(new_cases)*100 as 'Porcentagem de mortes' 
FROM Covid19..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY [date] desc


-- População total vs vacinações
SELECT dea.continent, dea.location, dea.date, dea.population, max(new_vaccinations) as 'Vacinações' FROM
Covid19..CovidDeaths dea JOIN
Covid19..CovidVaccination vac
on	dea.location  = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent, dea.location, dea.date, dea.population
ORDER BY [date] desc


-- Usando CTE para executar o cálculo na partição por na consulta anterior

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid19..CovidDeaths dea
Join Covid19..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


SELECT 
location, date, population, total_cases, new_cases, total_deaths, new_deaths, sum(cast(new_deaths as bigint)) OVER (Partition by location) as 'Acumulado'
FROM Covid19..CovidDeaths
WHERE continent IS NOT NULL --and location = 'Brazil'
ORDER BY 1,2

SELECT location, sum(cast(new_deaths as bigint)) as 'mortes totais'
FROM Covid19..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 1

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid19..CovidDeaths dea
Join Covid19..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid19..CovidDeaths dea
Join Covid19..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
