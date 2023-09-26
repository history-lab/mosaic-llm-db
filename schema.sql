create schema mosaic;
create view mosaic.docs as select * from foiarchive.docs;

create role mosaic_team_member;
grant usage on schema mosaic to mosaic_team_member;
grant select on mosaic.docs to mosaic_team_member;