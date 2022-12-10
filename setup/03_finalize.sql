ALTER SESSION SET CONTAINER = XEPDB1;

ALTER PACKAGE "PF"."PMMS" compile body;
ALTER PACKAGE "PF"."PMMS" compile;
ALTER PACKAGE "PF"."PORDERS_INTERNAL" compile body;
ALTER PACKAGE "PF"."PORDERS_INTERNAL" compile;
ALTER PACKAGE "PF"."PREPORTS_COLLECTION" compile body;
ALTER PACKAGE "PF"."PREPORTS_COLLECTION" compile;
ALTER PACKAGE "PF"."PMAINTENANCE" compile body;
ALTER PACKAGE "PF"."PMAINTENANCE" compile;
grant select, update on "PF"."TREPGROUP" to kam;
grant execute on kam.padmin to PF;
alter trigger "PF"."TR_USER" compile;
