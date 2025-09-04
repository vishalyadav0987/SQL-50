# Write your MySQL query statement below
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