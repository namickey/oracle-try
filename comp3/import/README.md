
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
```

```
2pen       00100
2notebook  00200
2desk      16000
2paperclips00300
```
```
python tool-comp3.py

comp3-toolout.txt
```
```
python display-file.py

16進文字列
32 70 65 6E 20 20 20 20 20 20 20 00 10 0C 0A
32 6E 6F 74 65 62 6F 6F 6B 20 20 00 20 0C 0A
32 64 65 73 6B 20 20 20 20 20 20 16 00 0C 0A
32 70 61 70 65 72 63 6C 69 70 73 00 30 0C 0A
```


## SQLPLUSでDB接続(PDBに接続)
```shell
docker exec -it oracledb bash

sqlldr userid=APP/APP@//localhost/FREEPDB1 control=data-import.ctl log=data-import.log

sqlplus APP/APP@//localhost/FREEPDB1
select * from item;
```
