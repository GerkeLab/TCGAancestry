# Prepping 1000 genomes files 

1. Convert from VCF to plink format (ped and map) 

VCFs were converyed to plink as ADMIXTURE takes plink binary files as input 

<!--- error with original chr 1 vcf so had to remove problematic line and rerun on 22/26/2018 -->

```
vcftools --gzvcf /share/NGS/public/1000_genomes_p3/ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --snps /share/lab_gerke/panCancer/data/intermediateData/tcga_snps.txt --plink --out /share/lab_gerke/panCancer/data/1000genomes/chr1.filtered.genotypes

for chr in {2..22}; do echo "module load vcftools; vcftools --gzvcf /share/NGS/public/1000_genomes_p3/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --snps /share/lab_gerke/panCancer/data/intermediateData/tcga_snps.txt --plink --out /share/lab_gerke/panCancer/data/1000genomes/chr${chr}.filtered.genotypes" | qsub -d. -l mem=64G -l walltime=100:00:00 -N 1000g_subs ; done

```

2. Covert from plink ped and map to binary

```
plink --file /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/chr1.filtered.genotypes --make-bed --out /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_chr1

for chr in {2..22}; do echo "module load plink/1.90b; plink --file /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/chr${chr}.filtered.genotypes --make-bed --out /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_chr${chr}" | qsub -d. -l mem=64G -l walltime=100:00:00 -N 1000g_subs_convert ; done
```

3. Exclude snp with multiple alleles (non-biallelic)


<!--- plink --bfile /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_chr8 --exclude 1000g_subset-merge.missnp --make-bed --out /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_chr8v2 -->

```
for chr in {1..22}; do echo "module load plink/1.90b; plink --bfile /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_chr${chr} --exclude 1000g_subset-merge.missnp --make-bed --out /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_chr${chr}v2" | qsub -d. -l mem=64G -l walltime=100:00:00 -N 1000g_biall ; done
```

# Merge 1000 genomes chromosomes

1. More file prep

On the 1000 genomes side: 
```
plink --bfile /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_v2 --exclude /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g.missnp --make-bed --out /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_v3
```

On the TCGA side: 
```
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_other_binary_v7 --exclude /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g.missnp --make-bed --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_other_binary_v8

plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_tumor_binary_v7 --exclude /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g.missnp --make-bed --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_tumor_binary_v8

plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_normal_binary_v7 --exclude /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g.missnp --make-bed --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_normal_binary_v8
```

2. Merge with TCGA 

```
plink --bfile /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_v3 --bmerge /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_other_binary_v8 --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g

plink --bfile /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_v3 --bmerge /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_tumor_binary_v8 --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_tumor_1000g

plink --bfile /share/lab_gerke/panCancer/data/1000genomes/vcftools_subsets/1000g_subset_v3 --bmerge /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/geno_matrix_normal_binary_v8 --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_normal_1000g
```

3. Remove snps with more than 10% missing - helps filter out any snps that were only measured in tcga or 1000g or just a bad snp

```
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g --geno --make-bed --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g_v2

plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_tumor_1000g --geno --make-bed --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_tumor_1000g_v2

plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_normal_1000g --geno --make-bed --out /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_normal_1000g_v2
```

# Run ADMIXTURE

```
echo "module add admixture; admixture --cv -B /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g_v2.bed 5 -j4 --supervised" | qsub -d. -l walltime=999:00:00 -N supervised_other

echo "module add admixture; admixture --cv -B /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_tumor_1000g_v2.bed 5 -j4 --supervised" | qsub -d. -l walltime=999:00:00 -N supervised_tumor

echo "module add admixture; admixture --cv -B /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_normal_1000g_v2.bed 5 -j4 --supervised" | qsub -d. -l walltime=999:00:00 -N supervised_normal
```

# Run PCA

```
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_other_1000g_v2 --pca
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_tumor_1000g_v2 --pca
plink --bfile /share/lab_gerke/panCancer/data/intermediateData/supervised_subsets/tcga_normal_1000g_v2 --pca
```