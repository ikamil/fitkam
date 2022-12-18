export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
export ORACLE_SID_PDB=pfdb1
export NLS_LANG=.AL32UTF8
export ORACLE_SID=XE
$ORACLE_HOME/bin/impdp system/$ORACLE_PWD@pfdb1 DUMPFILE=pf_trial.dmp DIRECTORY=DPUMP SCHEMAS="kam,pf"
