You have been provided with a PostgreSQL table named users. This table includes a jsonb column, info, which holds JSON data. Here is a simplified schema of the table:

id: primary key, integer.
info: JSON column which includes:
name: a string (user's name).
age: an age of the user
pets: an array of JSON objects (each object represents a pet and has a name field and type field).
In this task, you need to identify age groups of pet owners based on their ages. Assume the age groups are as follows: "18-30", "31-45", "46-60", "61 and above". All pet owners are adults (>=18 years) - you can be sure that in the tests all users' ages are within these groups.

For each age group, calculate the average number of pets owned per user (it should be rounded to 1 decimal place), and find the name of the user who owns the most pets in that age group. If there's a tie in the number of pets, choose the user with the smallest ID.

Sort the results by the average number of pets in descending order. If two age groups have the same average number of pets, sort them by age group in ascending order.

The result of your query should be a table with four columns:

age_group: The age group of pet owners.
avg_pet_count: The average number of pets per user in that age group, rounded to 1 decimal place.
max_pet_owner: The name of the user who owns the most pets in that age group.
max_pet_count: The number of pets owned by the user who owns the most pets in that age group.
Good Luck!

Desired Output
The desired output should look like this:

age_group     | avg_pet_count  | max_pet_owner     | max_pet_count
--------------+----------------+-------------------|---------------
 61 and above | 0.76e1         | David Mann DDS    |  10
 31-45        | 0.34e1         | Trey Boyle        |  5

 ***Primer CTE***
 _Normalizar los datos_
 