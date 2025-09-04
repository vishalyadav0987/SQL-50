# Write your MySQL query statement below
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
