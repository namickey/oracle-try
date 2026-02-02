LOAD DATA
INFILE 'a.txt' "FIX 22"
BADFILE 'a.bad'
DISCARDFILE 'a.dsc'
INTO TABLE cobol_data
TRUNCATE
(
	recordlength  FILLER RAW(4),  -- COBOL S9 COMP (binary length, unused for insert)
	id            ZONED(4),       -- COBOL 9(4) zoned decimal
	name          CHAR(10),       -- COBOL X(10)
	price         PACKED(7)       -- COBOL S9 COMP-3 packed decimal (7 digits fits in 4 bytes)
)
