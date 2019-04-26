# TCGAancestry
Global ancestry estimates for the TCGA panCancer cohort from ADMIXTURE

<!-- README start -->

## Summary

The Cancer Genome Atlas ([TCGA](https://www.cancer.gov/about-nci/organization/ccg/research/structural-genomics/tcga)) is a vital resource in molecular cancer research. Opportunities to conduct cancer health disparities research from this resource are currently limited by incomplete data capture for self-reported race. Moreover, self-reported measures have known limitations, such as binning mixed race individuals into a single racial group which may not reflect their genetic make-up and thus risk. Therefore, we estimated global ancestry for all available TCGA samples according to standardized populations from [1000 Genomes](http://www.internationalgenome.org/category/population/).

## Samples

For all available sample types (primary solid tumor, blood derived normal or other), genotypes were downloaded from [TCGA’s Legacy Archive](https://portal.gdc.cancer.gov/legacy-archive/search/f). In total there were 22,963 samples from 11,127 TCGA participants over 30 cancers included.

## Supervised Analsyis 

[ADMIXTURE](http://software.genetics.ucla.edu/admixture/) software was used to estimate ancestral proportions from each of the five 1000 Genomes global super populations. Phase 3 samples from 1000 Genomes (n = 2504) were used as reference. 

Super populations:
- African (AFR)
- Admixed American (AMR)
- East Asian (EAS)
- European (EUR)
- South Asian (SAS)


<!--## Marker Set 

Ancestry estimation was based on approximately 700,000 variants that overlapped between TCGA and 1000 Genomes. A complete SNP list is available from [data/supervised_snp_list.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/supervised_snp_list.txt). -->

<!--## PCA

Prinicpal Component Analysis was performed by tissue type (Normal, Tumor, Other) in plink. Estimates for the first 20 PCs are available for download in the data folder. -->

## Main Data 

* [admixture_calls.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/admixture_calls.txt) 
  * ID - TCGA ID
  * POP - dominant super population 
  * EUR:AFR - ADMIXTURE global ancestry estimates for 5 super populations 
  * tissue - tissue type 
* [admixture_calls_se.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/admixture_calls_se.txt) 
  * ID - TCGA ID
  * EUR:AFR - standard errors from 200 boostrapped replicates
  * tissue - tissue type 
* [admixture_calls_by_chr.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/admixture_calls_by_chr.txt)  and [admixture_calls_se_by_chr.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/admixture_calls_se_by_chr.txt) 
  * Contain same information as [admixture_calls.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/admixture_calls.txt) and [admixture_calls_se.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/admixture_calls_se.txt) but also include chromosome for each set of results 

#### Additional Data Resources 

* [entropy.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/entropy.txt)
  * ID - TCGA ID, entropy - Shannon's entropy
* [supervised_snp_list.txt](https://github.com/GerkeLab/TCGAancestry/raw/master/data/supervised_snp_list.txt)
  * Approximately 700,000 variants that overlapped between TCGA and 1000 Genomes used for ancestry estimation 
  * X1 - chromosome, X2 - SNP name, X3 - Position, X4 - base-pair coordinate, X5 - allele 1 (usually minor), X6 - allele 2 (usually major)
  
## Code

* [stepByStep](https://github.com/GerkeLab/TCGAancestry/blob/master/code/stepByStep)
  * contains step by step instructions for downloading/cleaning files and running ADMIXTURE
* [stepByStepSupervised](https://github.com/GerkeLab/TCGAancestry/blob/master/code/stepByStepSupervised)
  * incorporating 1000 Genomes data and performing the supervised analysis

## Collaborators

Jordan Creed 

Konrad Stopsack

Paul Scheets

Travis Gerke

## Contact Information 

Any questions or comments concerning the data or processes described in this repo can be directed to Jordan Creed @ Jordan.H.Creed@moffitt.org or Travis Gerke @ Travis.Gerke@moffitt.org. 
