# oracle-try

## 前提 aaa

* Windows 10 or 11
* dockerデスクトップをインストールかつ起動
* Oracleアカウント作成
* Oracle SQL Developerをダウンロード配置

## OracleDBイメージ作成
未

## DB起動
```
docker run --name oracle-19c -p 1521:1521 -e ORACLE_SID=orcl -e ORACLE_PWD=manager -e ORACLE_CHARACTERSET=AL32UTF8 -v "C:/oracle":/opt/oracle/oradata doctorkirk/oracle-19c
```

## ユーザ作成
```
CREATE USER "APP" IDENTIFIED BY "APP";
ALTER USER "APP" DEFAULT TABLESPACE "USERS" TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK ;
GRANT CREATE SESSION TO "APP";
GRANT UNLIMITED TABLESPACE TO "APP";
GRANT CREATE TABLE TO "APP";
```

## テーブル作成
```
CREATE TABLE KOKYAKU (
    "KOKYAKU_ID"   VARCHAR2(10) NOT NULL,
    "NAME" VARCHAR2(60),
    "JUSHO" VARCHAR2(100),
    CONSTRAINT "KOKYAKU_PK" PRIMARY KEY ( "KOKYAKU_ID" )
);

CREATE TABLE CARD (
    "CARD_NUM" CHAR(16) NOT NULL,
    "KOKYAKU_ID"   VARCHAR2(10) NOT NULL,
    "STATUS" CHAR(1) NOT NULL,
    CONSTRAINT "CARD_PK" PRIMARY KEY ( "CARD_NUM" )
);

CREATE TABLE KOKYAKU_EXPORT_OK (
    "KOKYAKU_ID"   VARCHAR2(10) NOT NULL,
    "NAME" VARCHAR2(60),
    "JUSHO" VARCHAR2(100),
    CONSTRAINT "KOKYAKU_EXPORT_OK_PK" PRIMARY KEY ( "KOKYAKU_ID" )
);

CREATE TABLE KOKYAKU_EXPORT_NG (
    "KOKYAKU_ID"   VARCHAR2(10) NOT NULL,
    "NAME" VARCHAR2(60),
    "JUSHO" VARCHAR2(100),
    CONSTRAINT "KOKYAKU_EXPORT_NG_PK" PRIMARY KEY ( "KOKYAKU_ID" )
);
```

## データ作成
```
以下スクリプトで100万件のCSVデータ作成し、SQLDeveloperでimportする

kokyaku_gen_data.py
card_gen_data.py
```

or

```
DELETE FROM KOKYAKU;
DELETE FROM CARD;

4レコード作成
Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('001','SUZUKI','東京');
Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('002','YAMADA','大阪');
Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('003','SATO','名古屋');
Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('004','TAKAHASHI','九州');
Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('005','YAMASHIRO','沖縄');

Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234010 ','001','0');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234020 ','002','0');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234021 ','002','0');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234022 ','002','0');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234040 ','004','1');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234041 ','004','0');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234042 ','004','1');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234050 ','005','1');
```

## insert into select
```
# 削除
DELETE FROM KOKYAKU_EXPORT_OK;
DELETE FROM KOKYAKU_EXPORT_NG;

# 条件無し
INSERT INTO KOKYAKU_EXPORT_OK SELECT * FROM KOKYAKU;
INSERT INTO KOKYAKU_EXPORT_NG SELECT * FROM KOKYAKU;

# 条件有り
INSERT INTO KOKYAKU_EXPORT_OK
    SELECT
        KOKYAKU.KOKYAKU_ID,
        KOKYAKU.NAME,
        KOKYAKU.JUSHO
    FROM
             KOKYAKU
        INNER JOIN CARD ON KOKYAKU.KOKYAKU_ID = CARD.KOKYAKU_ID
    WHERE
        CARD.STATUS = '0';

INSERT INTO KOKYAKU_EXPORT_NG
    SELECT
        KOKYAKU.KOKYAKU_ID,
        KOKYAKU.NAME,
        KOKYAKU.JUSHO
    FROM
             KOKYAKU
        INNER JOIN CARD ON KOKYAKU.KOKYAKU_ID = CARD.KOKYAKU_ID
    WHERE
        CARD.STATUS = '1';
```

## insert into select 応用
```
#CARDを顧客IDで集約し、レコードの合計を求める
SELECT
    CARD.KOKYAKU_ID,
    COUNT(*)
FROM
    CARD
GROUP BY
    CARD.KOKYAKU_ID;


#CARDを顧客IDで集約し、ステータス=1のレコード数の合計を求める
SELECT
    CARD.KOKYAKU_ID,
    COUNT(*)
FROM
    CARD
WHERE
    CARD.STATUS = '1'
GROUP BY
    CARD.KOKYAKU_ID;


#CARDを顧客IDで集約し、ステータス=1のレコード数の合計をゼロも含めて求める
SELECT
    CARD.KOKYAKU_ID,
    SUM(
        CASE
            WHEN CARD.STATUS = '1' THEN 1
            ELSE 0
        END
    ) SUM
FROM
    CARD
GROUP BY
    CARD.KOKYAKU_ID;


#CARDを顧客IDで集約し、ステータス=1があれば判定フラグ=1を返す、なければ判定フラグ=0
SELECT
    CARD.KOKYAKU_ID,
    CASE
        WHEN SUM(
            CASE
                WHEN CARD.STATUS = '1' THEN 1
                ELSE 0
            END ) > 0 THEN 1
        ELSE 0
    END HANTEI
FROM
    CARD
GROUP BY
    CARD.KOKYAKU_ID;


# CARDのstatus='1'が1レコード以上あるKOKYAKUをSELECT
SELECT
    KOKYAKU.KOKYAKU_ID,
    KOKYAKU.NAME,
    KOKYAKU.JUSHO
FROM
    KOKYAKU
INNER JOIN
    (SELECT
        CARD.KOKYAKU_ID,
        CASE
          WHEN SUM(
            CASE
                WHEN CARD.STATUS = '1' THEN 1
                ELSE 0
            END ) > 0 THEN 1
          ELSE 0
        END HANTEI
    FROM
        CARD
    GROUP BY
        CARD.KOKYAKU_ID
    ) C ON KOKYAKU.KOKYAKU_ID = C.KOKYAKU_ID
WHERE
    C.HANTEI = 1;


#DISTINCTとjoinを使用して、上記と同じ結果
SELECT
    KOKYAKU.KOKYAKU_ID,
    KOKYAKU.NAME,
    KOKYAKU.JUSHO
FROM
    KOKYAKU
INNER JOIN
    (SELECT
        DISTINCT CARD.KOKYAKU_ID
    FROM
        CARD
    WHERE
        CARD.STATUS = '1'
    ) C ON KOKYAKU.KOKYAKU_ID = C.KOKYAKU_ID;


#DISTINCTとIN句を使用して、上記と同じ結果。※IN句は大量データは不可
SELECT
    KOKYAKU.KOKYAKU_ID,
    KOKYAKU.NAME,
    KOKYAKU.JUSHO
FROM
    KOKYAKU
where
   KOKYAKU.KOKYAKU_ID in (SELECT
        DISTINCT CARD.KOKYAKU_ID
    FROM
        CARD
    WHERE
        CARD.STATUS = '1')
```
