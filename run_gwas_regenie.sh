#!/bin/bash 
# Exit immediately if a command exits with a non-zero status and print the error
set -e
# Define a function to capture and handle the error
error_handler() {
    echo "Error occurred on line $1. Exiting the script."
}
trap 'error_handler $LINENO' ERR #trap errors and call error_handler with the line

# Set variables for input files
geno_dir="/home/jovyan/session_data/filesystems/merged_arrays"  # Directory containing imputed genotype files for 22 chromosomes
pheno_file="pheno/ibd_phenotypes_for_regenie_0_1_coding.txt"       # File with phenotypes (one per column)
covar_file="pheno/ibd_phenotypes_for_regenie_0_1_coding.txt"       # File with covariates (like age, sex, etc.)
bsize=1000                                # Set block size for step 2


# Set up output directory
out_dir="/home/jovyan/session_data/ibd_gwas_results"
mkdir -p $out_dir

# list of phenotypes
pheno_event="dx_ibd_all_comers,dx_crohns"
pheno_time="ibd_age,crohns_age"
# list of covariates
covar_list="PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,gender_coded,bmi"

# run Regenie Step 1 for all chromosomes
    regenie \
    --step 1 \
    --t2e \
    --bed /home/jovyan/session_data/filesystems/for_regenie/gsa_pmra_imputed_regenie_step1_set_no_dupes \
    --extract /home/jovyan/session_data/filesystems/for_regenie/gsa_pmra_imputed_regenie_step1_set_no_dupes.snpids \
    --phenoFile ${pheno_file} \
    --phenoColList ${pheno_time} \
    --eventColList ${pheno_event} \
    --covarFile ${covar_file} \
    --covarColList ${covar_list} \
    --bsize 1000 \
    --cv 5 \
    --bt \
    --lowmem \
    --lowmem-prefix /home/jovyan/session_data/tmpdir/regenie_tmp_preds \
    --out ibd_fit_bin_multi_out 

echo "Step 1 completed for all chromosomes."


# Loop through all chromosomes and run Regenie Step 2 for each chromosome
for chr in {1..22}; do
    echo "Running GWAS on Chromosome $chr"

    # Define the file paths for each chromosome
    bgen_file="${geno_dir}/gsa_pmra_imputed_chr${chr}_maf01_rsq8_geno01_ipn_id_excluded_array_assoc_for_regenie.bgen"  # BGEN file for chromosome
    sample_file="${geno_dir}/gsa_pmra_imputed_chr${chr}_maf01_rsq8_geno01_ipn_id_excluded_array_assoc_for_regenie.sample"  # Sample file for chromosome (optional depending on BGEN file format)

        
    # Run Regenie Step 2
        regenie \
        --step 2 \
        --t2e \
        --bgen ${bgen_file} \
        --sample ${sample_file} \
        --phenoFile ${pheno_file} \
        --phenoColList ${pheno_time} \
        --eventColList ${pheno_event} \
        --covarFile ${covar_file} \
        --covarColList ${covar_list} \
        --bt \
        --bsize ${bsize} \
        --firth --approx \
        --pThresh 0.01 \
        --pred ibd_fit_bin_multi_out_pred.list \
        --out ${out_dir}/ibd_chr${chr} 
done

echo "GWAS completed for all chromosomes."


