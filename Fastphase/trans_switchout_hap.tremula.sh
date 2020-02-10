transpose="/proj/b2011141/pipeline/fastphase/transpose.awk"
switch_out=$1

OutDir=`dirname $1`
Out=${1##*/}
OutSuffix=${Out%._hapguess_switch.out}.hap

hap=$OutDir/hap

if [ ! -d "$hap" ]; then
mkdir -p $hap
fi

head -n 93 $switch_out | tail -n 72 | sed -n -e 2,3p -e 5,6p -e 8,9p -e 11,12p -e 14,15p -e 17,18p -e 20,21p -e 23,24p -e 26,27p -e 29,30p -e 32,33p -e 35,36p -e 38,39p -e 41,42p -e 44,45p -e 47,48p -e 50,51p -e 53,54p -e 56,57p -e 59,60p -e 62,63p -e 65,66p -e 68,69p -e 71,72p -e 74,75p > $hap/$OutSuffix

$transpose $hap/$OutSuffix > $hap/$OutSuffix.temp && mv $hap/$OutSuffix.temp $hap/$OutSuffix


