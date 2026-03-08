
各テーブル（住所・電話）の最新データを、
既存ユーザー情報に反映していく一連のバッチ処理

## 処理の流れ

T_USER_OLDへデータ登録
T_USERへT_USER_OLDのデータを登録
T_ADDRのトランケート
T_ADDRへデータ登録
T_TELのトランケート
T_TELへデータ登録
T_TMP1のトランケート
T_ADDRからT_TMP1へマージ登録
T_TELからT_TMP1へマージ登録
T_TMP1からT_USERへマージ登録

## DDL

```sql
CREATE TABLE T_ADDR (
    "ID"   NUMBER NOT NULL,
    "TN" NUMBER,
    "KEN" VARCHAR2(30),
    "SHI" VARCHAR2(30),
    CONSTRAINT "T_ADDR_PK" PRIMARY KEY ( "ID", "TN" )
);

CREATE TABLE T_TEL (
    "ID"   NUMBER NOT NULL,
    "TN" NUMBER,
    "TEL1" NUMBER,
    "TEL2" NUMBER,
    "TEL3" NUMBER,
    CONSTRAINT "T_TEL_PK" PRIMARY KEY ( "ID", "TN" )
);

CREATE TABLE T_TMP1 (
    "ID"   NUMBER NOT NULL,
    "NAME" VARCHAR2(30),
    "KEN" VARCHAR2(30),
    "SHI" VARCHAR2(30),
    "TEL1" NUMBER,
    "TEL2" NUMBER,
    "TEL3" NUMBER,
    CONSTRAINT "T_TMP1_PK" PRIMARY KEY ( "ID" )
);

CREATE TABLE T_USER (
    "ID"   NUMBER NOT NULL,
    "NAME" VARCHAR2(30),
    "KEN" VARCHAR2(30),
    "SHI" VARCHAR2(30),
    "TEL1" NUMBER,
    "TEL2" NUMBER,
    "TEL3" NUMBER,
    CONSTRAINT "T_USER_PK" PRIMARY KEY ( "ID" )
);

CREATE TABLE T_USER_OLD (
    "ID"   NUMBER NOT NULL,
    "NAME" VARCHAR2(30),
    "KEN" VARCHAR2(30),
    "SHI" VARCHAR2(30),
    "TEL1" NUMBER,
    "TEL2" NUMBER,
    "TEL3" NUMBER,
    CONSTRAINT "T_USER_OLD_PK" PRIMARY KEY ( "ID" )
);

## データ削除

TRUNCATE TABLE T_TEL;
TRUNCATE Table T_ADDR;
TRUNCATE TABLE T_TMP1;
TRUNCATE TABLE T_USER;
TRUNCATE TABLE T_USER_OLD;

## データ準備

INSERT INTO T_ADDR ("ID", "TN", "KEN", "SHI") VALUES (10, 1, '埼玉県', '大宮市');
INSERT INTO T_ADDR ("ID", "TN", "KEN", "SHI") VALUES (10, 2, '埼玉県', 'さいたま市');
INSERT INTO T_ADDR ("ID", "TN", "KEN", "SHI") VALUES (20, 1, '埼玉県', '浦和市');

INSERT INTO T_TEL ("ID", "TN", "TEL1", "TEL2", "TEL3") VALUES (10, 1, 090, 1234, 5678);
INSERT INTO T_TEL ("ID", "TN", "TEL1", "TEL2", "TEL3") VALUES (10, 2, 090, 2345, 6789);
INSERT INTO T_TEL ("ID", "TN", "TEL1", "TEL2", "TEL3") VALUES (30, 1, 090, 3456, 7890);

INSERT INTO T_USER_OLD ("ID", "NAME", "KEN", "SHI", "TEL1", "TEL2", "TEL3") VALUES (10, '山田太郎', '東京都', '新宿区', 03, 1234, 5678);
INSERT INTO T_USER_OLD ("ID", "NAME", "KEN", "SHI", "TEL1", "TEL2", "TEL3") VALUES (20, '佐藤花子', '東京都', '中央区', 03, 2345, 6789);
INSERT INTO T_USER_OLD ("ID", "NAME", "KEN", "SHI", "TEL1", "TEL2", "TEL3") VALUES (30, '鈴木次郎', '東京都', '千代田区', 03, 3456, 7890);
INSERT INTO T_USER_OLD ("ID", "NAME", "KEN", "SHI", "TEL1", "TEL2", "TEL3") VALUES (40, '伊藤三郎', '東京都', '北区', 03, 3456, 7890);
```

## データロード

T_USER_OLD　⇒　T_USER
```sql
INSERT INTO T_USER
SELECT *
FROM T_USER_OLD;
```

## マージ登録

T_USER ＋ T_ADDR ⇒ T_TMP1
```sql
MERGE INTO T_TMP1 t
USING (
    /* ベース: T_ADDR の TN最大(最新)を採用し、
       不足カラム(NAME/TEL1/TEL2/TEL3)を古いマスタ T_USER で補完 */
    SELECT
        b.ID,
        u.NAME,
        b.KEN,
        b.SHI,
        u.TEL1,
        u.TEL2,
        u.TEL3
    FROM (
        SELECT ID, KEN, SHI
        FROM (
            SELECT
                x.ID,
                x.KEN,
                x.SHI,
                ROW_NUMBER() OVER (PARTITION BY x.ID ORDER BY x.TN DESC) AS rn
            FROM T_ADDR x
        )
        WHERE rn = 1
    ) b
    LEFT JOIN T_USER u
        ON u.ID = b.ID
) s
ON (t.ID = s.ID)
WHEN MATCHED THEN
    UPDATE SET
        t.KEN  = s.KEN,
        t.SHI  = s.SHI
WHEN NOT MATCHED THEN
    INSERT (ID, NAME, KEN, SHI, TEL1, TEL2, TEL3)
    VALUES (s.ID, s.NAME, s.KEN, s.SHI, s.TEL1, s.TEL2, s.TEL3);
```

T_USER ＋ T_TEL ⇒ T_TMP1
```sql
MERGE INTO T_TMP1 t
USING (
    /* ベース: T_TEL の TN最大(最新)を採用し、
       不足カラム(NAME/KEN/SHI)は古いマスタ T_USER から補完 */
    SELECT
        b.ID,
        u.NAME,
        u.KEN,
        u.SHI,
        b.TEL1,
        b.TEL2,
        b.TEL3
    FROM (
        SELECT ID, TEL1, TEL2, TEL3
        FROM (
            SELECT
                x.ID,
                x.TEL1,
                x.TEL2,
                x.TEL3,
                ROW_NUMBER() OVER (PARTITION BY x.ID ORDER BY x.TN DESC) AS rn
            FROM T_TEL x
        )
        WHERE rn = 1
    ) b
    LEFT JOIN T_USER u
        ON u.ID = b.ID
) s
ON (t.ID = s.ID)
WHEN MATCHED THEN
    UPDATE SET
        t.TEL1 = s.TEL1,
        t.TEL2 = s.TEL2,
        t.TEL3 = s.TEL3
WHEN NOT MATCHED THEN
    INSERT (ID, NAME, KEN, SHI, TEL1, TEL2, TEL3)
    VALUES (s.ID, s.NAME, s.KEN, s.SHI, s.TEL1, s.TEL2, s.TEL3);
```

T_TMP1 ⇒ T_USER
```sql
MERGE INTO T_USER t
USING T_TMP1 s
ON (t.ID = s.ID)
WHEN MATCHED THEN
    UPDATE SET
        t.KEN  = s.KEN,
        t.SHI  = s.SHI,
        t.TEL1 = s.TEL1,
        t.TEL2 = s.TEL2,
        t.TEL3 = s.TEL3
WHEN NOT MATCHED THEN
    INSERT (ID, NAME, KEN, SHI, TEL1, TEL2, TEL3)
    VALUES (s.ID, s.NAME, s.KEN, s.SHI, s.TEL1, s.TEL2, s.TEL3);
```
