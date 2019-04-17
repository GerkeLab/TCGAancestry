# STEP 1: Download files from GDC 

<!---Run 08/31/2018-->

Genotypes for each sample were downloaded as individual files from the TCGA legacy archive using the gdc-client. The manifest was built on the Legacy Archive site and the token was provided by TCGA after applying for access. 

```
echo "module load anaconda/2; gdc-client download -m /share/lab_gerke/panCancer/data/legacyArchive4/gdc_manifest.2018-08-31.txt -t /share/lab_gerke/panCancer/data/legacyArchive4/gdc-user-token.2018-08-31T10_17_16-04_00.txt" | qsub -d. -q bigmemQ -l mem=16G,nodes=1:ppn=4,walltime=999:00:00 -N panCancer -m abe -M jordan.h.creed@moffitt.org
```

***

# STEP 2: Merge together individual genotype call files 

<!---Run 09/19/2018-->

Individual genotype files were merged together into a single flat file. We had to separate the file into three smaller files based on tissue type (tumor, normal and other) due to file size restrictions. 
**Disclaimer:** script took over 200 hours to complete

```
qsub /share/lab_gerke/panCancer/code/mergeGenoCallsCluster.qsub
	- runs: /share/lab_gerke/panCancer/code/mergeGenoCalls.R
```

***

# STEP 3: Convert text files from step 2 to plink compatable ped and map file

ADMIXTURE requires input in the form of binary plink files, so the flat text file from step 2 was then converted into a plink compatable format (specifically ped and map format), which could then later be easily converted into binary files. 

```
qsub /share/lab_gerke/panCancer/code/convertGenoCallsCluster.qsub.sh
	- runs: /share/lab_gerke/panCancer/code/createPlinkFiles.R
```

***

# STEP 4: convert plink ped and map files into binary plink files 

Ped and map files were then converted binary plink files (bed, bim, and fam). Plink 1.90b was used. 

```
plink --ped geno_matrix_other.ped --map geno_matrix_other.map --allow-extra-chr --exclude geno_matrix_other_exclusion_snps.txt --make-bed --out geno_matrix_other_binary 

plink --ped geno_matrix_normal.ped --map geno_matrix_normal.map --allow-extra-chr --exclude geno_matrix_normal_exclusion_snps.txt --make-bed --out geno_matrix_normal_binary 

plink --ped geno_matrix_tumor.ped --map geno_matrix_tumor.map --allow-extra-chr --exclude geno_matrix_tumor_exclusion_snps.txt --make-bed --out geno_matrix_tumor_binary 
```

<!--- Additional step for unsupervised clustering shown below but ultimately not used-->

<!--- 
	
#-------------------------------------------------------------------------------------------------#

## STEP 4.1: subset to MAF > 0.05

plink --bfile geno_matrix_other_binary --allow-extra-chr --maf 0.05 --make-bed --out geno_matrix_other_binary_maf05 

plink --bfile geno_matrix_normal_binary --allow-extra-chr --maf 0.05 --make-bed --out geno_matrix_normal_binary_maf05 

plink --bfile geno_matrix_tumor_binary --allow-extra-chr --maf 0.05 --make-bed --out geno_matrix_tumor_binary_maf05 

#-------------------------------------------------------------------------------------------------#

## STEP 4.2: thin out to only ~ 200,000 snps 

plink --bfile geno_matrix_other_binary --allow-extra-chr --thin 0.22 --make-bed --out geno_matrix_other_binary_thin22 

plink --bfile geno_matrix_normal_binary --allow-extra-chr --thin 0.22 --make-bed --out geno_matrix_normal_binary_thin22 

plink --bfile geno_matrix_tumor_binary --allow-extra-chr --thin 0.22 --make-bed --out geno_matrix_tumor_binary_thin22 

#-------------------------------------------------------------------------------------------------#

## STEP 4.3: thin out based on recommendations from admixture manual

plink --bfile geno_matrix_normal_binary --indep-pairwise 50 10 0.1

plink --bfile geno_matrix_other_binary --allow-extra-chr --extract plink.prune.in --make-bed --out geno_matrix_other_binary_prune

plink --bfile geno_matrix_normal_binary --allow-extra-chr --extract plink.prune.in --make-bed --out geno_matrix_normal_binary_prune 

plink --bfile geno_matrix_tumor_binary --allow-extra-chr --extract plink.prune.in --make-bed --out geno_matrix_tumor_binary_prune 

## all output moved to /share/lab_gerke/panCancer/data/intermediateData/prune_thinned 

#-------------------------------------------------------------------------------------------------#

# STEP 5: run admixture algorithm 

for K in {1..20}; do echo "module add admixture; admixture --cv -B /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_other_binary.bed $K -j4 | tee admix_log_other${K}.out" | qsub -d. -l walltime=999:00:00 -N admix_pan_other ; done

plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_tumor_binary --pca
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_normal_binary --pca
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_other_binary --pca

#-------------------------------------------------------------------------------------------------#

admixture /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_other_binary_maf05.bed 3 -j4

#-------------------------------------------------------------------------------------------------#

## STEP 5.2: run admixture algorithm on random thinned out subset and minimal information and PCA

admixture /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_tumor_binary_thin22.bed 3 -j4
admixture /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_normal_binary_thin22.bed 3 -j8
admixture /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_other_binary_thin22.bed 3 -j8

plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_tumor_binary_thin22 --pca
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_normal_binary_thin22 --pca
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_other_binary_thin22 --pca

#-------------------------------------------------------------------------------------------------#

## STEP 5.3: run admixture algorithm on prunned subset and minimal information and PCA

admixture /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_tumor_binary_prune.bed 3 -j8
admixture /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_normal_binary_prune.bed 3 -j8
admixture /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_other_binary_prune.bed 3 -j8

plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_tumor_binary_prune --pca
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_normal_binary_prune --pca
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/geno_matrix_other_binary_prune --pca

-->