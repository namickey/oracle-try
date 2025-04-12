LOAD DATA
INFILE 'kokyaku.csv' CHARACTERSET UTF8
INTO TABLE kokyaku
REPLACE
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    KOKYAKU_ID,
    NAME,
    JUSHO
)