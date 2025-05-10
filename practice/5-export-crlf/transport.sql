insert into CHECK_RESULT_SEND
(
ID,
KBN,
NAME,
PRICE,
RESULT_CODE
)
select 
    a.ID,
    b.KBN,
    b.NAME,
    b.PRICE,
    a.RESULT
from
    CHECK_RESULT a
    inner join REQ b
    on a.ID = b.ID
;
EXIT;
