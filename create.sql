drop database if exists pgdia;
drop user     if exists pgdia;

create user pgdia password 'pgdia';
create database pgdia owner=pgdia encoding='utf8';

\c pgdia pgdia

begin;

\i pgdia.sql

-- an example trigger
create language plpgsql;
create or replace function update_post_timestamp() returns trigger as $$
begin
	new.updated := now();
	return new;
end;
$$ language plpgsql;
create trigger t_update_post_timestamp before update on posts execute procedure update_post_timestamp();

-- fast searching for posts with a specific tag(s)
create index i_posts_tags on posts using gin(tags);

commit;

