# SQL-50 Solutions

## ``Select Statements``

### 1757. Recyclable and Low Fat Products
```bash
SELECT product_id 
FROM  Products
WHERE low_fats = 'Y' AND recyclable = 'Y';
```

---

### 584. Find Customer Referee
```bash
SELECT name 
FROM Customer 
WHERE referee_id IS NULL 
OR referee_id != 2;
```

---

### 595. Big Countries
```bash
SELECT name, population, area 
FROM World AS w
WHERE w.area >= 3000000 || w.population >= 25000000;
```

---

### 1148. Article Views I
```bash
SELECT DISTINCT V.author_id AS id  FROM Views AS V 
WHERE V.author_id = V.viewer_id 
ORDER BY V.author_id ASC;
```

---

### 1683. Invalid Tweets
```bash
SELECT T.tweet_id 
FROM Tweets AS T 
WHERE LENGTH(T.content) > 15; 
```

---



## ``Basic Joins``


### 1378. Replace Employee ID With The Unique Identifier
```bash
SELECT U.unique_id AS unique_id, E.name AS name
FROM Employees E
LEFT JOIN EmployeeUNI U
ON U.id = E.id
```

---


### 1068. Product Sales Analysis I
```bash
SELECT p.product_name ,s.year AS year , s.price AS price   
FROM Sales s 
INNER JOIN Product AS p
ON p.product_id = s.product_id;
```

---


### 1581. Customer Who Visited but Did Not Make Any Transactions
```bash
SELECT V.customer_id , COUNT(V.customer_id) AS count_no_trans
FROM Visits AS V
LEFT JOIN Transactions AS T
ON V.visit_id = T.visit_id
WHERE T.transaction_id IS NULL
GROUP BY V.customer_id
```

---


### 197. Rising Temperature
```bash
SELECT W1.id
FROM Weather AS W1
INNER JOIN Weather AS W2
WHERE DATEDIFF(W1.recordDate,W2.recordDate) = 1 
AND W1.temperature > W2.temperature

```
---

### 1661. Average Time of Process per Machine
```bash
WITH SE AS (
    SELECT A.machine_id AS machine_id,
    SUM(A.timestamp) AS start_end, COUNT(A.machine_id) AS CNT
    FROM Activity AS A
    GROUP BY A.machine_id , A.activity_type
    
)
SELECT S.machine_id,
ROUND((MAX(S.start_end) - MIN(S.start_end))/(SUM(S.CNT)/2),3) AS processing_time
FROM SE AS S 
GROUP BY S.machine_id

```

---


### 577. Employee Bonus
```bash
SELECT e.name,b.bonus 
FROM Employee e 
LEFT JOIN Bonus b 
ON b.empId = e.empId 
WHERE b.bonus < 1000 OR b.bonus IS NULL;

```

---

### Students and Examinations
```bash
WITH ss AS (
    SELECT  S.student_id AS student_id,
    S.student_name AS student_name,
    SB.subject_name AS subject_name
    FROM  Students S
    JOIN Subjects SB
),
ex AS (
    SELECT E.student_id AS student_id, E.subject_name AS subject_name ,
    COUNT(E.student_id) AS attended_exams
    FROM Examinations AS E
    GROUP BY E.student_id, E.subject_name
),
x AS (SELECT s.student_id AS student_id ,
s.student_name AS student_name ,
s.subject_name AS subject_name, 
e.attended_exams AS attended_exams
 FROM ss AS s
LEFT JOIN ex AS e
ON s.student_id = e.student_id
AND s.subject_name = e.subject_name
ORDER BY s.student_id,s.subject_name ASC )
SELECT a.student_id AS student_id, 
    a.student_name AS student_name ,
    a.subject_name AS subject_name, 
    IFNULL(a.attended_exams, 0) AS attended_exams
FROM x as a;


```

---

### 570. Managers with at Least 5 Direct Reports
```bash
SELECT E1.name
FROM Employee E1
JOIN Employee E2
ON E1.id = E2.managerId
GROUP BY E1.name,E2.managerId
HAVING COUNT(E2.managerId) >= 5
```

---

### Confirmation Rate
```bash
SELECT S.user_id,
    CASE WHEN
    C.action IS NULL
    THEN 0
    ELSE
    (ROUND(
    1.0 * COUNT(CASE WHEN C.action = 'confirmed' THEN 1 END)
    / NULLIF(COUNT(CASE WHEN C.action IN ('confirmed','timeout') THEN 1 END), 0),
    2
))  END AS confirmation_rate

FROM Signups S
LEFT JOIN Confirmations C
ON S.user_id = C.user_id
GROUP BY S.user_id
```

---


## ``Basic Aggregate Functions``

### 620. Not Boring Movies
```bash
SELECT * FROM Cinema AS c
WHERE c.id % 2 = 1 AND  c.description != 'boring'
ORDER BY c.rating DESC;
```

---



### 1251. Average Selling Price
```bash
SELECT P.product_id AS product_id,
    CASE 
        WHEN COUNT(U.units)>0
        THEN ROUND(SUM(U.units * P.price) * 1.0 / SUM(U.units), 2)
        ELSE 0
    END AS average_price
FROM Prices AS P
LEFT JOIN UnitsSold AS U
ON P.product_id = U.product_id
WHERE U.purchase_date IS  NULL
  OR U.purchase_date BETWEEN P.start_date AND P.end_date
GROUP BY P.product_id
```

---



### 1075. Project Employees I
```bash
SELECT P.project_id, 
    ROUND(AVG(E.experience_years),2) AS average_years
    FROM Project P
    INNER JOIN Employee E
    ON P.employee_id = E.employee_id
    GROUP BY P.project_id;
```

---


### 1633. Percentage of Users Attended a Contest
```bash
SELECT
    R.contest_id,
    ROUND((COUNT(R.user_id) * 1.0 / (SELECT COUNT(*) FROM Users U))* 100 ,2) AS percentage 
FROM Users U
INNER JOIN Register R
ON U.user_id = R.user_id
GROUP BY R.contest_id
ORDER BY percentage DESC ,contest_id ASC
```

---


### 1211. Queries Quality and Percentage
```bash
SELECT 
    q.query_name,
    ROUND(AVG(q.rating / q.position), 2) AS quality,
    ROUND(SUM(CASE WHEN q.rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS poor_query_percentage
FROM Queries q
GROUP BY q.query_name;
```

---


### 1193. Monthly Transactions I
```bash
SELECT 
    DATE_FORMAT(T.trans_date,'%Y-%m') AS month,
    T.country,
    COUNT(T.trans_date) AS trans_count,
    COUNT(
        CASE WHEN T.state = 'approved' THEN 1 END
    ) AS approved_count,
    SUM(T.amount) AS trans_total_amount,
    SUM(CASE WHEN T.state = 'approved' THEN T.amount ELSE 0 END ) AS approved_total_amount
    FROM Transactions T
    GROUP BY DATE_FORMAT(T.trans_date,'%Y-%m') ,T.country
```

---


### 1174. Immediate Food Delivery II
```bash
WITH tb AS (
    SELECT D.*
    FROM  Delivery D
    WHERE D.order_date = (
        SELECT MIN(order_date)
        FROM Delivery
        WHERE customer_id = D.customer_id
    )
)
SELECT 
ROUND(
        (COUNT(CASE WHEN t.customer_pref_delivery_date = t.order_date THEN 1 END) * 1.0) 
        / COUNT(*) * 100, 2
    ) AS immediate_percentage

FROM tb t;
```

---
### 550. Game Play Analysis IV
```bash
WITH MIN_DATE AS (SELECT A.* FROM 
Activity A 
WHERE A.event_date = (
    SELECT MIN(event_date)
    FROM Activity
    WHERE player_id = A.player_id
)),
FIRST_DATE AS(
    SELECT A1.*
FROM Activity A1
WHERE event_date IN (
    SELECT MD.event_date + INTERVAL 1 DAY
    FROM MIN_DATE AS MD
    WHERE MD.player_id = A1.player_id
))

SELECT 
    ROUND(COUNT(*) * 1.0 / (SELECT COUNT(DISTINCT player_id) FROM Activity),2) AS fraction
FROM FIRST_DATE FD;

```

---

## ``Sorting and Grouping``


### 2356. Number of Unique Subjects Taught by Each Teacher
```bash
SELECT T.teacher_id , COUNT(DISTINCT T.subject_id) AS cnt
FROM Teacher T
GROUP BY T.teacher_id

```

---



### 1141. User Activity for the Past 30 Days I
```bash
SELECT A.activity_date AS day, COUNT(DISTINCT A.user_id) AS active_users
FROM Activity A
WHERE A.activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY A.activity_date
```

---



### 1070. Product Sales Analysis III
```bash
SELECT 
    S1.product_id,
    S1.year AS first_year,
    S1.quantity,
    S1.price
FROM Sales S1
JOIN (
    SELECT 
        product_id, 
        MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
) S2
    ON S1.product_id = S2.product_id 
   AND S1.year = S2.first_year;



```

---



### 596. Classes With at Least 5 Students
```bash
SELECT class 
FROM Courses
GROUP BY class
HAVING COUNT(class) >= 5;
```

---



### 1729. Find Followers Count
```bash
SELECT F.user_id, COUNT(*) AS followers_count
FROM Followers F
GROUP BY F.user_id 
ORDER BY F.user_id ASC
```

---



### 619. Biggest Single Number
```bash
WITH cnt_no AS (
    SELECT num, COUNT(num) FROM MyNumbers AS my
    GROUP BY num
    HAVING COUNT(num) = 1
)
SELECT MAX(num) AS num FROM cnt_no;
```

---



### 1045. Customers Who Bought All Products
```bash
SELECT C.customer_id 
FROM Customer C
GROUP BY C.customer_id
-- ORDER BY C.customer_id ASC
HAVING COUNT(DISTINCT C.product_key) = (SELECT COUNT(*) FROM Product)
```

---


## ``Advanced Select and Joins``


### 1731. The Number of Employees Which Report to Each Employee
```bash
SELECT E1.employee_id,
E1.name, 
COUNT(E2.name) AS reports_count,
ROUND(AVG(E2.age)) AS average_age
FROM Employees E1
JOIN Employees E2
ON E1.employee_id = E2.reports_to
GROUP BY E1.employee_id
ORDER BY E1.employee_id ASC
```

---



### 1789. Primary Department for Each Employee
```bash
SELECT E1.employee_id,
    CASE
        WHEN COUNT(E1.employee_id) = 1 
             AND MAX(E1.primary_flag) = 'N'
        THEN MAX(E1.department_id)

        WHEN COUNT(E1.employee_id) > 1 
             AND SUM(CASE WHEN E1.primary_flag = 'Y' THEN 1 ELSE 0 END) > 0
        THEN MAX(CASE WHEN E1.primary_flag = 'Y' THEN E1.department_id END)
    END AS department_id
FROM Employee E1
GROUP BY E1.employee_id;

```

---



### 610. Triangle Judgement
```bash
-- x + y > z
-- x + z > y
-- y + z > x

SELECT x,y,z , 
CASE WHEN x+y > z AND x + z > y AND y + z > x 
    THEN 'Yes'
    ELSE 'No'
END
AS triangle  
FROM Triangle;
```

---



### 180. Consecutive Numbers
```bash
WITH diff AS (
    SELECT 
        L1.id AS id_num,
        L1.num
    FROM Logs L1
    INNER JOIN Logs L2
        ON L1.num = L2.num 
       AND (L1.id - L2.id) = 1
)
SELECT D1.num AS ConsecutiveNums
FROM diff D1
INNER JOIN diff D2
    ON D1.num = D2.num
   AND (D1.id_num - D2.id_num) = 1
   GROUP BY D1.num;

```

---



### 1164. Product Price at a Given Date
```bash
WITH T1 AS (SELECT product_id , COALESCE(new_price, 10) AS price
FROM Products
GROUP BY product_id),

T2 AS (SELECT P1.product_id,P1.new_price
FROM Products P1
-- INNER JOIN Products P2
WHERE P1.change_date = (
    SELECT MAX(change_date) 
    FROM Products
    WHERE product_id = P1.product_id
    AND change_date <= '2019-08-16'
) )
SELECT T1.product_id , COALESCE(T2.new_price, 10) AS price
FROM T1
LEFT JOIN T2
ON T1.product_id = T2.product_id
```

---



### 1204. Last Person to Fit in the Bus
```bash
WITH WE AS (
    SELECT Q.person_name,
    SUM(Q.weight) OVER (ORDER BY Q.turn ASC) AS sump
    FROM Queue Q)
SELECT person_name 
FROM WE 
WHERE sump <= 1000 
ORDER BY sump DESC 
LIMIT 1;
```

---



### 1907. Count Salary Categories
```bash
SELECT C.category , COALESCE(t.accounts_count, 0) AS accounts_count
FROM
    (SELECT 'Low Salary' AS category
    UNION ALL
    SELECT 'Average Salary'
    UNION ALL
    SELECT 'High Salary') C
LEFT JOIN (
    SELECT 
    CASE 
        WHEN A.income < 20000 
        THEN "Low Salary"
        WHEN A.income >= 20000  AND A.income <= 50000
        THEN "Average Salary"
        ELSE "High Salary"
    END AS category,
    COUNT(*) AS accounts_count
    FROM Accounts A
    GROUP BY category
) t
ON C.category = t.category;
    
```

---

## ``Subqueries Statement``

### 1978. Employees Whose Manager Left the Company
```bash
SELECT E.employee_id 
FROM Employees E 
WHERE E.salary < 30000 AND E.manager_id NOT IN (
    SELECT employee_id FROM Employees
)
ORDER BY E.employee_id 
```

---



### 626. Exchange Seats
```bash
WITH ranked AS (
  SELECT 
    S1.id,
    S1.student,
    ROW_NUMBER() OVER (ORDER BY S1.id) AS rn,
    COUNT(*) OVER () AS total_count
  FROM Seat S1
)
SELECT 
CASE 
    WHEN (rn = total_count) AND total_count % 2 = 1
    THEN id
    WHEN (id % 2 = 1) 
    THEN id + 1
    WHEN (id % 2 = 0) 
    THEN id - 1
END  AS id, student
FROM ranked
ORDER BY id ASC
```

---



### Movie Rating
```bash
WITH T1 AS (
    SELECT user_id, COUNT(*) AS cnt_rate
    FROM MovieRating
    GROUP BY user_id
),

T2 AS (
    SELECT *
    FROM T1
    WHERE cnt_rate = (SELECT MAX(cnt_rate) FROM T1)
),

T3 AS (SELECT U.name AS results
FROM T2
INNER JOIN Users U ON T2.user_id = U.user_id
ORDER BY U.name ASC
LIMIT 1),

T4 AS (
    SELECT *, SUM(rating) AS rate_sum,COUNT(*) AS mov_cnt,
    ROUND((SUM(rating)/COUNT(*)),2) AS AVG_RES 
    FROM MovieRating
    WHERE created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY movie_id
),

T5 AS (
    SELECT movie_id 
    FROM T4
    WHERE AVG_RES = (SELECT MAX(AVG_RES) FROM T4)
    ),

T6 AS (
    SELECT M.title AS results
    FROM T5
    INNER JOIN Movies M
    WHERE T5.movie_id = M.movie_id
    ORDER BY M.title ASC 
    LIMIT 1
    )

SELECT * FROM T3
UNION ALL
SELECT * FROM T6

```

---



### 1321. Restaurant Growth

```bash
WITH T1 AS (SELECT C.customer_id, 
    C.name,
    visited_on,
    SUM(C.amount) AS amount
FROM Customer C
GROUP BY C.visited_on),
T2 AS (SELECT visited_on, SUM(amount) OVER (
    ORDER BY visited_on
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
) AS amount FROM T1),
T3 AS (SELECT * , ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
FROM T2)
SELECT visited_on,amount, ROUND((amount/7),2) AS average_amount
FROM T3 WHERE rn >= 7


```

---



### 602. Friend Requests II: Who Has the Most Friends
```bash
WITH UN AS (SELECT R.requester_id, COUNT(R.requester_id) AS CNT
FROM RequestAccepted R
GROUP BY R.requester_id 
UNION ALL
SELECT R.accepter_id, COUNT(R.accepter_id)
FROM RequestAccepted R
GROUP BY R.accepter_id )
SELECT requester_id AS id, SUM(CNT) AS num
FROM UN
GROUP BY requester_id
HAVING SUM(CNT) = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(CNT) AS total
        FROM UN
        GROUP BY requester_id
    ) t
);
```

---



### 585. Investments in 2016
```bash
SELECT ROUND(SUM(T1.tiv_2016),2) AS tiv_2016
FROM Insurance T1
WHERE T1.tiv_2015 in (
    SELECT tiv_2015 
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
) and (T1.lat, T1.lon) in (
    SELECT lat,lon 
    FROM Insurance
    GROUP BY lat,lon
    HAVING COUNT(*) = 1
)

```

---



### Department Top Three Salaries
```
SELECT D.name AS Department,
    E.name AS Employee,
    E.salary AS Salary
FROM Employee E
INNER JOIN Department D
ON E.departmentId = D.id
WHERE 3 > (
    SELECT COUNT(DISTINCT salary) 
    FROM Employee 
    WHERE salary > E.salary
    AND departmentId = E.departmentId
)
```

---


## ``Advanced String Functions / Regex / Clause``



### 1667. Fix Names in a Table
```bash
SELECT U.user_id, 
CONCAT(UPPER(SUBSTRING(U.name,1,1)),LOWER(SUBSTRING(U.name,2))) AS name
FROM Users U 
ORDER BY U.user_id;

```

---



### 1527. Patients With a Condition
```bash
SELECT *
FROM Patients
WHERE conditions LIKE '% DIAB1%' OR conditions LIKE 'DIAB1%'; 
```

---



### 196. Delete Duplicate Emails
```bash
DELETE P1
FROM Person P1
JOIN Person P2
  ON P1.email = P2.email
 AND P1.id > P2.id;

```

---



### 176. Second Highest Salary
```bash
SELECT 
    CASE
        WHEN COUNT(*) < 2 THEN NULL
        ELSE
            ( SELECT DISTINCT salary  FROM Employee 
            ORDER BY salary DESC 
            LIMIT 1 
            OFFSET 1 )
        END AS SecondHighestSalary
FROM Employee;
```

---



### 1484. Group Sold Products By The Date
```bash
SELECT  sell_date,
COUNT(DISTINCT product) AS num_sold,
GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') AS products
FROM Activities
GROUP BY sell_date
```

---



### 1327. List the Products Ordered in a Period
```bash
SELECT P.product_name AS product_name , SUM(O.unit) AS unit
FROM Products P
INNER JOIN Orders O
ON P.product_id = O.product_id
WHERE O.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY P.product_name
HAVING SUM(O.unit) >= 100;
```

---



### 1517. Find Users With Valid E-Mails
```bash
SELECT U.*
FROM Users U
WHERE (CHAR_LENGTH(U.mail) - CHAR_LENGTH(REPLACE(U.mail,'@',''))) = 1 AND
    SUBSTRING_INDEX(U.mail,'@',-1) = BINARY 'leetcode.com' AND
    LEFT(SUBSTRING_INDEX(U.mail,'@',1), 1) REGEXP '^[A-Za-z]$' AND
    SUBSTRING_INDEX(U.mail, '@', 1) REGEXP '^[A-Za-z0-9._-]+$'
```

