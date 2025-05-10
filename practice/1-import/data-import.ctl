LOAD DATA
CHARACTERSET UTF8
INFILE 'req.txt'
REPLACE INTO TABLE req
WHEN (kbn = "2")
TRAILING NULLCOLS
(
    ID SEQUENCE(MAX,1),
    KBN position(1:1),
    NAME position(2:11),
    PRICE position(12:16)
)
