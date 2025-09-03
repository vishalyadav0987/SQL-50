SELECT p.product_name ,s.year AS year , s.price AS price   
FROM Sales s 
INNER JOIN Product AS p
ON p.product_id = s.product_id;