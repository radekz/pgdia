drop database if exists pgdia;
drop user     if exists pgdia;

create user pgdia password 'pgdia';
create database pgdia owner=pgdia encoding='utf8';

\c pgdia pgdia

begin;

-- an example trigger
create language plpgsql;
create or replace function update_post_timestamp() returns trigger as $$
begin
	new.updated := now();
	return new;
end;
$$ language plpgsql;

-- create the tables
\i pgdia.sql

-- enable the trigger;
-- you'll have to do it in a "small package" if you want
-- inserts from the "components" to be affected by it
create trigger t_update_post_timestamp before update on posts
	execute procedure update_post_timestamp();

commit;

