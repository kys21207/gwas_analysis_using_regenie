#!/bin/bash 

input_dir="/home/jovyan/session_data/sle_gwas_results/mixed"
out_dir="/home/jovyan/session_data/sle_gwas_results/mixed"

pheno_list=("sle_diag")

# Loop over each trait
for trait in "${pheno_list[@]}"; do
    echo "Combining results for $trait"

    # Create an output file for the combined results
    output_file="${out_dir}/sle_${trait}.regenie"

    # Remove the output file if it already exists
    rm -f "$output_file"

    # Combine the Regenie result files for all 22 chromosomes
    for chr in {1..22}; do
        input_file="${input_dir}/sle_chr${chr}_${trait}.regenie"
        
        # Append the content of the chromosome file to the output file
        # Assuming first file contains header, we skip header from other files
        if [ "$chr" -eq 1 ]; then
            cat "$input_file" >> "$output_file"
        else
            tail -n +2 "$input_file" >> "$output_file"
        fi
    done

    echo "Results combined for $trait into $output_file"
done


