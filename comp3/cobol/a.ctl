LOAD DATA
INFILE 'a.txt' "FIX 22"
BADFILE 'a.bad'
DISCARDFILE 'a.dsc'
INTO TABLE cobol_data
TRUNCATE
(
	recordlength  FILLER RAW(4),  -- COBOL S9 COMP (binary length, unused for insert)
	id            position(5:8) ,       -- COBOL 9(4) zoned decimal
	name          position(9:18) ,       -- COBOL X(10)
	price         position(19:22) DECIMAL(7,0)       -- COBOL S9 COMP-3 packed decimal (7 digits fits in 4 bytes)
)
