-- spotify_queries.sql
-- SQL Queries for Spotify Listening History Analysis
-- Organized by analysis sections

============================================================
= LISTENING BEHAVIOR INSIGHTS
============================================================

-- Q1. Top 10 most played tracks by total play time
SELECT track_name, SUM(play_time) AS total_play_time
FROM spotify_history
GROUP BY track_name
ORDER BY total_play_time DESC
LIMIT 10;

-- Q2. Which artists have the most play time overall
SELECT artist_name, SUM(play_time) AS total_play_time
FROM spotify_history
GROUP BY artist_name
ORDER BY total_play_time DESC;

-- Q3. Artist comparison by year
SELECT artist_name, strftime('%Y', play_date) AS year, SUM(play_time) AS total_play_time
FROM spotify_history
GROUP BY artist_name, year
ORDER BY year, total_play_time DESC;

-- Q7. Most listened albums
SELECT album_name, SUM(play_time) AS total_play_time
FROM spotify_history
GROUP BY album_name
ORDER BY total_play_time DESC;

============================================================
= TIME-BASED LISTENING TRENDS
============================================================

-- Q10. Time of day when music is most played
SELECT strftime('%H', play_date) AS hour, COUNT(*) AS play_count
FROM spotify_history
GROUP BY hour
ORDER BY play_count DESC;

-- Q11. Top 5 songs played on weekends
SELECT track_name, COUNT(*) AS play_count
FROM spotify_history
WHERE strftime('%w', play_date) IN ('0','6') -- Sunday=0, Saturday=6
GROUP BY track_name
ORDER BY play_count DESC
LIMIT 5;

-- Q12. Top songs played yearly
SELECT track_name, strftime('%Y', play_date) AS year, COUNT(*) AS play_count
FROM spotify_history
GROUP BY track_name, year
ORDER BY year, play_count DESC;

============================================================
= ENGAGEMENT & SKIP BEHAVIOR
============================================================

-- Q4. Most skipped songs
SELECT track_name, COUNT(*) AS skip_count
FROM spotify_history
WHERE skip_flag = 1
GROUP BY track_name
ORDER BY skip_count DESC;

-- Q5. Artists most frequently skipped
SELECT artist_name, COUNT(*) AS skip_count
FROM spotify_history
WHERE skip_flag = 1
GROUP BY artist_name
ORDER BY skip_count DESC;

-- Q6. Skip rate of popular songs
SELECT track_name,
       SUM(CASE WHEN skip_flag = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS skip_rate
FROM spotify_history
GROUP BY track_name
HAVING COUNT(*) > 100
ORDER BY skip_rate DESC;

============================================================
= DISCOVERY VS. LOYALTY PATTERNS
============================================================

-- Q8. Count of shuffles and manual plays
SELECT play_type, COUNT(*) AS play_count
FROM spotify_history
WHERE play_type IN ('shuffle', 'manual')
GROUP BY play_type;

-- Q9. How often autoplay was used
SELECT COUNT(*) AS autoplay_count
FROM spotify_history
WHERE play_type = 'autoplay';

============================================================
= ADDITIONAL INSIGHTS (From PPT)
============================================================

-- Average play duration per track
SELECT track_name, AVG(play_time) AS avg_play_duration
FROM spotify_history
GROUP BY track_name
ORDER BY avg_play_duration DESC;

-- How many unique songs were played
SELECT COUNT(DISTINCT track_name) AS unique_songs_played
FROM spotify_history;

-- Which platform was used the most
SELECT platform, COUNT(*) AS play_count
FROM spotify_history
GROUP BY platform
ORDER BY play_count DESC;

-- Total daily listening
SELECT play_date, SUM(play_time)/3600.0 AS total_hours
FROM spotify_history
GROUP BY play_date
ORDER BY play_date;

-- Total monthly listening in hours
SELECT strftime('%Y-%m', play_date) AS month, SUM(play_time)/3600.0 AS total_hours
FROM spotify_history
GROUP BY month
ORDER BY month;

-- Days with the highest play counts
SELECT play_date, COUNT(*) AS play_count
FROM spotify_history
GROUP BY play_date
ORDER BY play_count DESC
LIMIT 10;

-- Plays over time (daily trend)
SELECT play_date, COUNT(*) AS play_count
FROM spotify_history
GROUP BY play_date
ORDER BY play_date;

-- Average play time per artist
SELECT artist_name, AVG(play_time) AS avg_play_time
FROM spotify_history
GROUP BY artist_name
ORDER BY avg_play_time DESC;

-- Count of playback end reasons
SELECT end_reason, COUNT(*) AS reason_count
FROM spotify_history
GROUP BY end_reason
ORDER BY reason_count DESC;

-- First appearance of each artist
SELECT artist_name, MIN(play_date) AS first_appearance
FROM spotify_history
GROUP BY artist_name
ORDER BY first_appearance;
