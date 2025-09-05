SELECT U.user_id, 
CONCAT(UPPER(SUBSTRING(U.name,1,1)),LOWER(SUBSTRING(U.name,2))) AS name
FROM Users U 
ORDER BY U.user_id;