# oracle-try

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
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234010 ','001','0');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234020 ','002','0');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234040 ','004','1');
Insert into CARD (CARD_NUM,KOKYAKU_ID,STATUS) values ('123456781234021 ','002','0');

Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('001','SUZUKI','東京');
Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('002','YAMADA','大阪');
Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('003','SATO','名古屋');
Insert into KOKYAKU (KOKYAKU_ID,NAME,JUSHO) values ('004','TAKAHASHI','九州');
```

## insert into select
```
delete from kokyaku_export_ok;
delete from kokyaku_export_ng;
insert into kokyaku_export_ok SELECT * from kokyaku;
insert into kokyaku_export_ng SELECT * from kokyaku;
```
