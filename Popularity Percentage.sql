---------------------------------- Popularity Percentage -----------------------------------------------
/** 

*******WORK IN PROGRESS******

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
-- sum up all the friends for user1  and user2 as total_friends
       -- create 2 cte for each column users1 and users2 
-- find the popularity percentage for each user

**/


select user1,
       count(user2)
from facebook_friends
group by user1;


select user2,
       count(user1)
from facebook_friends
group by user2;


-- creating ctes
with users1_count as(
	select user1,
		   count(user2)
	from facebook_friends
	group by user1);


with users2_count as(
	select user2,
		   count(user1)
	from facebook_friends
	group by user2);


-- join them together
with users1_count as(
	select user1,
		   count(user2)
	from facebook_friends
	group by user1),

	users2_count as(
	select user2,
		   count(user1)
	from facebook_friends
	group by user2)
SELECT *
FROM users1_count u1
full join users2_count u2 on u1.user1 = u2.user2;



with users1 as(
	select *
	from facebook_friends),

	users2 as(
	select *
	from facebook_friends)
SELECT *
FROM users1 u1
full join users2 u2 on u1.user1 = u2.;




with users1 as(
	select user1
	from facebook_friends),

	users2 as(
	select user2
	from facebook_friends)
SELECT *
FROM users1 u1
full join users2 u2 on u1.user1 = u2.user2
