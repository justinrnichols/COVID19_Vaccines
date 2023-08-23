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
