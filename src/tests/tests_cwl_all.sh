set -e
CWL_NAME_LIST=`ls -1 src/cwl/*cwl | sed 's/\./cwl//g' | sed 's/src\/cwl\///g'`
echo $CWL_NAME_LIST
for CWL_NAME in $CWL_NAME_LIST; do
       source src/tests/tests_cwl.sh $CWL_NAME;
done
