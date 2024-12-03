SCRIPTDIR=/Users/malcolm/atf15xx_yosys
BASE=$1
rm $1.fit
rm $1.log
rm $1.io
rm $1.edif
rm $1.pin
rm $1.tt3
$SCRIPTDIR/run_yosys.sh $1 > $1.log
$SCRIPTDIR/run_fitter.sh -d ATF1504AS -p PQFP -s 15 $1 

