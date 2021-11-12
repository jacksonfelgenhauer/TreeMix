#Make sure that the population was merged in plink binary format and Kinship analysis have been performed before proceeding with this code. Note that plink, plink2, bcftools must be installed

#Merged population binary file = BIN
BIN=$1

#Remove Missingness per marker
./plink --bfile $BIN --geno 0 --make-bed --out $BIN.missingness

#HWE<0.00001
./plink --bfile $BIN.missingness --hwe 0.00001 --make-bed --out $BIN.missingness.hwe

#Excluding sex and mitochondrial chromosomes
./plink --bfile $BIN.missingness.hwe --chr 1-22 --make-bed --out $BIN.missingness.hwe.1-22

#Biallelic
./plink2 --bfile $BIN.missingness.hwe.1-22 --max-alleles 2 --min-alleles 2 --make-bed --out $BIN.missingness.hwe.1-22.biallelic

#Pruning
./plink --bfile $BIN.missingness.hwe.1-22.biallelic --indep-pairwise 50 5 0.5 --out Pruning

./plink --bfile $BIN.missingness.hwe.1-22.biallelic --extract Pruning.prune.in --make-bed --out MergedPopulation_QC

MQC=MergedPopulation_QC

#Vcf conversion
./plink --bfile $MQC --recode vcf --out $MQC

#Pop abbreviation
./bcftools query -l $MQC.vcf | awk '{split($1,pop,"."); print $1"\t"$1"\t"pop[2]"\t"substr($0,0,3);}' > TreeMix.clust

wc -l $BIN.missingness.bim
wc -l $BIN.missingness.hwe.bim
wc -l $BIN.missingness.hwe.1-22.bim
wc -l $BIN.missingness.hwe.1-22.biallelic.bim
wc -l MergedPopulation_QC.bim
