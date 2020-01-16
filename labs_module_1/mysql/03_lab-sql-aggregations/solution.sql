use bank;


-- 1
SELECT
	c.district_id,
    sum(1)
FROM client c
WHERE c.district_id < 10
GROUP BY c.district_id
ORDER BY c.district_id;

-- 2
SELECT 
	c.type,
    sum(1)
FROM card c
GROUP BY c.type
ORDER BY sum(1) desc;

-- 3
SELECT
	l.account_id,
    sum(l.amount) as amount
FROM loan l
GROUP BY l.account_id
ORDER BY sum(l.amount) desc
LIMIT 10;

-- 4
SELECT 
	l.date,
    sum(1)
FROM loan l
WHERE l.date < 930907
GROUP BY l.date
ORDER BY l.date desc;

-- 5
SELECT
	l.date,
    l.duration,
    sum(1) AS num_loans
FROM loan l
WHERE l.date LIKE '9712%'
GROUP BY 
	l.date,
    l.duration
ORDER BY 
	l.date,
    l.duration;
    
-- 6
SELECT 
	t.account_id,
    t.type,
    cast(sum(t.amount) AS UNSIGNED) as total_amount
FROM trans t
WHERE t.account_id = 396
GROUP BY 
	t.account_id,
    t.type
ORDER BY t.type;

-- 7
CREATE TEMPORARY TABLE chall7_temp(
	SELECT 
		t.account_id,
		t.type,
		cast(sum(t.amount) AS UNSIGNED) as total_amount
	FROM trans t
	WHERE t.account_id = 396
	GROUP BY 
		t.account_id,
		t.type
	ORDER BY t.type
);

SELECT 
	c.account_id,
    IF(c.type = 'PRIJEM','INCOMING','OUTGOING') AS type,
    c.total_amount
FROM chall7_temp as c;


-- shorter solution
SELECT 
    account_id,
    FLOOR(SUM(IF(type = 'PRIJEM', amount, 0))) - FLOOR(SUM(IF(type = 'VYDAJ', amount, 0))) AS difference
FROM trans
WHERE account_id = 396
GROUP BY 1;



-- 8
CREATE TEMPORARY TABLE chall8_temp(
	SELECT 
		c.account_id,
		IF(c.type = 'PRIJEM',c.total_amount,0) AS INCOMING,
		IF(c.type = 'PRIJEM',0, c.total_amount) AS OUTGOING
	FROM chall7_temp as c
);
 
SELECT 
	c.account_id,
    sum(c.INCOMING) AS INCOMING,
    SUM(c.OUTGOING) AS OUTGOING,
    SUM(c.INCOMING-c.OUTGOING) AS DIFFERENCE
FROM chall8_temp as c
GROUP BY c.account_id;

-- 9

DROP TABLE IF EXISTS incoming_temp;

CREATE TEMPORARY TABLE incoming_temp(
	SELECT 
		t.account_id,
		cast(sum(t.amount) AS SIGNED) as total_amount
	FROM trans t
    where t.type = 'PRIJEM'
	GROUP BY 
		t.account_id
);

DROP TABLE IF EXISTS outgoing_temp;
CREATE TEMPORARY TABLE outgoing_temp(
	SELECT 
		t.account_id,
		cast(sum(t.amount) AS SIGNED) as total_amount
	FROM trans t
    where t.type = 'VYDAJ'
	GROUP BY 
		t.account_id
);


select 
	it.account_id,
    (it.total_amount - ot.total_amount) AS Difference
from incoming_temp it
	LEFT JOIN outgoing_temp ot 
		ON it.account_id = ot.account_id
-- WHERE it.account_id = 396
ORDER BY Difference DESC
LIMIT 10; 


-- shorter solution
SELECT 
    account_id,
    FLOOR(SUM(IF(type = 'PRIJEM', amount, 0))) - FLOOR(SUM(IF(type = 'VYDAJ', amount, 0))) AS difference
FROM trans
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;