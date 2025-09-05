/*
Answer: what are the most optimal skills to learn (aka its in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis. 

*/



with skills_demand as(
select 
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
inner join skills_job_dim on
    job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on
    skills_job_dim.skill_id = skills_dim.skill_id
where 
    job_title_short = 'Data Analyst' 
    And salary_year_avg is not null
    And job_work_from_home IS TRUE
group BY
    skills_dim.skill_id
),

 average_salary as (
select 
    skills_job_dim.skill_id,
    round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
inner join skills_job_dim on
    job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on
    skills_job_dim.skill_id = skills_dim.skill_id
where 
    job_title_short = 'Data Analyst'
    And salary_year_avg is not null
    And job_work_from_home IS TRUE
group BY
    skills_job_dim.skill_id
)

select 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
    inner join average_salary on 
    skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count >10
order BY
    avg_salary desc,
    demand_count desc
limit 25;


-- Rewriting this same query more concisely

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(job_postings_fact.salary_year_avg),0) as avg_salary
FROm job_postings_fact
inner join skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on 
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    and salary_year_avg  is not NULL
    and job_work_from_home = TRUE
group BY
    skills_dim.skill_id
HAVING
    count(skills_job_dim.job_id) >10
order BY
    avg_salary desc,
    demand_count desc
limit 25; 