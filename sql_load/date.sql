
select 
    '2023-02-19':: date,
    '123':: integer,
    'true':: boolean,
    '3.14':: real;
/* EXPLAINATION 
In PostgreSQL, :: is the type cast operator.
It converts a value from one data type to another.
 :: date => convert string into date
 :: integer => convert string into integer (number)
 :: boolean => convert string into into a boolean type (true or false).
 :: real => convert string into real (floating-point number).
Result: 3.14 (numeric type with decimals).
Why useful: You can perform decimal calculations now.
*/

select 
    job_title_short as title,
    job_location as location,
    job_posted_date :: date as date
FROM
    job_postings_fact;


-- AT TIME ZONE 
-- Google postgresql.org/docs/7.2/timezones.html
-- Explaination Converting column job_posted_date from timezone 'utc' to 'EST'
select 
    job_title_short as title,
    job_location as location,
    job_posted_date at time zone 'UTC' at time zone 'EST' as date_time
FROM
    job_postings_fact
limit 5;

-- Extract 
-- Gets field (eg year, month, day) from a date/time value 
-- Explaination: extract the month from column job_posted_date into column date_month
select 
    job_title_short as title,
    job_location as location,
    job_posted_date at time zone 'UTC' at time zone 'EST' as date_time,
    extract(month from job_posted_date) as date_month,
    extract(year from job_posted_date) as date_year
FROM
    job_postings_fact
limit 5;


-- Using extract so that we can calcualte the number of job_posting per month so see the trend
select 
    count(job_id) as job_posted_count,
    extract(month from job_posted_date) as month
FROM   
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
group by 
    month
order by
    job_posted_count desc;


-- Get and create a table for all information from job_posting_fact but for Jan, Feb & March
-- Use ChapGPT to help with the repeatitive work 
    
-- January
CREATE TABLE january_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- February
CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March
CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

-- Test work 
select *
from january_jobs
limit 10;



/* CASE EXPERESSION 
A case expression in SQL is a way to apply conditional logic within your SQL Queries 
Case - begins the expression 
When - specifies the condition to look at 
then - what to do when the condition is true
else (optional) - provides output if non of the when conditions are met 
end - concludes the case expression 

CAN USE IN SELECT, WHERE, GROUP BY
*/


/*

Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

*/

select 
    COUNT(job_id) as number_of_jobs,
    case 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact
where 
    job_title_short = 'Data Analyst'
group by 
    location_category;

-- SUBQUERIES AND CTEs 
/* 

Subqueries and Common Table Expressions (CTEs): used to organizing and simplifying complex queries 
- Helps break down the query into smaller, more manageable parts
- when to use one over the other?
+ Subqueries are for simpler queries 
+ CTEs are for more complex queries 

*/

-- Get the company name in the company_dim table with the condition that TRUE for job_no_degree_mention in the job_postings_fact table 
-- Using subquery in this case 

select 
    company_id,
    name as company_name
from company_dim
where company_id in (
SELECT
    company_id
FROM
    job_postings_fact
where
    job_no_degree_mention = true
order by company_id
)

-- CTEs - Commmon table expression
/* 
Find the companies that have the most job openings
- Get the total number of job postings per company id (job_posting_fact)
- Return the total number of jobs with the company name (company_dim)

*/


With company_job_count as (
    select
        company_id,
        count(*) as total_jobs
    from 
        job_postings_fact
    group by 
        company_id
        )

select 
    company_dim.name  as company_name,
    company_job_count.total_jobs
from company_dim
Left join company_job_count 
    on 
        company_job_count.company_id = company_dim.company_id
order by total_jobs desc



/* 
Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill


*/

with remote_job_skills as (
select 
    --job_postings.job_id,
    skill_id,
    count(*) as skill_count
    --job_postings.job_work_from_home
FROM
    skills_job_dim as skills_to_job
inner join job_postings_fact as job_postings
    on 
        job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = True and 
    job_postings.job_title_short = 'Data Analyst'
group by 
    skill_id
)


--test
/* 
select *
from remote_job_skills
*/

select 
    skills.skill_id,
    skills as skill_name,
    skill_count
from remote_job_skills
inner join skills_dim as skills
on 
    skills.skill_id = remote_job_skills.skill_id

order by
    skill_count desc
limit 5;



-- UNION OPERATORS
/*
Combine result sets of two or more select statements into a single result set
- union: remove duplicate rows
- union all: includes all duplicate rows 

Note: each select statement within the union must have the same number of columns in the result sets with similar data types 

*/

select
    job_title_short,
    company_id,
    job_location
from 
    january_jobs

union all
-- get jobs and companies from February

select
    job_title_short,
    company_id,
    job_location
from 
    february_jobs

union all
-- get jobs and companies from March 

select
    job_title_short,
    company_id,
    job_location
from 
    march_jobs

/* 
Find job postings from the first quarter that have a salary greater than $70k
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Gets job postings with an average yearly salary > $70,000
*/


select 
    --quarter1_job_postings.job_title_short, 
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date :: date,
    quarter1_job_postings.salary_year_avg
from ( 
select *
from january_jobs
union ALL
select *
from february_jobs
union ALL
select *
from march_jobs
)
as quarter1_job_postings
where 
    quarter1_job_postings.salary_year_avg >70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
order BY
    quarter1_job_postings.salary_year_avg desc
