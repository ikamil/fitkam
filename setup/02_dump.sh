export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
export ORACLE_SID_PDB=pfdb1
export NLS_LANG=.AL32UTF8
export ORACLE_SID=XE
$ORACLE_HOME/bin/impdp kam/kam12345@pfdb1 DUMPFILE=pf_demo.dmp DIRECTORY=DPUMP SCHEMAS="pf"