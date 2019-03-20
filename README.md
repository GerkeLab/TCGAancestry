# TCGAancestry
Global ancestry estimates for the TCGA panCancer cohort from ADMIXTURE

<!-- README start -->

## Summary

[ADMIXTURE](http://software.genetics.ucla.edu/admixture/) ancestry estimates from 5 "super populations" were calculated for 22,963 TCGA samples. 

## Samples

22,963 samples from 11,127 TCGA participants were analyzed. Samples spanned 9 tissues (predominantly primary solid tumors and blood derived normal) and over 30 cancers. Of the participants 10,870 were part of the [Pan-Cancer](https://www.cell.com/pb-assets/consortium/pancanceratlas/pancani3/index.html) cohort (N=10,956). 

## Supervised Analsyis 

TCGA samples were merged 1000 Genomes Phase 3 samples in order to perform supervised analysis. The reference population had ancestries from 5 "super populations":
- African (AFR)
- Admixed American (AMR)
- East Asian (EAS)
- European (EUR)
- South Asian (SAS)

For more information on these popualtions and a more in-depth look at the populations making up these super populations please visit [1000 Genomes](http://www.internationalgenome.org/category/population/).

## Marker Set 
Over 700,000 variants, that were shared bewteen TCGA and 1000 Genomes genotyping, were involved. A complete SNP list is available in the data folder (supervised_snp_list.txt). 

## PCA

Prinicpal Component Analysis was performed by tissue type (Normal, Tumor, Other) in plink. Estimates for the first 20 PCs are available for download in the data folder. 

## Data 

* admixture_calls.txt 
  * ID - TCGA ID
  * POP - dominant super population 
  * EUR:AFR - ADMIXTURE global ancestry estimates for 5 super populations 
  * tissue - tissue type 
* admixture_calls_se.txt 
  * ID - TCGA ID
  * EUR:AFR - standard errors from 200 boostrapped replicates
  * tissue - tissue type 
* supervised_snp_list.txt
  * X1 - chromosome
  * X2 - SNP name
  * X3 - Position
  * X4 - base-pair coordinate
  * X5 - allele 1 (usually minor)
  * X6 - allele 2 (usually major)
  
## Code

* stepByStep
  * contains step by step instructions for downloading/cleaning files and running ADMIXTURE
* stepByStepSupervised
  * incorporating 1000 Genomes data and performing the supervised analysis

## Collaborators

Jordan Creed
Travis Gerke

## Contact Information 

Any questions or comments concerning the data or processes described in this repo can be directed to Jordan Creed @ Jordan.H.Creed@moffitt.org. 
