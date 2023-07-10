drop table entries;
drop table transfers;
drop table accounts;


CREATE TABLE `accounts` (
                           `id` bigint PRIMARY KEY auto_increment,
                           `owner` varchar(255) NOT NULL,
                           `balance` bigint NOT NULL,
                           `currency` varchar(255) NOT NULL,
                           `created_at` timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE `entries` (
                           `id` bigint PRIMARY KEY auto_increment,
                           `account_id` bigint NOT NULL,
                           `amount` bigint NOT NULL COMMENT 'can be negative or positive',
                           `created_at` timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE `transfers` (
                             `id` bigint PRIMARY KEY auto_increment,
                             `from_account_id` bigint NOT NULL,
                             `to_account_id` bigint NOT NULL,
                             `amount` bigint NOT NULL COMMENT 'only can be positive',
                             `created_at` timestamp NOT NULL DEFAULT (now())
);

CREATE INDEX `account_index_0` ON `accounts` (`owner`);

CREATE INDEX `entries_index_1` ON `entries` (`account_id`);

CREATE INDEX `transfers_index_2` ON `transfers` (`from_account_id`);

CREATE INDEX `transfers_index_3` ON `transfers` (`to_account_id`);

CREATE INDEX `transfers_index_4` ON `transfers` (`from_account_id`, `to_account_id`);

ALTER TABLE `entries` ADD FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`);

ALTER TABLE `transfers` ADD FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`id`);

ALTER TABLE `transfers` ADD FOREIGN KEY (`to_account_id`) REFERENCES `accounts` (`id`);


-- init
insert into accounts ( owner, balance, currency)values ('one',100,'USD');
insert into accounts ( owner, balance, currency)values ('two',100,'USD');
insert into accounts ( owner, balance, currency)values ('three',100,'USD');

-- 事务1
begin;
select * from accounts;
select * from accounts where id = 1;
update accounts set balance = balance - 10 where id = 1;
select * from accounts where id = 1;
-- 事务2
select * from accounts where id = 1;

select * from accounts where id = 1;






