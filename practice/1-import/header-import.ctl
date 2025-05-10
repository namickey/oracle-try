LOAD DATA
CHARACTERSET UTF8
INFILE 'req.txt'
REPLACE INTO TABLE req_header
WHEN (kbn = "1")
TRAILING NULLCOLS
(
    KBN position(1:1),
    CREATED_AT position(2:9)
)
