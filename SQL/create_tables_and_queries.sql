#Create Table total_cases_per_state
drop table if exists total_cases_per_state; 
create table if not exists total_cases_per_state (
	state varchar(20) not null unique, 
	total_cases integer not null,
	primary key(state)
);
load data local infile 'cases.csv' into table total_cases_per_state fields terminated by ',';


#Create Table total_population_per_state
drop table if exists total_population_per_state; 
create table if not exists total_population_per_state (
	state varchar(20) not null unique, 
	total_population integer not null,
	primary key(state)
);
load data local infile 'population.csv' into table total_population_per_state fields terminated by ',';


#Create Table moderna
drop table if exists moderna; 
create table if not exists moderna (
	state varchar(20) not null, 
	week varchar(10) not null,
	first_dose integer,
	second_dose integer,
	primary key(state, week)
);
load data local infile 'moderna.csv' into table moderna fields terminated by ',';


#Create Table pfizer
drop table if exists pfizer; 
create table if not exists pfizer (
	state varchar(20) not null, 
	week varchar(10) not null,
	first_dose integer,
	second_dose integer,
	primary key(state, week)
);
load data local infile 'pfizer.csv' into table pfizer fields terminated by ',';


#Create Table janssen
drop table if exists janssen; 
create table if not exists janssen (
	state varchar(20) not null, 
	week varchar(10) not null,
	only_dose integer,
	primary key(state, week)
);
load data local infile 'janssen.csv' into table janssen fields terminated by ',';


#Create Table total_vaccines_per_state
drop table if exists total_vaccines_per_state; 
create table if not exists total_vaccines_per_state (
	state varchar(20) not null unique, 
	total_vaccines integer not null, 
	primary key(state)
) 
as (select t1.s1 as state, (t1.total_vaccines1 + t2.total_vaccines2 + t3.total_vaccines3) as total_vaccines from (
(select state as s1, sum(second_dose) as total_vaccines1 from moderna group by state) as t1, 
(select state as s2, sum(second_dose) as total_vaccines2 from pfizer group by state) as t2, 
(select state as s3, sum(only_dose) as total_vaccines3 from janssen group by state) as t3) 
where t1.s1 = t2.s2 and t2.s2 = t3.s3 group by t1.s1);

#Query 1
select v.state, (total_vaccines / total_population) as vaccine_to_population_ratio 
from total_vaccines_per_state v inner join total_population_per_state p 
on v.state = p.state order by vaccine_to_population_ratio desc limit 10;

#Query 2
select c.state, (total_cases / total_population) as case_to_population_ratio 
from total_cases_per_state c inner join total_population_per_state p 
on c.state = p.state order by case_to_population_ratio desc limit 10;

#Query 3
select c.state, (total_vaccines / total_cases) as vaccine_to_cases_ratio 
from total_cases_per_state c inner join total_vaccines_per_state v 
on c.state = v.state order by vaccine_to_cases_ratio desc limit 10;

#Query 4
select * from (
	(select sum(second_dose) as moderna from moderna) as t1, 
	(select sum(second_dose) as pfizer from pfizer) as t2, 
	(select sum(only_dose) as janssen from janssen) as t3
);

#Query 5
select avg(vaccine_to_population_ratio) as avg_ratio from 
	(select (total_vaccines / total_population) as vaccine_to_population_ratio from 
	total_vaccines_per_state v, total_population_per_state p where v.state = p.state) 
as state_vaccinations;

#Query 6
select p.state, total_population, total_cases, total_vaccines 
from total_population_per_state p, total_cases_per_state c, total_vaccines_per_state v 
where p.state = c.state and c.state = v.state and p.state regexp '^M|^N' and 
total_population >= 5000000 and total_cases >= 500000 and total_vaccines >= 500000 
group by p.state order by p.state;

#Query 7
select (m1.total + m2.total + p1.total + p2.total + j1.total) as total_vaccines from (
	(select sum(m.first_dose) as total from moderna m) as m1, 
	(select sum(m.second_dose) as total from moderna m) as m2, 
	(select sum(p.first_dose) as total from pfizer p) as p1, 
	(select sum(p.second_dose) as total from pfizer p) as p2, 
	(select sum(j.only_dose) as total from janssen j) as j1
);

#Query 8
select
	((select sum(m.second_dose) from moderna m) * (1 - 0.941)) as moderna_infected, 
	((select sum(p.second_dose) from pfizer p) * (1 - 0.95)) as pfizer_infected, 
	((select sum(j.only_dose) from janssen j) * (1 - 0.72)) as janssen_infected; 

#Query 9
select p_total.week, (ifnull(p_total.weekly_doses,0) + ifnull(m_total.weekly_doses,0) 
+ ifnull(j_total.weekly_doses,0)) as weekly_vaccine_total from (
	(select week, sum(first_dose + second_dose) as weekly_doses from pfizer p group by week) as p_total 
	left join
	(select week, sum(first_dose + second_dose) as weekly_doses from moderna m group by week) as m_total 
	on p_total.week = m_total.week 
	left join
	(select week, sum(only_dose) as weekly_doses from janssen j group by week) as j_total
	on m_total.week = j_total.week
) order by weekly_vaccine_total desc;

#Query 10
select * from (
	(select vac1.state as moderna_state, max(vac1.moderna_percentage) as max_moderna_percentage from 
		(select m.state, (sum(m.second_dose) / p.total_population) as moderna_percentage from 
		moderna m join total_population_per_state p on m.state = p.state group by m.state
	  	) as vac1 
	group by vac1.moderna_percentage order by max_moderna_percentage desc limit 1) as max1,
	(select vac2.state as pfizer_state, max(vac2.pfizer_percentage) as max_pfizer_percentage from 
		(select pf.state, (sum(pf.second_dose) / p.total_population) as pfizer_percentage from 
		pfizer pf join total_population_per_state p on pf.state = p.state group by pf.state
	  	) as vac2
	group by vac2.pfizer_percentage order by max_pfizer_percentage desc limit 1) as max2,
	(select vac3.state as janssen_state, max(vac3.janssen_percentage) as max_janssen_percentage from 
		(select j.state, (sum(j.only_dose) / p.total_population) as janssen_percentage from 
		janssen j join total_population_per_state p on j.state = p.state group by j.state
	  	) as vac3
	group by vac3.janssen_percentage order by max_janssen_percentage desc limit 1) as max3
);