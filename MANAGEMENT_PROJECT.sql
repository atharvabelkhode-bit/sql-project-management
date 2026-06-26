create database project_management;

use project_management;

create table clients(client_id  int primary key,
client_name varchar(100),
industry varchar(50),
contact_email varchar (100));

create table employees (employee_id int primary key,
name varchar (100),
role varchar (50),
department varchar(50));

create table projects(project_id int primary key,
project_name varchar (100),
client_id int,
start_date date,
deadline date,
status varchar(50),
foreign key (client_id) references clients (client_id));

create table tasks (task_id int primary key,
project_id int,
task_description varchar (300),
assignee_id int,
due_date date,
status varchar (50),
foreign key (project_id) references projects (project_id),
foreign key (assignee_id) references employees(employee_id));

create table task_assignments(assignment_id int primary key,
task_id int,
employee_id int,
assigned_date date,
foreign key (task_id) references tasks (task_id),
foreign key (employee_id) references employees (employee_id));

insert into clients values
(1,"abc corp","IT","abc@corp.com"),
(2,"xyz ltd","finance","xyz@ltd.com"),
(3,"GreenTech","ENERGY","CONTACT@greentech.com"),
(4,"healthplus","healthcare","info@healthplus.com"),
(5,"edusmart","education","support@edusmart.com");

insert into employees values 
(201,"Rahul","Developer","IT"),
(202,"Sneha","Project manager","Management"),
(203,"Amit","Tester","QA"),
(204,"Priya","Designer","UI/UX"),
(205,"Karan","Analyst","Business");

INSERT INTO employees (employee_id, name)
VALUES
(206, 'Karan'),
(207, 'Meera'),
(208, 'Vikash'),
(209, 'Anjali'),
(210, 'Rohit');

insert into projects values
(101,"website revamp",1,"2026-01-01","2026-03-01","IN Progress"),
(102,"mobile app dev",2,"2026-02-01","2026-05-01","Not started"),
(103,"solar dashboard",3,"2026-01-15","2026-04-15","IN Progress"),
(104,"patient system",4,"2026-03-01","2026-06-01","Not started"),
(105,"lms platform",5,"2026-02-10","2026-05-20","completed");

INSERT INTO projects (project_id, project_name, deadline, status)
VALUES (1, 'Website Redesign', '2024-01-10', 'In Progress');

INSERT INTO tasks VALUES
(301, 101, 'UI Design', 204, '2026-01-15', 'Completed'),
(302, 101, 'Backend Setup', 201, '2026-02-01', 'In Progress'),
(303, 102, 'Requirement Analysis', 205, '2026-02-10', 'Not Started'),
(304, 103, 'API Integration', 201, '2026-03-01', 'In Progress'),
(305, 104, 'Testing', 203, '2026-04-01', 'Not Started');



INSERT INTO task_assignments VALUES
(401, 301, 204, '2026-01-05'),
(402, 302, 201, '2026-01-10'),
(403, 303, 205, '2026-02-05'),
(404, 304, 201, '2026-02-20'),
(405, 305, 203, '2026-03-01');

INSERT INTO tasks VALUES
(306, 101, 'Frontend Development', 201, '2026-01-20', 'In Progress'),
(307, 101, 'Testing UI', 203, '2026-01-25', 'Completed'),
(308, 101, 'Deployment', 202, '2026-01-30', 'Not Started'),
(309, 102, 'UI Design App', 204, '2026-02-15', 'Completed'),
(310, 102, 'Backend API', 201, '2026-02-20', 'In Progress');

INSERT INTO task_assignments VALUES
(406, 306, 201, '2026-01-12'),
(407, 307, 203, '2026-01-15'),
(408, 308, 202, '2026-01-18'),
(409, 309, 204, '2026-02-10'),
(410, 310, 201, '2026-02-12');


UPDATE projects
SET deadline = '2025-01-01'
WHERE project_id = 101;

INSERT INTO task_assignments VALUES
(411, 301, 201, '2026-01-06'),
(412, 302, 201, '2026-01-11');

INSERT INTO tasks VALUES
(313, 103, 'Bug Fixing', 203, CURDATE() + INTERVAL 6 DAY, 'In Progress'),
(314, 104, 'Final Testing', 203, CURDATE() + INTERVAL 8 DAY, 'Not Started');

SELECT*FROM CLIENTS;

SELECT*FROM EMPLOYEES;

select*FROM PROJECTS;

select*FROM TASKS;

select*FROM TASK_ASSIGNMENTS;

--  1.	List all tasks for a specific project along with the assigned employees.

SELECT t.task_id, t.task_description, e.name
FROM tasks t
JOIN task_assignments ta ON t.task_id = ta.task_id
JOIN employees e ON ta.employee_id = e.employee_id
WHERE t.project_id = 102;


-- 2.	Find the number of projects per client.

SELECT c.client_name, COUNT(p.project_id) AS total_projects
FROM clients c
LEFT JOIN projects p ON c.client_id = p.client_id
GROUP BY c.client_name;

-- 3.	Identify employees who are currently assigned to more than 3 tasks.

SELECT e.name, COUNT(ta.task_id) AS task_count
FROM employees e
JOIN task_assignments ta ON e.employee_id = ta.employee_id
GROUP BY e.name
HAVING COUNT(ta.task_id) > 3;

-- 4.	Calculate the number of completed tasks per project.

SELECT p.project_name, COUNT(t.task_id) AS completed_tasks
FROM projects p
JOIN tasks t ON p.project_id = t.project_id
WHERE t.status = 'Completed'
GROUP BY p.project_name;

-- 5.	List all projects that are overdue (deadline < today and status not 'Completed').

SELECT project_name, deadline, status
FROM projects
WHERE deadline < CURDATE()
AND status != 'Completed';

-- 6.	Find the client with the most projects.

SELECT c.client_name, COUNT(p.project_id) AS total_projects
FROM clients c
JOIN projects p ON c.client_id = p.client_id
GROUP BY c.client_name
ORDER BY total_projects DESC
LIMIT 1;

-- 7.	Calculate the average number of tasks per project.

SELECT AVG(task_count) AS avg_tasks
FROM (
    SELECT COUNT(*) AS task_count
    FROM tasks
    GROUP BY project_id
) AS temp;

-- 8.	Identify employees who have no assigned tasks.

SELECT e.name
FROM employees e
LEFT JOIN task_assignments ta ON e.employee_id = ta.employee_id
WHERE ta.task_id IS NULL;

-- 9.	Find the project with the highest number of assigned employees. 

SELECT p.project_name, COUNT(ta.employee_id) AS total_employees
FROM projects p
JOIN tasks t ON p.project_id = t.project_id
JOIN task_assignments ta ON t.task_id = ta.task_id
GROUP BY p.project_name
ORDER BY total_employees DESC
LIMIT 1;

-- 10.	List all tasks that are due in the next 7 days.

SELECT task_description, due_date
FROM tasks
WHERE due_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);


