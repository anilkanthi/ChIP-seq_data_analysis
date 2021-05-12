mkdir fastq_2020_01_31

mkdir igors_pipeline
cd igors_pipeline/
module add git
git clone --depth 1 https://github.com/igordot/sns
sns/generate-settings mm10
sns/gather-fastqs /gpfs/data/skoklab/home/kantha01/CHIP_Seq/super_enhancer_analysis/FASTQ/
sns/run chip

#OR


ls *_R1_001.fastq.gz| sed 's/_R1_001.fastq.gz//g' > file_names.txt

bash fastq_to_bw.sh
bash bigwig_generate.sh

#narrowPeak to BED file
awk '{print $1"\t"$2"\t"$3}' 9-2nd-ID_S7_L002_macs2_peaks.narrowPeak > 9-ID2_macs2_peaks.bed

#Intersect the current samples (Ex:377 ID1 and ID2)
bedtools intersect -f .25 -r -a 9-ID1_macs2_peaks.bed -b 9-ID2_macs2_peaks.bed > inter9_ID.bed

#Intersect Step 2 CTCF output file with each samples output from Step 3
intersect -f 0.25 -r -u -a /gpfs/data/skoklab/home/kantha01/CHIP_Seq/CTCF_WT/Flag-CTCF/narrowPeak_to_BED_WT/interCTCF_ID.bed -b inter9_ID.bed > interCTCF_9_ID.bed

#Combine each Mutant (Current Sample) Step 1 output
cat 9-ID1_macs2_peaks.bed 9-ID2_macs2_peaks.bed > 9_ID_union.bed

#Sort the combined (Union) BED files of each
sort -k1,1 -k2,2n 9_ID_union.bed > 9_ID_sort.bed

#Merge the sorted BED files of each
bedtools merge -i 9_ID_sort.bed > 9_ID_merged.bed
FLAG_BED_FILES=/gpfs/data/skoklab/home/shared-ali-anil/peaks/ $FLAG_BED_FILES

#COMBINE all the required BED files along with .txt files for Deeptools
cat $FLAG_BED_FILES/C.ID.only.bed $FLAG_BED_FILES/CB.common.bed $FLAG_BED_FILES/C_B_Common $FLAG_BED_FILES/B.D.only.bed $FLAG_BED_FILES/BORIS_Only CTCF_ID_specific_vs9_D.bed $FLAG_BED_FILES/9_D_Only CTCF_ID_specific_vs9_ID.bed $FLAG_BED_FILES/9_ID_Only > CTCF_BORIS_vs_9_D_ID.bed

bash heatmap_deeptools.sh




