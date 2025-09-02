SELECT name, population, area 
FROM World AS w
WHERE w.area >= 3000000 || w.population >= 25000000;