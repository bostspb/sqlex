-- #51 (***)
-- Find the names of the ships with the largest number of guns among all ships having
-- the same displacement (including ships in the Outcomes table).
with res as (
	select
	  oc.ship name,
	  cl.class,
	  cl.numguns,
	  cl.displacement
	from outcomes oc
	inner join classes cl on cl.class = oc.ship

	union

	select
	  sh.name name,
	  cl.class,
	  cl.numguns,
	  cl.displacement
	from ships sh
	inner join classes cl on cl.class = sh.class
)
select name from res
where res.numguns = (select max(scl.numguns)
   from res scl
   where
     scl.displacement = res.displacement
	 and scl.class in (select distinct r.class from res r)
);


-- #52 (**)
-- Determine the names of all ships in the Ships table that can be a Japanese battleship having
-- at least nine main guns with a caliber of less than 19 inches and a displacement of not more than 65 000 tons.
select sh.name
from ships sh
left join classes cl on cl.class = sh.class
where
  cl.type = 'bb'
  and cl.country = 'Japan'
  and ((cl.bore < 19) or (cl.bore is null))
  and ((cl.numguns >= 9) or (cl.numguns is null))
  and ((cl.displacement <= 65000) or (cl.displacement is null));


-- #53 (**)
-- With a precision of two decimal places, determine the average number of guns for the battleship classes.
select
  cast(avg(
    cast(numguns as numeric(6,2))
  ) as numeric(6,2))
from classes
where type = 'bb';


-- #54 (**)
-- With a precision of two decimal places, determine the average number of guns
-- for all battleships (including the ones in the Outcomes table).
select
  cast(avg(
    cast(res.numguns as numeric(6,2))
  ) as numeric(6,2))
from (
  select sh.name, cl1.numguns, cl1.type
  from ships sh
  left join classes cl1 on cl1.class = sh.class

  union

  select oc.ship, cl2.numguns, cl2.type
  from outcomes oc
  inner join classes cl2 on cl2.class = oc.ship
) res
where res.type = 'bb';


-- #55 (**)
-- For each class, determine the year the first ship of this class was launched.
-- If the lead ship’s year of launch is not known, get the minimum year of launch for the ships of this class.
-- Result set: class, year.
select cl.class, min(sh.launched) year
from ships sh
right join classes cl on cl.class = sh.class
group by cl.class;


-- #56 (**)
-- For each class, find out the number of ships of this class that were sunk in battles.
-- Result set: class, number of ships sunk.
with x as (
  select s.class, count(s.class) sunks_count
  from (
	select oc.ship, cl.class
	from outcomes oc
	inner join classes cl on cl.class = oc.ship
	where oc.result = 'sunk'

	union

	select sh.name, sh.class
	from outcomes oc
	inner join ships sh on sh.name = oc.ship
	where oc.result = 'sunk'
  ) s
  group by s.class
)
select
  cl.class,
  COALESCE(x.sunks_count, 0) sunks_count
from classes cl
left join x on x.class = cl.class;


-- #57 (***)
-- For classes having irreparable combat losses and at least three ships in the database,
-- display the name of the class and the number of ships sunk.
with sunk as (
  select s.class, count(s.ship) ships_cnt
  from (
    select oc.ship, cl.class, oc.result
    from outcomes oc
    inner join classes cl on cl.class = oc.ship
    where oc.result = 'sunk'
    union
    select sh.name ship, sh.class, oc.result
    from outcomes oc
    inner join ships sh on sh.name = oc.ship
  ) s
  where s.result = 'sunk'
  group by s.class
),
classes_with_ships_count as (
  select sbc.class
  from (
    select oc.ship, cl.class
    from outcomes oc
    inner join classes cl on cl.class = oc.ship
    union
    select name as ship, class
    from ships
  ) sbc
  group by sbc.class
  having count(ship) >= 3
)
select sunk.class, sunk.ships_cnt
from sunk
where sunk.class in (select class from classes_with_ships_count);


-- #58 (***)
-- For each product type and maker in the Product table, find out, with a precision of two decimal places,
-- the percentage ratio of the number of models of the actual type produced by the actual maker
-- to the total number of models by this maker.
-- Result set: maker, product type, the percentage ratio mentioned above.
with types as (
  select distinct type
  from product
),
makers as (
  select distinct maker
  from product
),
all_makers_types as (
  select *
  from makers, types
),
maker_models as (
  select maker, count(model) models_cnt
  from product
  group by maker
),
maker_type_models as (
  select maker, type, count(model) models_cnt
  from product
  group by maker, type
)
select
  amt.maker,
  amt.type,
  cast(
    (cast(coalesce(mtm.models_cnt, 0) as dec(12, 4)) / mm.models_cnt) * 100
	as numeric(6, 2)
  ) ratio
from all_makers_types amt
left join maker_type_models mtm on mtm.maker = amt.maker and mtm.type = amt.type
left join maker_models mm on mm.maker = amt.maker
order by amt.maker, amt.type;


-- #59 (**)
-- Calculate the cash balance of each buy-back center for the database with money transactions being recorded not more than once a day.
-- Result set: point, balance.
with inc as (
  select point, sum(inc) inc_sum
  from income_o
  group by point
),
out as (
  select point, sum(out) out_sum
  from outcome_o
  group by point
)
select inc.point, (coalesce(inc.inc_sum, 0) - coalesce(out.out_sum, 0)) balance
from inc
full join out on inc.point = out.point;


-- #60 (**)
-- For the database with money transactions being recorded not more than once a day,
-- calculate the cash balance of each buy-back center at the beginning of 4/15/2001.
-- Note: exclude centers not having any records before the specified date.
-- Result set: point, balance
with inc as (
  select point, sum(inc) inc_sum
  from Income_o
  where date < '2001-04-15 00:00:00'
  group by point
),
out as (
  select point, sum(out) out_sum
  from Outcome_o
  where date < '2001-04-15 00:00:00'
  group by point
)
select inc.point, (coalesce(inc.inc_sum, 0) - coalesce(out.out_sum, 0)) balance
from inc
full join out on inc.point = out.point