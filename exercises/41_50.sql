-- #41 (**)
-- For each maker who has models at least in one of the tables PC, Laptop, or Printer, determine the maximum price for his products.
-- Output: maker; if there are NULL values among the prices for the products of a given maker, display NULL for this maker, otherwise, the maximum price.
with x as (
	select model, price from pc
	union
	select model, price from printer
	union
	select model, price from laptop
)
select
  prd.maker,
  CASE
    WHEN MAX(CASE WHEN x.price IS NULL THEN 1 ELSE 0 END) = 0
    THEN MAX(x.price) END
from product prd
right join x on x.model = prd.model
group by prd.maker;


-- #42 (*)
-- Find the names of ships sunk at battles, along with the names of the corresponding battles.
select ship, battle
from outcomes
where result = 'sunk';


-- #43 (**)
-- Get the battles that occurred in years when no ships were launched into water.
select name
from battles
where year(date) not in (
  select distinct launched
  from ships
  where launched is not null
);


-- #44 (*)
-- Find all ship names beginning with the letter R.
with x as (
  select name
  from ships
  union
  select ship
  from outcomes
)
select name
from x
where name like 'R%';


-- #45 (*)
-- Find all ship names consisting of three or more words (e.g., King George V).
-- Consider the words in ship names to be separated by single spaces, and the ship names to have no leading or trailing spaces.
with x as (
  select name
  from ships
  union
  select ship
  from outcomes
)
select name
from x
where name like '% % %';


-- #46 (**)
-- For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns.
select distinct o.ship, cl.displacement, cl.numGuns
from classes cl
left join ships sh on sh.class = cl.class
right join outcomes o on o.ship = sh.name or o.ship = cl.class
where o.battle = 'Guadalcanal';


-- #47 (***)
-- Find the countries that have lost all their ships in battles.
WITH T1 AS (
	SELECT COUNT(name) as co, country
	FROM (
		SELECT name, country
		FROM Classes
		INNER JOIN Ships ON Ships.class = Classes.class
		UNION
		SELECT ship, country
		FROM Classes
		INNER JOIN Outcomes ON Outcomes.ship = Classes.class
	) FR1
	GROUP BY country
),
T2 AS (
	SELECT COUNT(name) as co, country
	FROM (
		SELECT name, country
		FROM Classes
		INNER JOIN Ships ON Ships.class = Classes.class
		WHERE name IN (
			SELECT DISTINCT ship
			FROM Outcomes
			WHERE result = 'sunk'
		)
		UNION
		SELECT ship, country
		FROM Classes
		INNER JOIN Outcomes ON Outcomes.ship = Classes.class
		WHERE Outcomes.result = 'sunk'
	) FR2
	GROUP BY country
)
SELECT T1.country
FROM T1
INNER JOIN T2 ON T1.co = t2.co and t1.country = t2.country;


-- #48 (**)
-- Find the ship classes having at least one ship sunk in battles.
select sh.class
from outcomes oc
inner join ships sh on sh.name = oc.ship
where
  oc.result = 'sunk'

union

select cl.class
from outcomes oc
inner join classes cl on oc.ship = cl.class
where
  oc.result = 'sunk';


-- #49 (*)
-- Find the names of the ships having a gun caliber of 16 inches (including ships in the Outcomes table).
select sh.name
from ships sh
inner join classes cl on cl.class = sh.class
where cl.bore = 16.0

union

select oc.ship
from outcomes oc
inner join classes cl on cl.class = oc.ship
where cl.bore = 16.0;


-- #50 (*)
-- Find the battles in which Kongo-class ships from the Ships table were engaged.
select distinct oc.battle
from ships sh
inner join outcomes oc on sh.name = oc.ship
where
  sh.class = 'Kongo';
