ALTER SESSION SET CONTAINER = XEPDB1;
CREATE DIRECTORY dpump AS '/opt/oracle/oradata';
alter profile DEFAULT limit PASSWORD_REUSE_TIME unlimited;
alter profile DEFAULT limit PASSWORD_LIFE_TIME unlimited;
create user kam identified by kam12345;
grant connect, dba, alter user, drop user, grant any role, create user, alter system to kam;
grant execute on sys.dbms_sql to kam;
grant drop user to kam;
grant grant any role to kam;
grant create user to kam;
grant connect to kam with admin option;
grant select on dba_users to kam;
grant select on SYS.V_$SESSION to kam;
grant execute on DBMS_TRANSACTION to kam;
ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/XE/XEPDB1/temp02.dbf' SIZE 1G REUSE AUTOEXTEND OFF;
CREATE TABLESPACE PFBIG DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/pfbig01.dbf' SIZE 300M REUSE AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK ON;
CREATE TABLESPACE PFBIG_IX DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/pfbig_ix01.dbf' SIZE 100M REUSE AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK ON;
CREATE TABLESPACE PFLITTLE DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/pflittle01.dbf' SIZE 100M AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK ON;
CREATE TABLESPACE PFLITTLE_IX DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/pflittle_ix01.dbf' SIZE 50M AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK ON;
CREATE TABLESPACE PFMIDDLE DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/pfmiddle01.dbf' SIZE 1000M REUSE AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK ON;
CREATE TABLESPACE PFMIDDLE_IX DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/pfmiddle_ix01.dbf' SIZE 1000M REUSE AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK ON;
CREATE TABLESPACE LOGS DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/logs01.dbf' SIZE 100M REUSE AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK ON;
CREATE TABLESPACE LOGS_IX DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/logs_ix01.dbf' SIZE 30M REUSE AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK on;
CREATE TABLESPACE MAINTAIN DATAFILE
 '/opt/oracle/oradata/XE/XEPDB1/maintain01.dbf' SIZE 30M REUSE AUTOEXTEND ON
LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE BLOCKSIZE 8 K SEGMENT SPACE MANAGEMENT AUTO FLASHBACK on;
create role PF_MMS_ADMIN;
create role PF_MMS_BASE_ROLE;
create role MMS_REPORTS_ROLE;
create role POWERBI;
grant PF_MMS_BASE_ROLE, PF_MMS_ADMIN, MMS_REPORTS_ROLE, powerbi to kam;
--create user pf identified by pf12345;
--grant connect, resource to pf;

CREATE OR REPLACE PACKAGE KAM.PADMIN AS
    function sysuser(usr in varchar2) return number;
    procedure createuser(pUserName in varchar2,pUserPassword in varchar2);
    procedure alteruser(pUserName in varchar2,pUserPassword in varchar2);
    procedure dropuser(pUserName in varchar2);
    procedure blockuser(pUserName in varchar2);
    procedure unblockuser(pUserName in varchar2);
    procedure resetjobs;
end;
/

CREATE OR REPLACE PACKAGE BODY KAM.padmin as
function isysuser(usr in varchar2) return boolean is
begin
    return replace(upper(usr),' ','') in ('PF','KAM','SYS','SYSTEM','APEX_PUBLIC_USER',
    'APPQOSSYS','CTXSYS','DBSNMP','EXFSYS','MDDATA','MDSYS','ORACLE_OCM','ORDDATA','OUTLN'
    ,'ANONYMOUS','APEX_030200','APPQOSSYS','DIP','EXFSYS','FLOWS_FILES','IX','OE','OLAPSYS','ORACLE_OCM'
    ,'ORDPLUGINS','OUTLN','OWBSYS','OWBSYS_AUDIT','XS$NULL'
    ,'SI_INFORMTN_SCHEMA','SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR','SYSMAN','WMSYS','XDB');
end;
function sysuser(usr in varchar2) return number is
begin
    if isysuser(usr) then return 1; else return 0; end if;
end;
procedure createuser(pUserName in varchar2,pUserPassword in varchar2) is
pragma autonomous_transaction;
DefTablespace       VARCHAR2 (10);
TempTablespace      VARCHAR2 (10);
c                   INTEGER;
I                           NUMBER;
cursor checkuser(usr in varchar2) is select 1 from DBA_USERS where username=upper(trim(usr));
z number;
begin
    if isysuser(pUserName) then return; end if;
    open checkuser(pUserName); fetch checkuser into z; if checkuser%notfound then z:=0; end if; close checkuser;
    if z=0 then
        execute immediate 'call pf.IRBiS.getsystemparamvalue (''Default tablespace for users'') into :DefTablespace' using out DefTablespace;
        execute immediate 'call pf.IRBiS.getsystemparamvalue (''Temporary tablespace for users'') into :TempTablespace' using TempTablespace;
        c := DBMS_SQL.open_cursor;
        DBMS_SQL.parse (c,    'create user '|| pUserName|| ' identified by "'|| pUserPassword
            || '" default tablespace '|| DefTablespace ,1);                                               --||' temporary tablespace '||TempTablespace,1);
        I := DBMS_SQL.EXECUTE (c);
        DBMS_SQL.close_cursor (c);
    end if;
    c := DBMS_SQL.open_cursor;
    DBMS_SQL.parse (c, 'grant connect,PF_MMS_BASE_ROLE to ' || pUserName, 1);
    I := DBMS_SQL.EXECUTE (c);
    DBMS_SQL.close_cursor (c);
end;
procedure alteruser(pUserName in varchar2,pUserPassword in varchar2) is
pragma autonomous_transaction;
c                   INTEGER;
Res                 NUMBER;
cursor checkuser(usr in varchar2) is select 1 from DBA_USERS where username=upper(trim(usr));
z number;
begin
    if isysuser(pUserName) then return; end if;
    open checkuser(pUserName); fetch checkuser into z; if checkuser%notfound then z:=0; end if; close checkuser;
    if z=0 then return;end if;
    c := DBMS_SQL.open_cursor;
    DBMS_SQL.parse (c, 'alter user ' || pUserName || ' identified by "' || pUserPassword || '"', 1);
    Res := DBMS_SQL.EXECUTE (c);
    DBMS_SQL.close_cursor (c);
end;
procedure dropuser(pUserName in varchar2) is
pragma autonomous_transaction;
c                   INTEGER;
Res                 NUMBER;
cursor checkuser(usr in varchar2) is select 1 from DBA_USERS where username=upper(trim(usr));
z number;
begin
    if isysuser(pUserName) then return; end if;
    open checkuser(pUserName); fetch checkuser into z; if checkuser%notfound then z:=0; end if; close checkuser;
    if z=0 then return;end if;
    c := DBMS_SQL.open_cursor;
    DBMS_SQL.parse (c, 'drop user ' || pUserName || ' cascade ', 1);
    Res := DBMS_SQL.EXECUTE (c);
    DBMS_SQL.close_cursor (c);
end;
procedure blockuser(pUserName in varchar2) is
pragma autonomous_transaction;
c                   INTEGER;
Res                 NUMBER;
cursor checkuser(usr in varchar2) is select 1 from DBA_USERS where username=upper(trim(usr));
z number;
begin
    if isysuser(pUserName) then return; end if;
    open checkuser(pUserName); fetch checkuser into z; if checkuser%notfound then z:=0; end if; close checkuser;
    if z=0 then return;end if;
    c := DBMS_SQL.open_cursor;
    DBMS_SQL.parse (c, 'alter user ' || pUserName || ' account lock ', 1);
    Res := DBMS_SQL.EXECUTE (c);
    DBMS_SQL.close_cursor (c);
end;
procedure unblockuser(pUserName in varchar2) is
pragma autonomous_transaction;
c                   INTEGER;
Res                 NUMBER;
z number;
begin
    if isysuser(pUserName) then return; end if;
    if z=0 then return;end if;
    c := DBMS_SQL.open_cursor;
    DBMS_SQL.parse (c, 'alter user ' || pUserName || ' account unlock ', 1);
    Res := DBMS_SQL.EXECUTE (c);
    DBMS_SQL.close_cursor (c);
end;
procedure resetjobs as
begin
FOR cur_rec IN (select logon_time, 'alter system disconnect session ''' || sid || ',' || serial# || ''' immediate' AS ddl
  from v$session where osuser='oracle' and username = 'PF' and module is null and logon_time < SYSDATE-1/24)
LOOP
    BEGIN
      EXECUTE IMMEDIATE cur_rec.ddl;
      EXECUTE IMMEDIATE 'update PF.TREPGROUP set update_start = null where update_start>=cur_rec.logon_time';
    EXCEPTION
      WHEN OTHERS THEN
        EXECUTE IMMEDIATE 'begin PF.LOGINSERT(''Session Kill'', sqlerrm); end;';
    END;
END LOOP;
end;
end;
/

grant execute on kam.padmin to PF_MMS_ADMIN;
/
