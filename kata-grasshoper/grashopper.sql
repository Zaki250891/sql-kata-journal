SELECT
    position, 
    roll, 
    (position + roll * 2) AS res
FROM moves;