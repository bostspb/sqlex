-- #61 (**)
-- For the database with money transactions being recorded not more than once a day,
-- calculate the total cash balance of all buy-back centers.
with inc as (
  select sum(inc) inc_sum
  from Income_o
),
out as (
  select sum(out) out_sum
  from Outcome_o
)
select (coalesce(inc.inc_sum, 0) - coalesce(out.out_sum, 0)) balance
from inc
join out on 1=1;


-- #62 (*)
-- For the database with money transactions being recorded not more than once a day,
-- calculate the total cash balance of all buy-back centers at the beginning of 04/15/2001.
with inc as (
  select sum(inc) inc_sum
  from Income_o
  where date < '2001-04-15 00:00:00'
),
out as (
  select sum(out) out_sum
  from Outcome_o
  where date < '2001-04-15 00:00:00'
)
select (COALESCE(inc.inc_sum, 0) - COALESCE(out.out_sum, 0)) balance
from inc
full join out on 1=1;


-- #63 (**)
-- Find the names of different passengers that ever travelled more than once occupying seats with the same number.
select name
from passenger
where id_psg in (
  select id_psg
  from pass_in_trip
  group by id_psg, place
  having count(1) > 1
);


-- #64 (**)
--

-- #65 (**)
--

-- #66 (**)
--

-- #67 (**)
--

-- #68 (**)
--

-- #69 (**)
--

-- #70 (**)
--

