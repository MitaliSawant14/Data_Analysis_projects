create schema Spotify;

use spotify;

SELECT * FROM spotify.spotify_history;

desc spotify_history;

alter table spotify_history
add column `date` date;

alter table spotify_history
add column `time` time;

#extracting date and time separetely from ts
#str_to_date helps to read the format other than default one
UPDATE spotify_history
SET `date` = STR_TO_DATE(SUBSTRING_INDEX(ts, ' ', 1), '%d-%m-%Y');

UPDATE spotify_history
SET `time` = SUBSTRING_INDEX(ts, ' ', -1);

#converting milliseconds into seconds
alter TABLE spotify_history
add COLUMN sec_played FLOAT;

UPDATE spotify_history
set sec_played = round(ms_played/1000, 2);

#rearranging columns
alter TABLE spotify_history
MODIFY COLUMN sec_played  float after ms_played;

alter TABLE spotify_history
MODIFY COLUMN `time`  time after ts;

alter TABLE spotify_history
MODIFY COLUMN `date`  date after ts;

update spotify_history
set shuffle = case when shuffle = "true" then "Yes" else "No" end;

update spotify_history
set skipped = case when skipped = "true" then "Yes" else "No" end;

start transaction;

update spotify_history
set reason_start = case when reason_start = "unknown" then null else reason_start end;

SAVEPOINT unknown_null;

rollback to unknown_null;

update spotify_history
set reason_end = case when reason_end = "unknown" then null else reason_end end;

SAVEPOINT reason_end_unknown_null;

update spotify_history
set ms_played = case when ms_played = 0 then null else ms_played end;

SAVEPOINT ms_played_0_null; 

update spotify_history
set sec_played = case when sec_played = 0 then null else sec_played end;

SAVEPOINT sec_played_0_null;

commit;

DELETE FROM spotify_history
WHERE ms_played IS NULL OR sec_played IS NULL;

DELETE FROM spotify_history
WHERE reason_end IS NULL OR reason_start IS NULL;

CREATE TABLE spotify_deduped AS
SELECT DISTINCT *
FROM spotify_history;

drop table spotify_history;

RENAME TABLE spotify_deduped TO spotify_history;

select DISTINCT(reason_start) from spotify_history;