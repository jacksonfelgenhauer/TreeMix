
#Use script: ./Running_TreeMix.sh [input file] [output file name] [population root] 
#Input file extension (.treemix.frq.gz)

INP=$1
OUT=$2
ROOT=$3

#Number of migration can be changed accordingly (0..n) n = number of migration
for i in {0..8};
do
treemix -i $INP -m $i -o $OUT.$i -root $ROOT -bootstrap -k 500 -noss > treemix_${i}_log &
done
