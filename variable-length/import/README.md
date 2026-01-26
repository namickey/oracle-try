
## git install
```shell
docker exec -it --user root oracledb bash
dnf update
dnf install git
dnf install nano
```

## SQLPLUSでDB接続(PDBに接続)
```shell
docker exec -it oracledb bash
echo "export NLS_LANG=Japanese_Japan.UTF8" >> .bashrc

git clone https://github.com/namickey/oracle-try.git
cd oracle-try

sqlplus APP/APP@//localhost/FREEPDB1

## テーブル作成
CREATE TABLE KOKYAKU (
    "KOKYAKU_ID"   VARCHAR2(10) NOT NULL,
    "NAME" VARCHAR2(60),
    "JUSHO" VARCHAR2(100),
    "CREATED_AT" DATE,
    CONSTRAINT "KOKYAKU_PK" PRIMARY KEY ( "KOKYAKU_ID" )
);
```

## Execute `import.ctl`
```shell
sqlldr userid=APP/APP@//localhost/FREEPDB1 control=import.ctl log=import.log

sqlplus APP/APP@//localhost/FREEPDB1
select * from kokyaku;
```
