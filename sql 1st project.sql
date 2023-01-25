select location,date,total_cases,new_cases,total_deaths,population from coviddeaths order by 1,2;

-- Looking for % death
select location,date,total_cases,new_cases,total_deaths,population,(total_deaths/total_cases)*100 as Percentdeath from coviddeaths order by 1,2;

-- % death in India
select location,date,total_cases,new_cases,total_deaths,population,(total_deaths/total_cases)*100 as Percentdeath from coviddeaths where location='India' order by 3;

-- total deaths according to location
select sum(total_cases),location from coviddeaths group by location;

-- tatal deaths according to continent
select sum(total_cases),continent from coviddeaths where continent is not null  group by continent;

-- max number of deaths according to location
select max(total_deaths),location from coviddeaths where continent is not null  group by location;

select location,date,total_cases,new_cases,total_deaths,population from coviddeaths order by 1,

 -- % polpulation affected
 select location,date,total_cases,new_cases,total_deaths,population,(total_cases/population)*100 as PerfectPopulationaffected from coviddeaths order by 1,2 ;
 
 select * from covidvaccination;
 select date,location,people_vaccinated,total_vaccinations,total_tests from covidvaccination;
 
 -- total tests according to location
 select location,sum(total_tests)from covidvaccination group by location;
 
 -- tests in random country descending order
 select location,date, total_tests from covidvaccination where location like '%am%' order by 3 desc;
 
 -- joining the table covidvaccination and coviddeaths
 select *from coviddeaths dea join covidvaccination vac on dea.location=vac.location and dea.date=vac.date;
 select dea.location,dea.date,dea.population,vac.total_tests from coviddeaths dea join covidvaccination vac on dea.location=vac.location and dea.date=vac.date;
 
 -- sum of total test done with location
 select dea.location,sum(vac.total_tests) from coviddeaths dea join covidvaccination vac on dea.location=vac.location and dea.date=vac.date group by dea.location;

-- max and min test done with location and date
 select dea.location,max(vac.total_tests),min(vac.total_tests) from coviddeaths dea join covidvaccination vac on dea.location=vac.location and dea.date=vac.date group by dea.location;
 
 -- sum and max test done in india
  select dea.location,max(vac.total_tests),sum(vac.total_tests) from coviddeaths dea join covidvaccination vac on dea.location=vac.location and dea.date=vac.date where dea.location='India';
  
  
 

 












