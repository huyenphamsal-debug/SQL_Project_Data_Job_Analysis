/* 
Answer: what are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focus on roles with specified salaries, regardless of location
- Why ? It reveals how different skills impact salary levels for Data Analysts and 
help identify the most financially rewarding skills to acquire or improve  

*/


select 
    skills,
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
    skills
order BY
    avg_salary desc
limit 25;



/*
Here are the breakdown 
Big Data & Cloud Skills Pay Most 
– Tools like PySpark, Databricks, Airflow, and GCP show that analysts who can handle large-scale pipelines and cloud platforms earn top salaries.

ML & AI Knowledge is Highly Valued 
– Skills in DataRobot, Watson, and scikit-learn highlight strong demand for analysts who can move beyond reporting into predictive modeling.

Engineering + DevOps Edge 
– Programming (Python, Scala, Golang) plus DevOps tools (GitLab, Jenkins, Kubernetes) blur the line between analyst and engineer, driving higher pay.

*/