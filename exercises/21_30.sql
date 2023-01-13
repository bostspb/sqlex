-- #21 (*)
-- Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.
select p.maker, max(pc.price)
from PC pc
left join Product p on p.model = pc.model
group by p.maker;


-- #22 (*)
-- For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
-- Result set: speed, average price.
select speed, avg(price)
from pc
group by speed
having speed > 600;


-- #23 (**)
-- Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
-- Result set: maker
select distinct p.maker
from PC pc
left join Product p on p.model = pc.model
where pc.speed >= 750
  INTERSECT
select distinct p.maker
from Laptop lp
left join Product p on p.model = lp.model
where lp.speed >= 750;


-- #24 (**)
-- List the models of any type having the highest price of all products present in the database.
with all_products as (
	select pc.model, pc.price
	from PC pc
	union
	select lp.model, lp.price
	from Laptop lp
	union
	select pr.model, pr.price
	from Printer pr
)
select ap.model
from all_products ap
where ap.price = (select max(price) from all_products);


-- #25 (**)
-- Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
-- Result set: maker.
select distinct maker
from product
where type = 'printer'
	and maker in (
		select distinct maker
		from pc
		left join product p on p.model = pc.model
		where ram = (select min(ram) from pc)
		and speed = (
			select max(speed)
			from pc
			where ram = (select min(ram) from pc)
		)
	);


-- #26 (**)
-- Find out the average price of PCs and laptops produced by maker A.
-- Result set: one overall average price for all items.
select avg(price)
from (
  select p.model, pc.price, p.type, pc.code
  from pc
  inner join product p on p.model = pc.model
  where p.maker = 'A'
  union
  select p.model, lp.price, p.type, lp.code
  from laptop lp
  inner join product p on p.model = lp.model
  where p.maker = 'A'
) as a;


-- #27 (**)
-- Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
-- Result set: maker, average HDD capacity.
select p.maker, avg(hd)
from pc
left join product p on p.model = pc.model
group by p.maker
having p.maker in (
  select maker
  from product
  where type = 'printer'
);


-- #28 (**)
-- Using Product table, find out the number of makers who produce only one model.
select count(maker) cnt
from (
  select maker
  from product
  group by maker
  having count(model) = 1
) aaa;


-- #29 (**)
-- Under the assumption that receipts of money (inc) and payouts (out) are registered not more than
-- once a day for each collection point [i.e. the primary key consists of (point, date)],
-- write a query displaying cash flow data (point, date, income, expense).
-- Use Income_o and Outcome_o tables.
select
	case when o.point is null then i.point else o.point end point,
	case when o.date is null then i.date else o.date end date,
	i.inc,
	o.out
from outcome_o o
full join income_o i on i.point = o.point and i.date = o.date;


-- #30 (**)
-- Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of
-- times a day for each collection point [i.e. the code column is the primary key],
-- display a table with one corresponding row for each operating date of each collection point.
-- Result set: point, date, total payout per day (out), total money intake per day (inc).
-- Missing values are considered to be NULL.
with inc_table as (
  select point, date, sum(inc) inc
  from income
  group by point, date
),
out_table as (
  select point, date, sum(out) out
  from outcome
  group by point, date
)
select
  case when o.point is null then i.point else o.point end point,
  case when o.date is null then i.date else o.date end date,
  o.out,
  i.inc
from inc_table i
full join out_table o on o.point = i.point and o.date = i.date;
