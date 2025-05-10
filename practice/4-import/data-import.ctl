LOAD DATA
CHARACTERSET UTF8
INFILE 'check-result.txt'
REPLACE INTO TABLE check_result
TRAILING NULLCOLS
(
    ID position(1:3),
    RESULT position(4:5),
    CREATED_AT "TO_CHAR(SYSDATE,'YYYYMMDD')"
)
