-- #11 (*)
-- Find out the average speed of PCs.
select avg(speed)
from PC;


-- #12 (*)
-- Find out the average speed of the laptops priced over $1000.
select avg(speed)
from Laptop
where price > 1000;


-- #13 (*)
-- Find out the average speed of the PCs produced by maker A.
select avg(lp.speed)
from PC lp
inner join Product p on p.model = lp.model
where p.maker = 'A';


-- #14 (**)
-- For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
select sh.class, sh.name, cl.country
from Ships sh
left join Classes cl on cl.class = sh.class
where cl.numGuns >= 10;


-- #15 (**)
-- Get hard drive capacities that are identical for two or more PCs.
-- Result set: hd.
select hd
from PC
group by hd
having count(hd) >= 2;


-- #16 (**)
-- Get pairs of PC models with identical speeds and the same RAM capacity.
-- Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
-- Result set: model with the bigger number, model with the smaller number, speed, and RAM.
SELECT DISTINCT pc1.model model1, pc2.model model2, pc1.speed, pc2.ram
FROM PC pc1, PC pc2
WHERE
  pc1.speed= pc2.speed and
  pc1.ram = pc2.ram and
  pc1.model > pc2.model;


-- #17 (**)
-- Get the laptop models that have a speed smaller than the speed of any PC.
-- Result set: type, model, speed.
select distinct 'Laptop' type, model, speed
from Laptop
where speed < (select min(speed) from PC);


-- #18 (**)
-- Find the makers of the cheapest color printers.
-- Result set: maker, price.
select distinct p.maker, pr.price
from Printer pr
left join Product p on p.model = pr.model
where
  pr.price = (select min(price) from Printer where color = 'y')
  and pr.color = 'y';


-- #19 (*)
-- For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
-- Result set: maker, average screen size.
select p.maker, avg(lp.screen)
from Laptop lp
left join Product p on p.model = lp.model
group by p.maker;


-- #20 (**)
-- Find the makers producing at least three distinct models of PCs.
-- Result set: maker, number of PC models.
select maker, count(*)
from Product
group by maker, type
having count(*) >= 3 and type = 'PC';
