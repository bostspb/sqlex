-- #1 (*)
-- Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
-- Result set: model, speed, hd.
select model, speed, hd
from PC
where price < 500;


-- #2 (*)
-- List all printer makers. Result set: maker.
select distinct maker
from Product
where type = 'Printer';


-- #3 (*)
-- Find the model number, RAM and screen size of the laptops with prices over $1000.
select model, ram, screen
from Laptop
where price > 1000;


-- #4 (*)
-- Find all records from the Printer table containing data about color printers.
select * 
from Printer
where color = 'y';


-- #5 (*)
select model, speed, hd
from PC
where 
	price < 600 
	and (cd = '12x' or cd = '24x');
	
	
-- #6 (**)
-- For each maker producing laptops with a hard drive capacity of 10 Gb or higher, 
-- find the speed of such laptops. Result set: maker, speed.
select distinct p.maker, lp.speed
from Product p
inner join Laptop lp on lp.model = p.model
where lp.hd >= 10;


-- #7 (**)
-- Get the models and prices for all commercially available products (of any type) produced by maker B.
select p.model, pc.price
from PC pc left join Product p on pc.model = p.model
where p.maker = 'B'

union

select p.model, lp.price
from Laptop lp left join Product p on lp.model = p.model
where p.maker = 'B'

union

select p.model, pr.price
from Printer pr left join Product p on pr.model = p.model
where p.maker = 'B';


-- #8 (**)
-- Find the makers producing PCs but not laptops.
select maker
from Product
where type = 'PC'

except

select maker
from Product
where type = 'Laptop';


-- #9 (*)
-- Find the makers of PCs with a processor speed of 450 MHz or more. 
-- Result set: maker.
select distinct(p.maker)
from Product p
left join PC pc on pc.model = p.model
where pc.speed >= 450;


-- #10 (*)
-- Find the printer models having the highest price. Result set: model, price.
select model, price
from Printer
where price in (
	select max(price) from Printer
);
