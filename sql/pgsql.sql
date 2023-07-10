insert into accounts ( owner, balance, currency) values ('foo',100,'USD');
insert into accounts ( owner, balance, currency) values ('bar',100,'USD');





-- 测试 insert 和select 造成的死锁
begin;
-- 创建转账记录
insert into transfers (from_account_id, to_account_id, amount) values (1,2,10) returning *;
-- foo 向 bar 的转账记录
insert into entries (account_id, amount) VALUES (1,-10) returning *;
-- bar向 foo 的收款记录
insert into entries (account_id, amount) VALUES (2,10) returning *;
-- 更新 foo 的余额
select * from accounts where id = 1 for update;
update accounts set balance= 90 where  id = 1 returning *;
-- 更新 bar 的余额
select * from accounts where id = 2 for update;
update accounts set balance= 110 where  id = 2 returning *;
--  出现问题就回滚
rollback;


SELECT blocked_locks.pid     AS blocked_pid,
       blocked_activity.usename  AS blocked_user,
       blocking_locks.pid     AS blocking_pid,
       blocking_activity.usename AS blocking_user,
       blocked_activity.query    AS blocked_statement,
       blocking_activity.query   AS current_statement_in_blocking_process
FROM  pg_catalog.pg_locks         blocked_locks
          JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid
          JOIN pg_catalog.pg_locks         blocking_locks
               ON blocking_locks.locktype = blocked_locks.locktype
                   AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
                   AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
                   AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
                   AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
                   AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
                   AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
                   AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
                   AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
                   AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
                   AND blocking_locks.pid != blocked_locks.pid

          JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;


SELECT
       a.application_name,
       l.relation::regclass,
       l.transactionid,
       l.mode,
       l.locktype,
       l.GRANTED,
       a.usename,
       a.query,
       a.pid
FROM pg_stat_activity a
         JOIN pg_locks l ON l.pid = a.pid
WHERE a.application_name = 'psql'
ORDER BY a.pid;


-- 交错执行下面的

-- Tx1: transfer $10 from account 1 to account 2
begin;
update accounts set balance = balance - 10 where id = 1 returning *; -- 1
update accounts set balance = balance + 10 where id = 2 returning *; -- 3

rollback;

-- Tx2: transfer $10 from account 2 to account 1
begin;
update accounts set balance = balance - 10 where id = 2 returning *; -- 2
update accounts set balance = balance + 10 where id = 1 returning *; -- 4

rollback;








