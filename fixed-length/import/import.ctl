LOAD DATA
CHARACTERSET UTF8
INFILE 'item.txt'
REPLACE
INTO TABLE item
WHEN (kbn = "2")
TRAILING NULLCOLS
(
    ID SEQUENCE(MAX,1),
    KBN position(1:1),
    PRICE position(2:6)
)