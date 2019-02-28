# TCGAancestry
Global ancestry estimates for the TCGA panCancer cohort from ADMIXTURE

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
Over 700,000 variants, that were shared bewteen TCGA and 1000 Genomes genotyping, were involved. A complete SNP list is available in the data folder. 

## PCA

Prinicpal Component Analysis was performed by tissue type (Normal, Tumor, Other) in plink. Estimates for the first 20 PCs are available for download in the data folder. 

## Data 

## Code

## Collaborators

Jordan Creed, Anders Berglund and Travis Gerke

## Contact Information 

Any questions or comments concerning the data or processes described in this repo can be directed to Jordan Creed @ Jordan.H.Creed@moffitt.org. 
