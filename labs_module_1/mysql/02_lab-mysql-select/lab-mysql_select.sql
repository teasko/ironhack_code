use publications;



show tables;


/*
since it first loads from, and then the inner parts before select, you really have to use the abbriviations (a, t, ta) you introduced 
*/

-- challenge 1
select 
	a.au_id as 'Author ID',
	a.au_lname as 'LAST NAME',
    a.au_fname as 'FIRST NAME',
    t.title as 'TITLE',
    p.pub_name as 'PUBLISHER'
from authors a
inner join titleauthor ta on a.au_id = ta.au_id
inner join titles t on ta.title_id = t.title_id
inner join publishers p on t.pub_id = p.pub_id
limit 100;


-- challenge 2
select 
	a.au_id as 'AUTHOR ID',
	a.au_lname as 'LAST NAME',
    a.au_fname as 'FIRST NAME',
    p.pub_name as 'PUBLISHER',
    count(t.title_id) as 'TITLE COUNT'
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on ta.title_id=t.title_id
inner join publishers p on t.pub_id=p.pub_id
group by a.au_id, p.pub_id
order by count(t.title_id) desc;


-- challenge 3
select 
	title_id,
	qty
from sales;




select
	a.au_id as 'AUTHOR ID',
	a.au_lname as 'LAST NAME',
    a.au_fname as 'FIRST NAME',
    -- sum(s.qty) as 'quantaty' -- ,
    sum(s.qty) as 'TOTAL'
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join sales s on ta.title_id=s.title_id
group by a.au_id
order by sum(s.qty) desc;

-- challenge 4
select
	a.au_id as 'AUTHOR ID',
	a.au_lname as 'LAST NAME',
    a.au_fname as 'FIRST NAME',
    COALESCE(sum(s.qty), 0) as 'TOTAL'
from authors a
left join titleauthor ta on a.au_id=ta.au_id   	-- left join also contains those authors, who are not in titleauthor (have not title pubished)
left join sales s on ta.title_id=s.title_id		-- left join also contains those titles, that are not sold, i.e. not in sales
group by a.au_id
order by sum(s.qty) asc;







-- bonus challenge

-- solution 1 (with temporary table), if ram is full, uses harddrive storage
create temporary table helptable 
select 
    t.advance as advance,
    t.royalty as royalty,
    a.au_id as au_id,
    a.au_lname as au_lname,
    a.au_fname as au_fname,
    (t.price*s.qty*t.royalty)/(100*ta.royaltyper) as royalties 
from titles as t
inner join sales s on s.title_id=t.title_id
inner join titleauthor ta on ta.title_id = s.title_id
inner join authors a on a.au_id = ta.au_id;

select 
	au_id,
    au_lname,
    au_fname,
    cast(sum(advance + royalties) as unsigned) as profits
from helptable
group by au_id, au_lname, au_fname
limit 3;





-- Common Table expressions   ---  does not work in my mysql version

/*
with helptable as (
	select 
		t.advance as advance,
		t.royalty as royalty,
		a.au_id as au_id,
		a.au_lname as au_lname,
		a.au_fname as au_fname,
		(t.price*s.qty*t.royalty)/(100*ta.royaltyper) as royalties 
	from titles as t
		inner join sales s on s.title_id=t.title_id
		inner join titleauthor ta on ta.title_id = s.title_id
		inner join authors a on a.au_id = ta.au_id
)
select 
	au_id,
    au_lname,
    au_fname,
    cast(sum(advance + royalties) as unsigned) as profits
from helptable
group by au_id, au_lname, au_fname
limit 3;
*/




 -- solution 3 (nested selects)
select 
	au_id,
    au_lname,
    au_fname,
    cast(sum(advance + royalties) as unsigned) as profits
from 
(
	select 
		t.advance as advance,
		t.royalty as royalty,
		a.au_id as au_id,
		a.au_lname as au_lname,
		a.au_fname as au_fname,
		(t.price*s.qty*t.royalty*royaltyper)/100000 as royalties 
	from titles as t
	inner join sales s on s.title_id=t.title_id
	inner join titleauthor ta on ta.title_id = s.title_id
	inner join authors a on a.au_id = ta.au_id
) as helptable
group by au_id, au_lname, au_fname
limit 3;




