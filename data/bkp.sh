export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
DT=`date +'%Y%m%d'`
DIR=/opt/oracle/oradata
FILE=pfk$DT.dmp

$ORACLE_HOME/bin/expdp kam/*****@pfdb1 DUMPFILE=$FILE DIRECTORY=DPUMP SCHEMAS="pf,kam"

#ls $DIR/*.dmp -t | sed -e '1,2d' | xargs -d '\n' rm
