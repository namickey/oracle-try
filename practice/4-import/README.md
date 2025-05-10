
```shell
sqlplus APP/APP@//localhost/FREEPDB1
```
```sql
CREATE TABLE CHECK_RESULT (
    "ID"   NUMBER NOT NULL,
    "RESULT" CHAR(2),
    "CREATED_AT" CHAR(8),
    CONSTRAINT "CHECK_RESULT_PK" PRIMARY KEY ( "ID" )
);

CREATE TABLE CHECK_RESULT_SEND (
    "ID"   NUMBER NOT NULL,
    "KBN" CHAR(1),
    "NAME" VARCHAR2(10),
    "PRICE" NUMBER,
    "RESULT_CODE" CHAR(2),
    CONSTRAINT "CHECK_RESULT_SEND_PK" PRIMARY KEY ( "ID" )
);
```

## SQLPLUSでDB接続(PDBに接続)
```shell
docker exec -it oracledb bash

sqlldr userid=APP/APP@//localhost/FREEPDB1 control=data-import.ctl log=data-import.log

sqlplus APP/APP@//localhost/FREEPDB1
select * from check_result;
```
