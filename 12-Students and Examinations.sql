# Write your MySQL query statement below
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

