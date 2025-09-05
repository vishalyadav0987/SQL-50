# Write your MySQL query statement below
SELECT U.*
FROM Users U
WHERE (CHAR_LENGTH(U.mail) - CHAR_LENGTH(REPLACE(U.mail,'@',''))) = 1 AND
    SUBSTRING_INDEX(U.mail,'@',-1) = BINARY 'leetcode.com' AND
    LEFT(SUBSTRING_INDEX(U.mail,'@',1), 1) REGEXP '^[A-Za-z]$' AND
    SUBSTRING_INDEX(U.mail, '@', 1) REGEXP '^[A-Za-z0-9._-]+$'