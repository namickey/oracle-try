
```shell
sqlplus APP/APP@//localhost/FREEPDB1
```
```sql
CREATE TABLE ITEM (
    "ID"   NUMBER NOT NULL,
    "KBN" CHAR(1),
    "PRICE" NUMBER,
    CONSTRAINT "ITEM_PK" PRIMARY KEY ( "ID" )
);
```

## SQLPLUSでDB接続(PDBに接続)
```shell
docker exec -it oracledb bash

sqlldr userid=APP/APP@//localhost/FREEPDB1 control=import.ctl log=import.log

sqlplus APP/APP@//localhost/FREEPDB1
select * from item;
```
