# cobol data

## File layout

| No. | Field         | Type       | Length | Notes           |
|---:|---------------|------------|-------:|-----------------|
| 1  | recordlength  | S9 COMP    | 4      | binary          |
| 2  | id            | 9          | 4      | zoned decimal   |
| 3  | name          | X          | 10     | alphanumeric    |
| 4  | price         | S9 COMP-3  | 4      | packed decimal  |

## sample data

```
00000016303030314150504C4520202020200012345C
000000163030303242414E414E41202020200067890C
0000001630303033434845525259202020200002500C
0000001630303034444154455320202020200000999D
0000001630303035454747504C414E5420201234567C
0000001630303036464947532020202020200000450C
0000001630303037475241504553202020200001200C
0000001630303038484F4E455920202020200099999C
0000001630303039494345435245414D20200000050C
00000016303031304A414D202020202020200075432C
```

## SQLPLUSでDB接続(PDBに接続)
```shell
docker exec -it oracledb bash

sqlldr userid=APP/APP@//localhost/FREEPDB1 control=a.ctl log=a.log

sqlplus APP/APP@//localhost/FREEPDB1
select * from cobol_data;
```


