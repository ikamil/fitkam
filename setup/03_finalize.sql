ALTER SESSION SET CONTAINER = XEPDB1;

grant connect, dba, alter user, drop user, grant any role, create user, alter system to kam;
grant execute on sys.dbms_sql to kam;
grant drop user to kam;
grant grant any role to kam;
grant create user to kam;
grant connect to kam with admin option;
grant select on dba_users to kam;
grant select on SYS.V_$SESSION to kam;
grant execute on DBMS_TRANSACTION to kam;
grant PF_MMS_BASE_ROLE, PF_MMS_ADMIN, MMS_REPORTS_ROLE, powerbi to kam;
ALTER PACKAGE "KAM"."PADMIN" compile body;
ALTER PACKAGE "KAM"."PADMIN" compile;
grant execute on kam.padmin to PF_MMS_ADMIN;
grant execute on kam.padmin to PF;

ALTER PACKAGE "PF"."PMMS" compile body;
ALTER PACKAGE "PF"."PMMS" compile;
ALTER PACKAGE "PF"."PORDERS_INTERNAL" compile body;
ALTER PACKAGE "PF"."PORDERS_INTERNAL" compile;
ALTER PACKAGE "PF"."PREPORTS_COLLECTION" compile body;
ALTER PACKAGE "PF"."PREPORTS_COLLECTION" compile;
ALTER PACKAGE "PF"."PMAINTENANCE" compile body;
ALTER PACKAGE "PF"."PMAINTENANCE" compile;
grant select, update on "PF"."TREPGROUP" to kam;
alter trigger "PF"."TR_USER" compile;
begin pf.parchive.init(); end;
