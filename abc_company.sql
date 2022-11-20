create database abc_company;
use abc_company;

DROP TABLE SALE;
DROP TABLE CUST_PREF_SALES;
DROP TABLE CUSTOMER;
DROP TABLE USES_PART;
DROP TABLE SUPPLIES_PART;
DROP TABLE INTERVIEW;
DROP TABLE JOB_POSITION;
DROP TABLE CANDIDATE;
DROP TABLE PRODUCT;
DROP TABLE PART;
DROP TABLE VENDOR;
DROP TABLE SALARY;
DROP TABLE WORKS_ON;
DROP TABLE SITE;
DROP TABLE SHIFTS;
DROP TABLE DEPARTMENT;
DROP TABLE EMPLOYEE;
DROP TABLE PHONE_NUMBER;
DROP TABLE PERSON;

CREATE TABLE PERSON 
(p_id char(10) NOT NULL,
fname varchar(10),
lname varchar(10),
gender char(1),
age int,
addr_line1 varchar(20),
addr_line2 varchar(20),
city varchar(15),
state char(2),
zipcode char(5),
CONSTRAINT CHK_age CHECK (age BETWEEN 18 AND 65),
CONSTRAINT CHK_gender CHECK (gender = 'M' OR gender = 'F'),
PRIMARY KEY (p_id));

CREATE TABLE PHONE_NUMBER
(person_id char (10) NOT NULL,
 phone_number char(10) NOT NULL,
PRIMARY KEY (phone_number, person_id),
FOREIGN KEY (person_id) REFERENCES PERSON(p_id)); 

CREATE TABLE EMPLOYEE
(e_id char (10) NOT NULL, 
title varchar (15), 
emp_rank int, 
sup_id char (10),
PRIMARY KEY(e_id), 
FOREIGN KEY (e_id) REFERENCES PERSON (p_id),
FOREIGN KEY (sup_id) REFERENCES EMPLOYEE(e_id));

CREATE TABLE DEPARTMENT
(d_id varchar(3) NOT NULL, 
dept_name varchar (15), 
PRIMARY KEY (d_id));  

CREATE TABLE SHIFTS
(emp_id char(10) NOT NULL,
dept_id varchar(3) NOT NULL,
s_start time NOT NULL,
s_end time NOT NULL,
PRIMARY KEY (emp_id, dept_id, s_start, s_end),
FOREIGN KEY (emp_id) REFERENCES EMPLOYEE(e_id),
FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(d_id));

CREATE TABLE SITE
(s_id char(10) NOT NULL,
site_name varchar(20),
location varchar(20),
PRIMARY KEY (s_id));

CREATE TABLE WORKS_ON
(employee_id char(10) NOT NULL,
site_id varchar(10) NOT NULL,
FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(e_id),
FOREIGN KEY (site_id) REFERENCES SITE(s_id));

CREATE TABLE SALARY
(employ_id char(10) NOT NULL,
year int NOT NULL,
salary int NOT NULL,
PRIMARY KEY (employ_id, year),
FOREIGN KEY (employ_id) REFERENCES EMPLOYEE(e_id));

CREATE TABLE VENDOR
(v_id char(10) NOT NULL,
v_name varchar(20),
v_address varchar(20),
account_num int,
credit_rating int, 
web_url varchar(20),
PRIMARY KEY (v_id),
CONSTRAINT chk_credit CHECK (credit_rating BETWEEN 300 AND 850));

CREATE TABLE PART
(p_type varchar(10),
weight int,
PRIMARY KEY (p_type),
CONSTRAINT chk_weight CHECK (weight > 0));

CREATE TABLE PRODUCT
(prod_id char(10),
prod_type varchar(10),
size varchar(5),
list_price float,
weight int,
style varchar(10),
PRIMARY KEY (prod_id));

CREATE TABLE CANDIDATE
(cand_id char(10) NOT NULL,
has_passed boolean DEFAULT FALSE,
PRIMARY KEY (cand_id),
FOREIGN KEY (cand_id) REFERENCES PERSON(p_id));

CREATE TABLE JOB_POSITION
(job_id char(10) NOT NULL,
description varchar(140),
post_date date,
depart_id varchar(3) NOT NULL,
PRIMARY KEY (job_id),
FOREIGN KEY (depart_id) REFERENCES DEPARTMENT(d_id));

CREATE TABLE INTERVIEW
(interviewee_id char(10) NOT NULL,
interviewer_id char(10) NOT NULL,
jobpos_id char(10) NOT NULL,
grade int,
inter_time datetime NOT NULL,
CONSTRAINT chk_grade CHECK (grade BETWEEN 0 AND 100),
PRIMARY KEY (interviewee_id, interviewer_id, jobpos_id, inter_time),
FOREIGN KEY (interviewee_id) REFERENCES CANDIDATE(cand_id),
FOREIGN KEY (interviewer_id) REFERENCES EMPLOYEE(e_id),
FOREIGN KEY (jobpos_id) REFERENCES JOB_POSITION(job_id));

CREATE TABLE SUPPLIES_PART 
(vendor_id char (10) NOT NULL,
p_type varchar(15),
price int,
PRIMARY KEY (vendor_id, p_type), 
FOREIGN KEY (vendor_id) REFERENCES VENDOR (v_id),
FOREIGN KEY (p_type) REFERENCES PART(p_type));

CREATE TABLE USES_PART 
(part_type varchar (10) NOT NULL, 
product_id varchar (10) NOT NULL, 
number_used int,
PRIMARY KEY (part_type, product_id), 
FOREIGN KEY (part_type) REFERENCES SUPPLIES_PART (p_type)); 

CREATE TABLE CUSTOMER
(cust_id char(10) NOT NULL,
PRIMARY KEY(cust_id),
FOREIGN KEY (cust_id) REFERENCES PERSON(p_id));

CREATE TABLE CUST_PREF_SALES
(customer_id char(10) NOT NULL,
pref_salesperson_id char(10) NOT NULL,
PRIMARY KEY(customer_id, pref_salesperson_id),
FOREIGN KEY(customer_id) REFERENCES CUSTOMER(cust_id),
FOREIGN KEY(pref_salesperson_id) REFERENCES EMPLOYEE(e_id));

CREATE TABLE SALE
(emp_sale_id char(10) NOT NULL,
cust_buyer_id char(10) NOT NULL,
sale_time datetime NOT NULL,
on_site_id char(10) NOT NULL,
product_sold_id char(10) NOT NULL,
num_sold int DEFAULT 1,
PRIMARY KEY (emp_sale_id, cust_buyer_id, sale_time),
FOREIGN KEY (emp_sale_id) REFERENCES EMPLOYEE(e_id),
FOREIGN KEY (cust_buyer_id) REFERENCES CUSTOMER(cust_id),
FOREIGN KEY (on_site_id) REFERENCES SITE(s_id),
CONSTRAINT chk_num_sold CHECK (num_sold > 0));
