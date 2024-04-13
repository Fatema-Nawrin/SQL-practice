SELECT * FROM employees;
SELECT * FROM shops;
SELECT * FROM locations;
SELECT * FROM suppliers;

-- select some (3) columns of table
SELECT employee_id, first_name, last_name FROM employees;

SELECT *
FROM employees
WHERE salary > 50000;

SELECT *
FROM employees
WHERE salary > 50000 AND coffeeshop_id = 1;

SELECT *
FROM employees
WHERE salary > 50000 OR coffeeshop_id = 1;

SELECT *
FROM employees
WHERE salary > 50000 AND coffeeshop_id = 1 
AND gender = 'F';

SELECT *
FROM suppliers
WHERE supplier_name <> 'Beans and Barley';


SELECT *
FROM suppliers
WHERE coffee_type IN ('Robusta','Arabica')

SELECT *
FROM suppliers
WHERE coffee_type NOT IN ('Robusta','Arabica')

SELECT * 
FROM employees
Where email IS NULL


SELECT * 
FROM employees
Where NOT email IS NULL

SELECT
	employee_id,
	first_name,
	last_name,
	salary
FROM employees
WHERE salary BETWEEN 35000 AND 50000;

SELECT
	employee_id,
	first_name,
	last_name,
	salary
FROM employees
WHERE
	salary >=35000
	AND
	salary <=50000

-- The ORDER BY keyword sorts the records in ascending order by default.
SELECT
	employee_id,
	first_name,
	last_name,
	salary
FROM employees
ORDER BY salary;

SELECT
	employee_id,
	first_name,
	last_name,
	salary
FROM employees
ORDER BY salary DESC;

SELECT
	employee_id,
	first_name,
	last_name,
	salary
FROM employees
ORDER BY salary DESC
LIMIT 50;

-- DISTINCT
SELECT DISTINCT 
	coffeeshop_id
FROM employees

-- __RENAME
SELECT
	email,
	email AS email_address, 
	hire_date,
  hire_date AS date_joined,
	salary,
  salary AS pay
FROM employees;

SELECT
	EXTRACT(YEAR FROM hire_date) AS year,
	EXTRACT(MONTH FROM hire_date) AS month,
	EXTRACT(DAY FROM hire_date) AS day
FROM employees;


-- Uppercase 
SELECT
	first_name,
	UPPER(first_name) AS first_name_upper,
	last_name,
	LOWER(last_name) AS last_name_lower
FROM employees;



-- Length
SELECT
	email,
	LENGTH(email) AS email_length
FROM employees;

-- TRIM
SELECT
    LENGTH('     hi     ') AS hi_with_spaces,
	LENGTH('hi') AS hi_no_spaces,
    LENGTH(TRIM('     hi     ')) AS hi_trimmed;


-- Concatenate first and last names to create full names
SELECT
	first_name,
	last_name,
	first_name || ' ' || last_name AS full_name
FROM employees;



-- Boolean expressios
SELECT
	first_name || ' ' || last_name AS full_name,
	(salary < 50000) AS less_than_50k
FROM employees;


-- Boolean expressions with wildcards (% subString)

SELECT
	email,
	(email like '%.com%') AS dotcom_flag
FROM employees;

-- SUBSTRING

SELECT 
	email,
	SUBSTRING(email FROM 5)
FROM employees;

---POSITION
SELECT 
	email,
	POSITION('@' IN email)
FROM employees;

SELECT 
	email,
	SUBSTRING(email FROM POSITION('@' IN email))
FROM employees;

-- The default value is returned if the expression passed into the COALESCE() function is null
SELECT 
	email,
	COALESCE(email, 'NO EMAIL PROVIDED')
FROM employees;

-- MIN, MAX, AVG, SUM, COUNT
SELECT
  MIN(salary) as min_sal,
  MAX(salary) as max_sal,
  MAX(salary) - MIN(salary) as diff_sal,
  round(avg(salary), 0) as average_sal,
  sum(salary) as total_sal,
  count(*) as num_of_rows
FROM employees;


SELECT
  coffeeshop_id,
	COUNT(employee_id)
FROM employees
GROUP BY coffeeshop_id;


SELECT
	coffeeshop_id, 
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
    MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
ORDER BY num_of_emp DESC;


-- HAVING
-- After GROUP BY, return only the coffeeshops with more than 200 employees
SELECT
	coffeeshop_id, 
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
    MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
HAVING COUNT(*) > 200  -- filter, alter "where" after "gruop by"
ORDER BY num_of_emp DESC;



--CASE
SELECT
	employee_id,
	first_name,
	salary,
	CASE
		WHEN salary<20000 THEN 'low pay'
		WHEN salary BETWEEN 20000 and 50000 THEN 'medium pay'
		WHEN salary>=50000 THEN 'high pay'
		ELSE 'no pay'
	END
FROM employees
ORDER BY salary;



-- CASE & GROUP BY 

SELECT a.pay_category, COUNT(*)
FROM(
	SELECT
		employee_id,
	    first_name || ' ' || last_name as full_name,
		salary,
    CASE
			WHEN salary < 20000 THEN 'low pay'
			WHEN salary BETWEEN 20000 and 50000 THEN 'medium pay'
			WHEN salary > 50000 THEN 'high pay'
			ELSE 'no pay'
		END as pay_category
	FROM employees
	ORDER BY salary DESC
) a
GROUP BY a.pay_category;

-- Transpose above
SELECT
	SUM(CASE WHEN salary < 20000 THEN 1 ELSE 0 END) AS low_pay,
	SUM(CASE WHEN salary BETWEEN 20000 AND 50000 THEN 1 ELSE 0 END) AS medium_pay,
	SUM(CASE WHEN salary > 50000 THEN 1 ELSE 0 END) AS high_pay
FROM employees;



-- JOIN

-- LEFT JOIN
SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
	shops s
	LEFT JOIN locations l
	ON s.city_id = l.city_id;

-- RIGHT JOIN
SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
	shops s
	RIGHT JOIN locations l
	ON s.city_id = l.city_id;

-- FULL OUTER JOIN
SELECT
  s.coffeeshop_name,
  l.city,
  l.country
FROM
	shops s
	FULL OUTER JOIN locations l
	ON s.city_id = l.city_id;


-- Delete
DELETE FROM locations WHERE city_id = 4;
DELETE FROM shops WHERE coffeeshop_id = 6;


-- UNION (to stack data on top each other)

-- Return all cities and countries
SELECT city FROM locations
UNION
SELECT country FROM locations;

-- UNION removes duplicates
SELECT country FROM locations
UNION
SELECT country FROM locations;

-- UNION ALL keeps duplicates
SELECT country FROM locations
UNION ALL
SELECT country FROM locations;

-- Return all coffeeshop names, cities and countries
SELECT coffeeshop_name FROM shops
UNION
SELECT city FROM locations
UNION
SELECT country FROM locations;



-- -- Subqueries

-- -- Basic subqueries with subqueries in the FROM clause
-- SELECT *
-- FROM (
-- 	SELECT *
-- 	FROM employees
-- 	where coffeeshop_id IN (3,4)
-- ) as a;

-- SELECT
--   a.employee_id,
-- 	a.first_name,
-- 	a.last_name
-- FROM (
-- 	SELECT *
-- 	FROM employees
-- 	where coffeeshop_id IN (3,4)
-- ) a;

-- -- Basic subqueries with subqueries in the SELECT clause
-- SELECT
-- 	first_name, 
-- 	last_name, 
-- 	salary,
-- 	(
-- 		SELECT MAX(salary)
-- 		FROM employees
-- 		LIMIT 1
-- 	) max_sal
-- FROM employees;

-- SELECT
-- 	first_name, 
-- 	last_name, 
-- 	salary,
-- 	(
-- 		SELECT ROUND(AVG(salary), 0)
-- 		FROM employees
-- 		LIMIT 1
-- 	) avg_sal
-- FROM employees;

-- SELECT
-- 	first_name, 
-- 	last_name, 
-- 	salary, 
-- 	salary - ( -- avg_sal
-- 		SELECT ROUND(AVG(salary), 0)
-- 		FROM employees
-- 		LIMIT 1
-- 	) avg_sal_diff
-- FROM employees;

-- -- Subqueries in the WHERE clause
-- -- Return all US coffee shops
-- SELECT * 
-- FROM shops
-- WHERE city_id IN ( -- US city_id's
-- 	SELECT city_id
-- 	FROM locations
-- 	WHERE country = 'United States'
-- );

-- -- Return all employees who work in US coffee shops
-- SELECT *
-- FROM employees
-- WHERE coffeeshop_id IN ( -- US coffeeshop_id's
-- 	SELECT coffeeshop_id 
-- 	FROM shops
-- 	WHERE city_id IN ( -- US city-id's
-- 		SELECT city_id
-- 		FROM locations
-- 		WHERE country = 'United States'
-- 	)
-- );

-- -- Return all employees who make over 35k and work in US coffee shops
-- SELECT *
-- FROM employees
-- WHERE salary > 35000 AND coffeeshop_id IN ( -- US coffeeshop_id's
-- 	SELECT coffeeshop_id
-- 	FROM shops
-- 	WHERE city_id IN ( -- US city_id's
-- 		SELECT city_id
-- 		FROM locations
-- 		WHERE country = 'United States'
-- 	)
-- );

-- -- 30 day moving total pay
-- -- The inner query calculates the total_salary of employees who were hired "within" the 30-day period before the hire_date of the current employee
-- SELECT
-- 	hire_date,
-- 	salary,
-- 	(
-- 		SELECT SUM(salary)
-- 		FROM employees e2
-- 		WHERE e2.hire_date BETWEEN e1.hire_date - 30 AND e1.hire_date
-- 	) AS pay_pattern
-- FROM employees e1
-- ORDER BY hire_date;


























