/* VIEWS */

/* View 1 */
CREATE VIEW AVG_SALARY AS
(SELECT p_id, fname, lname, (AVG(SALARY.salary)/12) AS avg_monthly_sal
FROM PERSON, EMPLOYEE, SALARY
WHERE PERSON.p_id=EMPLOYEE.e_id and EMPLOYEE.e_id=SALARY.employ_id
GROUP BY EMPLOYEE.e_id);

/* View 2 */
CREATE VIEW ROUNDS_PASSED AS
SELECT interviewee_id,  jobpos_id, grade
FROM INTERVIEW
WHERE grade > 60;

/* View 3 */
CREATE VIEW ITEM_PRODUCT AS
(SELECT prod_type, SUM(num_sold) AS amt_sold
FROM PRODUCT, SALE
WHERE PRODUCT.prod_id=SALE.product_sold_id
GROUP BY prod_id);

/* VIEW4 (PRODUCT_COST) is created using an intermediary view CHEAPEST_PARTS */
/* Intermediary View */
CREATE VIEW CHEAPEST_PARTS AS
(SELECT p_type, MIN(price) AS price
FROM SUPPLIES_PART
GROUP BY p_type);

/* View 4 */
CREATE VIEW PRODUCT_COST AS
(SELECT prod_type, SUM(number_used * price) AS min_cost
FROM PRODUCT, USES_PART, CHEAPEST_PARTS
WHERE PRODUCT.prod_id=USES_PART.product_id and USES_PART.part_type=CHEAPEST_PARTS.p_type
GROUP BY prod_type);

/* QUERIES */

/* Query 1 */
SELECT EMPLOYEE.e_id, PERSON.fname, PERSON.lname FROM EMPLOYEE, PERSON
WHERE EMPLOYEE.e_id = PERSON.p_id and EMPLOYEE.e_id IN (
    SELECT INTERVIEW.interviewer_id FROM INTERVIEW
    WHERE INTERVIEW.jobpos_id = '11111' and INTERVIEW.interviewee_id IN (
        SELECT CANDIDATE.cand_id FROM CANDIDATE
        WHERE CANDIDATE.cand_id IN (
            SELECT PERSON.p_id FROM PERSON
            WHERE PERSON.fname = 'Hellen' AND PERSON.lname = 'Cole'
        )));
        
/* Query 2 */
SELECT job_id
FROM JOB_POSITION, DEPARTMENT
WHERE JOB_POSITION.depart_id=DEPARTMENT.d_id and DEPARTMENT.dept_name="Marketing" and (post_date BETWEEN "2011-01-01" AND "2011-01-31");

/* Query 3 */
SELECT p_id, fname, lname
FROM PERSON, EMPLOYEE
WHERE p_id=e_id and sup_id is NULL;

/* Query 4 */
SELECT site.s_id, site.location, c.on_site_id 
FROM SITE as SITE
left join sale as c on site.s_id=c.on_site_id
where (sale_time not between "2011-03-01" and "2011-03-31");

/* Query 5 */
SELECT job_id, description
FROM JOB_POSITION
WHERE post_date <= DATE_ADD(NOW(), INTERVAL -30 DAY);

/* Query 6 */
SELECT p_id, fname, lname
FROM PERSON, EMPLOYEE
WHERE p_id=e_id and e_id IN
    (SELECT emp_sale_id
    FROM SALE, PRODUCT
    WHERE SALE.product_sold_id=PRODUCT.prod_id and (emp_sale_id) IN
        (SELECT emp_sale_id
        FROM SALE, PRODUCT
        WHERE SALE.product_sold_id=PRODUCT.prod_id and list_price > 200
        GROUP BY emp_sale_id
        HAVING COUNT(DISTINCT prod_id)=    
            (SELECT COUNT(*)
            FROM PRODUCT
            WHERE list_price > 200)
        )
    );

/* Query 7 */
SELECT DEPARTMENT.d_id, DEPARTMENT.dept_name, b.post_date
FROM DEPARTMENT as DEPARTMENT
left join JOB_POSITION as b on DEPARTMENT.d_id = b.depart_id
WHERE (post_date not between "2011-01-01" and "2011-02-01");

/* Query 8 */
SELECT p_id, fname, lname, dept_id
FROM PERSON, EMPLOYEE, SHIFT
WHERE PERSON.p_id=EMPLOYEE.e_id and EMPLOYEE.e_id=SHIFT.emp_id and e_id IN
    (SELECT DISTINCT(cand_id)
    FROM CANDIDATE, INTERVIEW
    WHERE cand_id=interviewee_id and jobpos_id="12345");

/* Query 9 */
SELECT prod_type
FROM ITEM_PRODUCT
WHERE ITEM_PRODUCT.amt_sold in
    (SELECT MAX(amt_sold)
    FROM ITEM_PRODUCT);

/* Query 10 */
SELECT PRODUCT.prod_type, MAX(list_price - min_cost)
FROM PRODUCT, PRODUCT_COST
WHERE PRODUCT.prod_type=PRODUCT_COST.prod_type;

/* Query 11 */
SELECT emp_id, fname, lname, COUNT(SHIFT.dept_id)
FROM PERSON, EMPLOYEE, SHIFT
WHERE PERSON.p_id=EMPLOYEE.e_id and EMPLOYEE.e_id=SHIFT.emp_id
GROUP BY SHIFT.emp_id
HAVING COUNT(DISTINCT SHIFT.dept_id)=
    (SELECT COUNT(DISTINCT d_id)
    FROM DEPARTMENT);

/* Query 12 */
SELECT fname, lname, addr_line1, addr_line2, city, state, zipcode
FROM PERSON, CANDIDATE
WHERE p_id=cand_id and has_passed=true;

/* Query 13 */
SELECT PERSON.fname, PERSON.lname, PERSON.addr_line1, PERSON.addr_line2, PERSON.city, PERSON.state, PERSON.zipcode 
FROM PERSON
WHERE PERSON.p_id IN (
    SELECT INTERVIEW.interviewee_id 
    FROM INTERVIEW
    WHERE INTERVIEW.interviewee_id IN (
        SELECT CANDIDATE.cand_id 
        FROM CANDIDATE
        WHERE CANDIDATE.has_passed = true
		)
	);

/* Query 14 */
SELECT p_id, fname, lname
FROM AVG_SALARY
WHERE avg_monthly_sal IN
    (SELECT MAX(avg_monthly_sal)
    FROM AVG_SALARY);

/* Query 15 */
SELECT v_id, v_name
FROM VENDOR, SUPPLIES_PART
WHERE VENDOR.v_id=SUPPLIES_PART.vendor_id and SUPPLIES_PART.price IN
	(SELECT MIN(price)
	FROM SUPPLIES_PART, PART
	WHERE SUPPLIES_PART.p_type=PART.p_type and SUPPLIES_PART.p_type="Cup" and PART.weight < 4);

