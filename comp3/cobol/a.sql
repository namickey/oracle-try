-- Table for SQL*Loader control file a.ctl (id, name, price)
CREATE TABLE cobol_data (
	id    NUMBER(4),     -- COBOL 9(4) zoned decimal
	name  CHAR(10),      -- COBOL X(10)
	price NUMBER(7)      -- COBOL S9 COMP-3 (4 bytes, up to 7 digits + sign)
);
