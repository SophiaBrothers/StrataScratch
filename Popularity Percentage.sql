---------------------------------- Popularity Percentage -----------------------------------------------
/** 


see: https://platform.stratascratch.com/coding/10284-popularity-percentage?python=

Popularity Percentage

Find the popularity percentage for each user on Facebook. The popularity percentage is defined as the total number
of friends the user has divided by the total number of users on the platform, then converted into a percentage
by multiplying by 100.

Output each user along with their popularity percentage. Order records in ascending order by user id.

The 'user1' and 'user2' column are pairs of friends.

Table: facebook_friends

columns needed:  user1,  


-- Approach
-- create two subqueires to list the pairs seperately
-- combine these queires into one table using Union all
-- count the total friends for each user 
-- find the popularity percentage for each user

**/

--getting a count from each column

select user1,
       count(user2)
from facebook_friends
group by user1;


select user2,
       count(user1)
from facebook_friends
group by user2;


-- this would be inaccurate as users can be present in user1 and user2 with a different pairing
-- need a single table to represent the users as both user1 and user2 and thier pair

-- join them together with UNION ALL
select user1, user2 from facebook_friends      
union all                                   --to stack the tables to create a single table of pairs
select user2, user1 from facebook_friends   --SWTICH ORDER SO THAT EVERY PAIR IS DISPLAYED IN THE SINGLE TABLE


-- CREATE A CTE
with pair_list as(
	              select user1, user2 from facebook_friends
				  union all
	              select user2, user1 from facebook_friends)

--now we have a single table of all pairs



-- NOW LETS GET A COUNT OF EACH USER'S FRIENDS
with pair_list as(
	              select user1, user2 from facebook_friends
				  union all
	              select user2, user1 from facebook_friends)
SELECT user1,                                                   -- since all users from both columns are now under user1
       count(distinct user2) as total_friends
FROM pair_list
GROUP BY user1

--------------------------------------------- FINAL SOLUTION------------------------------------------------------------

--GET THEIR POPULARITY PERCENTAGE
with pair_list as(
	              select user1, user2 from facebook_friends
				  union all
	              select user2, user1 from facebook_friends)
SELECT user1,                                                   
       count(distinct user2) as total_friends,
	   cast( count(distinct user2) * 100. / (select count(distinct user1) from pair_list) as FLOAT) as popularity_pctg
FROM pair_list
GROUP BY user1
ORDER BY user1 ASC




----------------------------------------- SIDE NOTES ------------------------------------------------------------------

-- ***MAKE SURE TO SPECIFY THAT THE DENOMINTOR IS SELECTED FROM THE CTE***
-- if you do not it will just divide by the distinct user1 listed in the output which would is 1
with pair_list as(
	              select user1, user2 from facebook_friends
				  union all
	              select user2, user1 from facebook_friends)
SELECT user1,                                                   
       count(distinct user2) as total_friends,
	   count(distinct user1)  -- testing without select from . count is 1
FROM pair_list
GROUP BY user1
ORDER BY user1 ASC


--now try it with select from
with pair_list as(
	              select user1, user2 from facebook_friends
				  union all
	              select user2, user1 from facebook_friends)
SELECT user1,                                                   
       count(distinct user2) as total_friends,
	   (select count(distinct user1) from pair_list) as c    --count is 9   
FROM pair_list
GROUP BY user1
ORDER BY user1 ASC

--***THERE IS A DIFFERENCE TO BE NOTED!!!!



--OTHER SIDE WORK
--works the same
select 50/9 * 100
select (50/9) * 100

select cast(50 as float) / cast(9 as float) * 100. 


ROUND(CAST((Numerator * 100.0 / Denominator) AS FLOAT), 2) AS Percentage

--SIMPLY MULTIPLYING BY 100 WILL GIVES A WHOLE NUMBER PERCENTAGE.  ADD DECIMAL POINT (100.) TO GET TRAILING NUMBERS LIKE 55.221
-- YOU CAN USE ROUND TO ROUND THE TRAILING NUMBERS