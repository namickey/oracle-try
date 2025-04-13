
```shell
sqlplus APP/APP@//localhost/FREEPDB1
```
```sql
CREATE TABLE ITEM (
    "ID"   NUMBER NOT NULL,
    "KBN" CHAR(1),
    "NAME" VARCHAR2(10),
    "PRICE" NUMBER,
    CONSTRAINT "ITEM_PK" PRIMARY KEY ( "ID" )
);

CREATE TABLE HEADER (
    "KBN" CHAR(1),
    "DATE" CHAR(8),
    CONSTRAINT "HEADER_PK" PRIMARY KEY ( "KBN" )
);
```

## SQLPLUSでDB接続(PDBに接続)
```shell
docker exec -it oracledb bash

sqlldr userid=APP/APP@//localhost/FREEPDB1 control=data-import.ctl log=data-import.log
sqlldr userid=APP/APP@//localhost/FREEPDB1 control=header-import.ctl log=header-import.log

sqlplus APP/APP@//localhost/FREEPDB1
select * from item;
```
