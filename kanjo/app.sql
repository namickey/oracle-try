
TRUNCATE TABLE T_TMP1;
TRUNCATE TABLE T_USER;

INSERT INTO T_USER
SELECT *
FROM T_USER_OLD;

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