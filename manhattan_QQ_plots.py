import gwaslab as gl
# load plink2 output
dta1 = gl.Sumstats("/home/jovyan/session_data/gwas_combined_results/ms_ms_all_comers_combined.regenie", fmt="regenie")
dta2 = gl.Sumstats("/home/jovyan/session_data/gwas_combined_results/All_ms_all_comers_combined.regenie", fmt="regenie")


# Specify the genome build
dta1.set_build("38")
dta2.set_build("38")

# Download and process GTF files
gtf_path = gl.download_ref("ensembl_hg38_gtf")

# Extract GTF attributes
gtf_data = gl.extract_gtf(gtf_path)

# load sumstats with auto mode (auto-detecting common headers) 
# assuming ALT/A1 is EA, and frq is EAF
#mysumstats = gl.Sumstats("t2d_bbj.txt.gz", fmt="auto")

#mysumstats.basic_check()
#mysumstats.fill_data(to_fill=["P"], extreme=True)
# Check data
#mysumstats.data
# Plot with MLOG{
#mysumstats.plot_mqq(save="/home/jovyan/session_data/summary_plots/ms_gwas_regenie_plot.png", save_args={"dpi":400,"facecolor":"white"},skip =1,scaled=True)

dta1.basic_check()
dta2.basic_check()

dta1.fill_data(to_fill=["P"], extreme=True)
dta2.fill_data(to_fill=["P"], extreme=True)

#gl.plot_stacked_mqq(objects=[dta1,dta2],
#                    mode="m",
#                    skip=3,
#                    titles=["IA","Pipeline"],
#                    save="/home/jovyan/session_data/summary_plots/ms_all_comers_gwas_regenie_stacked_plot.png", 
#                    save_args={"dpi":400,"facecolor":"white"})

dta1.plot_mqq(mode="r",region=(13,99194000,99400000),anno_set=["13:99374698_A_C"],save="/home/jovyan/session_data/summary_plots/ms_all_comers_mixed_GPR183.png")
dta2.plot_mqq(mode="r",region=(13,99194000,99400000),anno_set=["13:99374698_A_C"],save="/home/jovyan/session_data/summary_plots/ms_all_comers_cox_GPR183.png")

