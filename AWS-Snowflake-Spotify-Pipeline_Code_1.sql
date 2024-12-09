//Creating Databse
CREATE OR REPLACE DATABASE SPOTIFY_DB

//Creating tables in Snowflake
CREATE OR REPLACE TABLE album(
    album_id STRING,
    name STRING,
    release_date DATE,
    total_tracks INT,
    url STRING    
);

CREATE OR REPLACE TABLE artist(
    artist_id STRING,
    artist_name VARCHAR(50),
    external_url STRING    
);

CREATE OR REPLACE TABLE song(
    song_id STRING,
    song_name STRING,
    song_duration INT,
    song_url STRING,
    song_popularity INT,
    song_added DATE,
    album_id STRING,
    artist_id STRING
);


//Creating file format for .csv files
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.csv_file_format
type = CSV
field_delimiter = ","
skip_header = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"' ;


//Creating Stage integration ensuring connection between AWS S3 and Snowflake.

CREATE OR REPLACE STORAGE INTEGRATION s3_snow_spotify
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = s3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::982081049643:role/snowflake-s3-connection'
STORAGE_ALLOWED_LOCATIONS = ('s3://spotify-etl-project-ebenezer/transformed_data/')

DESC integration s3_snow_spotify


//Creating Stage 
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGE.spotify_stage
URL = 's3://spotify-etl-project-ebenezer/transformed_data/'
STORAGE_INTEGRATION = s3_snow_spotify
FILE_FORMAT = MANAGE_DB.FILE_FORMATS.csv_file_format

LIST @MANAGE_DB.EXTERNAL_STAGE.spotify_stage

//Test copy command
copy into SPOTIFY_DB.PUBLIC.album
from @MANAGE_DB.EXTERNAL_STAGE.spotify_stage
pattern = '.*album_data.*\.csv'

SELECT count(*) from  SPOTIFY_DB.PUBLIC.album
SELECT count(*) from  SPOTIFY_DB.PUBLIC.artist
SELECT count(*) from  SPOTIFY_DB.PUBLIC.song
SELECT * FROM SPOTIFY_DB.PUBLIC.artist


TRUNCATE TABLE SPOTIFY_DB.PUBLIC.album;
TRUNCATE TABLE SPOTIFY_DB.PUBLIC.artist;
TRUNCATE TABLE SPOTIFY_DB.PUBLIC.song;


//Create snowpipe for album folder
CREATE OR REPLACE PIPE MANAGE_DB.PIPES.spotify_album_pipe
AUTO_INGEST = TRUE
AS
copy into SPOTIFY_DB.PUBLIC.album
from @MANAGE_DB.EXTERNAL_STAGE.spotify_stage
pattern = '.*album_data.*\.csv'

//Accessing event notifications from S3
DESC PIPE MANAGE_DB.PIPES.spotify_album_pipe

//Create pipe for artist folder
CREATE OR REPLACE PIPE MANAGE_DB.PIPES.spotify_artist_pipe
AUTO_INGEST = TRUE
AS
copy into SPOTIFY_DB.PUBLIC.artist
from @MANAGE_DB.EXTERNAL_STAGE.spotify_stage
pattern = '.*artist_data.*\.csv'

//Accessing event notifications from S3
DESC PIPE MANAGE_DB.PIPES.spotify_artist_pipe

//Create pipe for song folder
CREATE OR REPLACE PIPE MANAGE_DB.PIPES.spotify_song_pipe
AUTO_INGEST = TRUE
AS
copy into SPOTIFY_DB.PUBLIC.song
from @MANAGE_DB.EXTERNAL_STAGE.spotify_stage
pattern = '.*songs_data/.*.csv'

//Accessing event notifications from S3
DESC PIPE MANAGE_DB.PIPES.spotify_song_pipe
