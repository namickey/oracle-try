
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


```
PIC 9(n) / S9(n)        → DECIMAL(n,0)
PIC 9(n)V9(m)           → DECIMAL(n+m,m)
PIC S9(n)V9(m) COMP-3   → DECIMAL(n+m,m)
PIC X(n)                → CHAR(n)
PIC N(n)                → NVARCHAR(n)
```

| 10進数     | 意味例    | 16進（Big Endian） | バイト列              |
| -------- | ------ | --------------- | ----------------- |
| 1        | 最小値例   | `00000001`      | `00 00 00 01`     |
| 10       | 小サイズ   | `0000000A`      | `00 00 00 0A`     |
| 256      | 1ブロック  | `00000100`      | `00 00 01 00`     |
| 1024     | 1KB    | `00000400`      | `00 00 04 00`     |
| **1234** | よくある例  | **`000004D2`**  | **`00 00 04 D2`** |
| 4096     | 4KB    | `00001000`      | `00 00 10 00`     |
| 65535    | 2バイト最大 | `0000FFFF`      | `00 00 FF FF`     |
| 100000   |        | `000186A0`      | `00 01 86 A0`     |

| 10進数    | 16進（Big Endian）                    | バイト列          |
| ------- | ---------------------------------- | ------------- |
| -1      | `FFFFFFFF`                         | `FF FF FF FF` |
| -2      | `FFFFFFFE`                         | `FF FF FF FE` |
| -10     | `FFFFFFF6`                         | `FF FF FF F6` |
| -1234   | `FFFFFB2E`                         | `FF FF FB 2E` |
| -4096   | `FFFFF000`                         | `FF FF F0 00` |
| -65535  | `FFFF0001`                         | `FF FF 00 01` |
| -100000 | `FF F E79 60` → 正しくは `FF FE 79 60` | `FF FE 79 60` |
