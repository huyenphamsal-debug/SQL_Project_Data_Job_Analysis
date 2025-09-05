# Introduction
Dive into the data

# Background
# Tools I used
# The Analysis
# What I Learned
# Conclusions
Introduction

The Data Jobs SQL Project explores the job market in the field of data, with a primary focus on the Data Analyst role. Using SQL, the project analyzes a dataset of job postings to uncover valuable insights about the industry.

Used structured queries in this project to highlight the relationship between job roles, required skills, and compensation, helping aspiring professionals understand where to focus their efforts in building a career in data.

Check Out SQL queries here: project_sql folder
Background

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from Luke Barousse [SQL Course] (https://lukebarousse.com/sql),(https://youtu.be/7mz73uXD9DA?si=HOv77VLKni9yUvIe). It's packed with insights on job titles, salaries, locations, and essential skills.
The questions I wanted to answer through my

SQL queries were:

    What are the top-paying data analyst jobs?
    What skills are required for these top-paying jobs?
    What skills are most in demand for data analysts?
    Which skills are associated with higher salaries?
    What are the most optimal skills to learn?

Tools I Used

For my deep dive into the data analyst job market, I harnessed the power of several key tools:

    SQL: The backbone of my analysis, allowing me to query the database and unearth critical insights.
    PostgreSQL: The chosen database management system, ideal for handling the job posting data.
    Visual Studio Code: My go-tg for database management and executing SQL queries.
    Git & GitHub: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:
Top Paying Data Analyst Jobs

To identify the highest-paying rolesI I filtered data analyst positions by average yearly salary and location, focusing on jobs having location as India. This query highlights the high paying opportunities in the field.

SELECT
    job_id,
    job_title,
    name as company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date    
FROM
    job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'India' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

Top Skills Bar Chart
Top Skills For Data Analysts in India
Insights

Core trio = SQL + Excel + Python → must-have for most data analyst jobs.

Visualization tools (Tableau, Power BI) are valuable differentiators.

AI/ML frameworks (TensorFlow, PyTorch) show up, suggesting overlap with data science.

Collaboration & documentation tools (Jira, Confluence, Word, Visio) are expected in enterprise settings.

Cloud & systems knowledge (Azure, Unix, Windows) indicates a shift towards hybrid analyst-engineer roles. Salary by Job Title Bar Chart
Word Cloud Representation

    Skill Demand Word Cloud

Other Areas of Analysis include:
Top Demanded Skills
Top Paying Skills
Optimal Skills(skills that offer job security(high demand) and financial benefits, offering strategic insights for career development in data analysis)
What I Learned

Through this project, I gained hands-on experience applying SQL to a real-world dataset and uncovered how data analysis can answer practical career-related questions. Key learnings include:

    SQL Mastery – Strengthened my skills in writing complex queries, using joins, filtering, aggregations, and ranking to extract meaningful insights.

    Data-Driven Thinking – Learned how to translate broad career questions (like “What skills should I learn?”) into structured queries and measurable outcomes.

    Industry Awareness – Discovered the most in-demand and high-paying skills for data analysts in India, providing clarity on which tools and technologies drive career growth.

Conclusion

The Data Jobs SQL Project demonstrates how SQL can be used to navigate the fast-growing field of data analytics. By analyzing job postings, the project identifies:

    The top-paying data analyst roles in India.

    The essential and in-demand skills required by employers.

    The skills that not only secure jobs but also maximize salary potential.
