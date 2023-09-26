create role :uni with login;
alter role :uni password :'pswd' valid until '20250630';
alter role :uni set search_path to mosaic,"$user",public;
-- alter role :uni set search_path to default;
alter role :uni connection limit 3;
grant mosaic_team_member to :uni;

-- to delete account: drop role :uni;