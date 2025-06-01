## 概要

* テーブルに格納された1行のデータを増幅する

```shell
docker exec -it oracledb bash

sqlplus APP/APP@//localhost/FREEPDB1
```

## テーブル作成
```sql
CREATE TABLE ITEMS (
    "ID"   NUMBER NOT NULL,
    "YMD" CHAR(8),
    "KBN" CHAR(1),
    "NAME" VARCHAR2(10),
    "CODE" CHAR(7),
    "PRICE" NUMBER(10),
    "GEN_DATE" DATE,
    CONSTRAINT "ITEMS_PK" PRIMARY KEY ( "ID" )
);
```

## データ追加　（増幅元データ1行を追加）
```sql
truncate table items;
insert into ITEMS values (1,'20250101','2', 'ペン', '1000001', 1, sysdate);
```

## 増幅
* 増幅元データをselectし、ループ回数（counter_i）をキー項目に設定
* 1万件毎にコミット
* 99万件で20秒程度
```sql
begin
  for counter_i in 2..999999 loop
    insert into ITEMS
    select
        counter_i,
        ymd,
        kbn,
        name,
        '1' || lpad(counter_i,6, '0'),
        price,
        gen_date
    from ITEMS
    where id = 1
    ;
    if mod(counter_i, 10000) = 0 then
      commit;
    end if;
  end loop;
  commit;
end;
/
```

## 件数確認
```sql
set linesize 200;
select count(*) from items;
select * from items where id in (1,2,999998,999999);
```