module load bedtools

#module is-loaded bedtools/2.27.1 && module load bedtools/2.27.1

# INPUTS ##################################################
rep1="narrowPeaks/9-2nd-ID_S7_L002_macs2_peaks.narrowPeak"
#rep2="narrowPeaks/"
rep3="narrowPeaks/377-ID1_S2_L002_macs2_peaks.narrowPeak"
rep4="narrowPeaks/377-ID2_S1_L002_macs2_peaks.narrowPeak"
rep5="narrowPeaks/418-ID1_S1_L002_macs2_peaks.narrowPeak"
rep6="narrowPeaks/418-ID2_S3_L002_macs2_peaks.narrowPeak"
rep7="narrowPeaks/448-ID1_S67_L001_macs2_peaks.narrowPeak"
rep8="narrowPeaks/448-ID2_S78_L001_macs2_peaks.narrowPeak"
rep9="narrowPeaks/455-ID1_S11_L001_macs2_peaks.narrowPeak"
rep10="narrowPeaks/455-ID2_S22_L001_macs2_peaks.narrowPeak"
bed_ctcf="bed_files/C.ID.all.bed"
###########################################################

# Parameters ######################################
narrowThres="0.15"
thres="0.15"
prefix="bed_files/mutationsOnly"
###################################################

bed_9="$prefix"_9_all.bed
bed_377="$prefix"_377_all.bed
bed_418="$prefix"_418_all.bed
bed_448="$prefix"_448_all.bed
bed_455="$prefix"_455_all.bed

# get both replicates combined BED file
# TODO: consider using only the "good" replicate or merge

# Use for single replicates ###
cut -f1-3 "$rep1" > 9_reps_intersected
sort -k1,1 -k2,2n 9_reps_intersected  > 9_reps_sorted
bedtools merge -i 9_reps_sorted  > "$bed_9"

###############################

# For replicates 1 and 2 #############################################################
#bedtools intersect -f "$narrowThres" -r -a "$rep1" -b "$rep2" | cut -f1-3 > 9_reps_intersected
#sort -k1,1 -k2,2n 9_reps_intersected  > 9_reps_sorted
#bedtools merge -i 9_reps_sorted  > "$bed_9"


# For replicates 3 and 4 #############################################################
bedtools intersect -f "$narrowThres" -r -a "$rep3" -b "$rep4" | cut -f1-3 > 377_reps_intersected
sort -k1,1 -k2,2n 377_reps_intersected  > 377_reps_sorted
bedtools merge -i 377_reps_sorted  > "$bed_377"


# For replicates 5 and 6 #############################################################
bedtools intersect -f "$narrowThres" -r -a "$rep5" -b "$rep6" | cut -f1-3 > 418_reps_intersected
sort -k1,1 -k2,2n 418_reps_intersected  > 418_reps_sorted 
bedtools merge -i 418_reps_sorted  > "$bed_418"

# For replicates 7 and 8 #############################################################
bedtools intersect -f "$narrowThres" -r -a "$rep7" -b "$rep8" | cut -f1-3 > 448_reps_intersected
sort -k1,1 -k2,2n 448_reps_intersected  > 448_reps_sorted
bedtools merge -i 448_reps_sorted  > "$bed_448"

# For replicates 9 and 10 #############################################################
bedtools intersect -f "$narrowThres" -r -a "$rep9" -b "$rep10" | cut -f1-3 > 455_reps_intersected
sort -k1,1 -k2,2n 455_reps_intersected  > 455_reps_sorted
bedtools merge -i 455_reps_sorted  > "$bed_455"



# get CTCF Only
#bedtools intersect -v -f "$thres" -a "$bed_ctcf" -b "$bed_9" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_377" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_418" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_448" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_455" > "$prefix"_CTCF_ID_only.bed

# get 9 ID Only
bedtools intersect -v -f "$thres" -a "$bed_9" -b "$bed_ctcf" > "$prefix"_9_ID_only.bed

#bedtools intersect -v -f "$thres" -a "$bed_9" -b "$bed_ctcf" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_377" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_418" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_448" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_455" > "$prefix"_9_ID_only.bed

# get 377 ID Only
bedtools intersect -v -f "$thres" -a "$bed_377" -b "$bed_ctcf" > "$prefix"_377_ID_only.bed

#bedtools intersect -v -f "$thres" -a "$bed_377" -b "$bed_ctcf" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_9" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_418" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_448" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_455"  > "$prefix"_377_ID_only.bed

# get 418 ID Only
bedtools intersect -v -f "$thres" -a "$bed_418" -b "$bed_ctcf" > "$prefix"_418_ID_only.bed

#bedtools intersect -v -f "$thres" -a "$bed_418" -b "$bed_377" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_ctcf" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_9"  | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_448"  | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_455"  > "$prefix"_418_ID_only.bed

# get 448 ID Only
bedtools intersect -v -f "$thres" -a "$bed_448" -b "$bed_ctcf" > "$prefix"_448_ID_only.bed

#bedtools intersect -v -f "$thres" -a "$bed_448" -b "$bed_418" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_377"  | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_ctcf" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_9"  | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_455" > "$prefix"_448_ID_only.bed

# get 455 ID Only
bedtools intersect -v -f "$thres" -a "$bed_455" -b "$bed_ctcf" > "$prefix"_455_ID_only.bed

#bedtools intersect -v -f "$thres" -a "$bed_455" -b "$bed_448" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_418"  | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_377"  | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_ctcf" | \
#	bedtools intersect -v -f "$thres" -a stdin -b "$bed_9" > "$prefix"_455_ID_only.bed

#bed_6all="$prefix"_CTCF_9_377_418_448_455_all.bed

#bedtools intersect -f "$thres" -r -a "$bed_ctcf" -b "$bed_365" | \
#	bedtools intersect -f "$thres" -r -a stdin -b "$bed_377" | \
#	bedtools intersect -f "$thres" -r -a stdin -b "$bed_418" | \
#	bedtools intersect -f "$thres" -r -a stdin -b "$bed_448" | \
#	bedtools intersect -f "$thres" -r -a stdin -b "$bed_455" > "$bed_6all"



#echo "#CTCF_ID_only" >> "$prefix"_CTCF_ID_only.bed

echo "#9_ID_only" >> "$prefix"_9_ID_only.bed
echo "#377_ID_only" >> "$prefix"_377_ID_only.bed
echo "#418_ID_only" >> "$prefix"_418_ID_only.bed
echo "#448_ID_only" >> "$prefix"_448_ID_only.bed
echo "#455_ID_only" >> "$prefix"_455_ID_only.bed

#echo "#CTCF+All_mutations" >> "$bed_6all"

cat "$prefix"_9_ID_only.bed "$prefix"_377_ID_only.bed "$prefix"_418_ID_only.bed "$prefix"_448_ID_only.bed "$prefix"_455_ID_only.bed > "$prefix"_deeptools_5_groups

#cat "$prefix"_CTCF_ID_only.bed \
#"$prefix"_365_ID_only.bed \	
#"$prefix"_377_ID_only.bed \
#"$prefix"_418_ID_only.bed \
#"$prefix"_448_ID_only.bed \
#"$prefix"_455_ID_only.bed \
#"$bed_6all" > "$prefix"_deeptools_7_groups

sbatch heatmap_deeptools.sh "$prefix"_deeptools_5_groups "$prefix"
