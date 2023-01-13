-- #31 (*)
-- For ship classes with a gun caliber of 16 in. or more, display the class and the country.
select class, country
from classes
where bore >= 16;


-- #32 (***)
-- One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw).
-- Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.
select shh.country, CONVERT(NUMERIC(6,2), avg(POWER(shh.bore, 3) / 2)) mw
from (
	select cl.country, cl.class, sh.name, bore
	from ships sh
	join classes cl on cl.class = sh.class
	union
	select cl.country, cl.class, ot.ship, bore
	from outcomes ot
	join classes cl on cl.class = ot.ship
) as shh
group by shh.country;


-- #33 (*)
-- Get the ships sunk in the North Atlantic battle.
-- Result set: ship.
select ship
from outcomes
where battle = 'North Atlantic'
and result = 'sunk';


-- #34 (**)
-- In accordance with the Washington Naval Treaty concluded in the beginning of 1922,
-- it was prohibited to build battle ships with a displacement of more than 35 thousand tons.
-- Get the ships violating this treaty (only consider ships for which the year of launch is known).
-- List the names of the ships.
select sh.name
from ships sh, classes cl
where
  cl.class = sh.class
  and sh.launched >= 1922
  and cl.displacement > 35000
  and type = 'bb';


-- #35 (**)
-- Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.
-- Result set: model, type.
SELECT model, type
FROM product
WHERE upper(model) not like '%[^A-Z]%'
OR model not like '%[^0-9]%';


-- #36 (**)
-- List the names of lead ships in the database (including the Outcomes table).
select name
from ships
where name = class
union
select o.ship
from outcomes o
join classes c on c.class = o.ship;


-- #37 (**)
-- Find classes for which only one ship exists in the database (including the Outcomes table).
select x.class
from (
	select name, class
	from ships
	union
	select o.ship, sh.class
	from outcomes o
	join ships sh on sh.name = o.ship
	union
	select o.ship, c.class
	from outcomes o
	join classes c on c.class = o.ship
) as x
group by x.class
having count(x.name) = 1;


-- #38 (*)
-- Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’).
select distinct country
from classes
where type = 'bb'
INTERSECT
select distinct country
from classes
where type = 'bc';


-- #39 (**)
-- Find the ships that `survived for future battles`; that is, after being damaged in a battle,
-- they participated in another one, which occurred later.
select distinct o.ship
from battles b
join outcomes o on o.battle = b.name
where
  o.result = 'damaged'
  and exists (
    select *
    from battles bb
    join outcomes oo on oo.battle = bb.name
    where
	  upper(oo.ship) = upper(o.ship)
	  and bb.date > b.date
  );


-- #40 (**)
-- Get the makers who produce only one product type and more than one model. Output: maker, type.
select maker, MIN(type) type
from product
group by maker
having
  count(distinct model) > 1
  and count(distinct type) = 1;
