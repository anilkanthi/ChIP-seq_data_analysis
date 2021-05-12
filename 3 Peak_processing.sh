module load bedtools

awk '{print $1"\t"$2"\t"$3}' Flag_ChIP_BOR_2i_ID2_S30_L008_macs2_peaks.narrowPeak >  BORIS-ID2_macs2_peaks.bed
awk '{print $1"\t"$2"\t"$3}' Flag_ChIP_BOR_2i_1D3_S39_L005_macs2_peaks.narrowPeak  >  BORIS-ID3_macs2_peaks.bed

Do the same to get Flag_ChIP_CTCF_2i_ID2_macs2_peaks.bed and Flag_ChIP_CTCF_2i_ID3_macs2_peaks.bed

awk '{print $1"\t"$2"\t"$3}' 9-ID_S6_L002_macs2_peaks.narrowPeak > 9-ID1_macs2_peaks.bed
awk '{print $1"\t"$2"\t"$3}' 9-2nd-ID_S7_L002_macs2_peaks.narrowPeak > 9-ID2_macs2_peaks.bed

bedtools intersect -f 0.25 -r -a  Flag_ChIP_CTCF_2i_ID2_macs2_peaks.bed -b  Flag_ChIP_CTCF_2i_ID3_macs2_peaks.bed   > interCTCF_ID.bed
bedtools intersect -f 0.25 -r -a BORIS-ID2_macs2_peaks.bed -b BORIS-ID3_macs2_peaks.bed   > interBORIS_ID.bed
bedtools intersect -f 0.25 -r -a  9-ID1_macs2_peaks.bed -b  9-ID2_macs2_peaks.bed > inter9_ID.bed

bedtools intersect -f 0.25 -r -u -a interCTCF_ID.bed -b inter9_ID.bed > interCTCF_9_ID.bed
    bedtools intersect -v -a interCTCF_9_ID.bed -b interBORIS_ID.bed > interCTCF_9_ID_Minus_BORIS.bed
        bedtools intersect -f 0.25 -r -u -a interCTCF_9_ID.bed -b interBORIS_ID.bed > C_B_9_Common.bed
bedtools intersect -f 0.25 -r -u -a interBORIS_ID.bed -b inter9_ID.bed > interBORIS_9_ID.bed
    bedtools intersect -v -a interBORIS_9_ID.bed  -b interCTCF_ID.bed > interBORIS_9_ID_Minus_CTCF.bed
?

cat Flag_ChIP_CTCF_2i_ID2_macs2_peaks.bed  Flag_ChIP_CTCF_2i_ID3_macs2_peaks.bed > Flag_ChIP_CTCF_ID_union.bed
cat BORIS-ID2_macs2_peaks.bed BORIS-ID3_macs2_peaks.bed > Flag_ChIP_BORIS_ID_union.bed
cat 9-ID1_macs2_peaks.bed 9-ID2_macs2_peaks.bed > 9_ID_union.bed

sort -k1,1 -k2,2n Flag_ChIP_CTCF_ID_union.bed > Flag_ChIP_CTCF_ID_sort.bed
sort -k1,1 -k2,2n Flag_ChIP_BORIS_ID_union.bed > Flag_ChIP_BORIS_ID_sort.bed
sort -k1,1 -k2,2n 9_ID_union.bed > 9_ID_sort.bed

bedtools merge -i Flag_ChIP_CTCF_ID_sort.bed > Flag_ChIP_CTCF_ID_merged.bed
bedtools merge -i Flag_ChIP_BORIS_ID_sort.bed > Flag_ChIP_BORIS_ID_merged.bed
bedtools merge -i 9_ID_sort.bed > 9_ID_merged.bed

bedtools intersect -v -a interCTCF_ID.bed -b 9_ID_merged.bed > CTCF_ID_Specific_vs_9_ID.bed
    bedtools intersect -v -a CTCF_ID_Specific_vs_9_ID.bed -b Flag_ChIP_BORIS_ID_merged.bed > CTCF_ID_Specific_vs_9_ID_minus_BORIS_ID.bed
    
bedtools intersect -v -a interBORIS_ID.bed -b 9_ID_merged.bed > BORIS_ID_Specific_vs_9_ID.bed
    bedtools intersect -v -a BORIS_ID_Specific_vs_9_ID.bed -b Flag_ChIP_CTCF_ID_merged.bed > BORIS_ID_Specific_vs_9_ID_minus_CTCF_ID.bed
    
bedtools intersect -v -a inter9_ID.bed -b Flag_ChIP_CTCF_ID_merged.bed > 9_ID_specific.bed

bedtools intersect -v -a inter9_ID.bed -b Flag_ChIP_CTCF_ID_merged.bed > 9_ID_specific_minus_CTCF.bed
    bedtools intersect -v -a 9_ID_specific_minus_CTCF.bed  -b Flag_ChIP_BORIS_ID_merged.bed > 9_ID_specific_minus_CTCF_minus_BORIS.bed


bedtools intersect -f 0.25 -r -u -a interCTCF_ID.bed -b interBORIS_ID.bed > CTCF_BORIS_intersect_25.bed
    bedtools intersect -v -a CTCF_BORIS_intersect_25.bed -b inter9_ID.bed > CTCF_BORIS_common_Minus_9_ID.bed
    

cat CTCF_ID_Specific_vs_9_ID_minus_BORIS_ID.bed CTCF_Only  BORIS_ID_Specific_vs_9_ID_minus_CTCF_ID.bed CTCFL_Only  CTCF_BORIS_common_Minus_9_ID.bed CTCF_CTCFL_Common  9_ID_specific_minus_CTCF_minus_BORIS.bed De_novo_6_7 interCTCF_9_ID_Minus_BORIS.bed CTCF_6_7 interBORIS_9_ID_Minus_CTCF.bed CTCFL_6_7 C_B_9_Common.bed CTCF_CTCFL_6_7 > groups_7.bed








































##### IMPORTANT --> CREATE FLAG CTCF/BORIS INTERMEDIATE FILES USING THE 3 REFERENCE BED FILES

### Get the peaks present in both replicates for either WT or Mutant CTCF using bedtools intersect
# I -->
srun -t 0-10 --pty bash
module load bedtools

awk '{print $1"\t"$2"\t"$3}' 9D_S5_L002_macs2_peaks.narrowPeak > 9-D1_macs2_peaks.bed

#bedtools intersect -f .25 -r -a  Flag_ChIP_CTCF_2i_ID2_macs2_peaks.bed   -b  Flag_ChIP_CTCF_2i_ID3_macs2_peaks.bed   > interCTCF_ID.bed

# II -->
bedtools intersect -f .25 -r -a 9-ID1_macs2_peaks.bed -b 9-ID2_macs2_peaks.bed > inter9_ID.bed

# III -->
# get the 365-ID specific peaks: be stringent: found in both replicates in 365 and in no replicates in WT:
#substract 41687 Flag_ChIP_CTCF_ID_merged.bed from 34515 inter365_ID.bed by doing the -v option.

bedtools intersect -v -a inter9_D.bed -b /gpfs/data/skoklab/home/kantha01/CHIP_Seq/CTCF_WT/Flag-CTCF/narrowPeak_to_BED_WT/Flag_ChIP_CTCF_ID_merged.bed  > 9_D_specific.bed


# IV -->
bedtools intersect -f 0.25 -r -u -a /gpfs/data/skoklab/home/kantha01/CHIP_Seq/CTCF_WT/Flag-CTCF/narrowPeak_to_BED_WT/interCTCF_ID.bed -b inter9_ID.bed  > interCTCF_9_ID.bed

# V -->
Those are the peaks that are found in all replicates for each mutation: the stable ones between mutant and WT CTCF.
#### using bedtools intersect, get the peaks that are present in WT only, Mutant only or both. Do it for each mutation.
### 1st thing, get the union of WT and Mutant peaks
#get the union peaks

#cat Flag_ChIP_CTCF_2i_ID2_macs2_peaks.bed  Flag_ChIP_CTCF_2i_ID3_macs2_peaks.bed > Flag_ChIP_CTCF_ID_union.bed
cat 9-ID1_macs2_peaks.bed 9-ID2_macs2_peaks.bed > 9_ID_union.bed

# VI -->
#Then use sort the concatenated file and merge using bedtools:
#sort -k1,1 -k2,2n Flag_ChIP_CTCF_ID_union.bed > Flag_ChIP_CTCF_ID_sort.bed
sort -k1,1 -k2,2n 9_ID_union.bed > 9_ID_sort.bed

# VII -->

#bedtools merge -i Flag_ChIP_CTCF_ID_sort.bed > Flag_ChIP_CTCF_ID_merged.bed
bedtools merge -i 9_ID_sort.bed > 9_ID_merged.bed

# VIII -->
### get the WT CTCF specific peaks as compared to each mutation
#Subtract 43422 365_ID_merged.bed from 34368 interCTCF_ID.bed by doing the -v option.

bedtools intersect -v -a /gpfs/data/skoklab/home/kantha01/CHIP_Seq/CTCF_WT/Flag-CTCF/narrowPeak_to_BED_WT/interCTCF_ID.bed   -b  9_ID_merged.bed  > CTCF_ID_specific_vs9_ID.bed

# IX --> # WHEN COMPARING CTCF with a sample | CTCF_Only, CTCF_377_Common, 377_Only
#### prepare the bed files to do heatmaps and average profiles
# Create new folder (Ex: 9_vs_CTCF_BORIS) | Create new .txt files according to the requirement for heatmap Y-axis | Move files to new folder
#cat WT_ID_specific_vs365.bed WT.txt interCTCF_365_ID.bed Common.txt 365_ID_specific.bed Mut.txt > WTvs365_3groups.bed

FLAG_BED_FILES=/gpfs/data/skoklab/home/shared-ali-anil/peaks/

#When comparing CTCF_only, C_B_Common, BORIS_only, 9_D, 9_ID
cat $FLAG_BED_FILES/C.ID.only.bed $FLAG_BED_FILES/CB.common.bed $FLAG_BED_FILES/C_B_Common $FLAG_BED_FILES/B.D.only.bed $FLAG_BED_FILES/BORIS_Only 9_D_specific.bed $FLAG_BED_FILES/9_D_Only 9_ID_specific.bed $FLAG_BED_FILES/9_ID_Only > CTCF_BORIS_vs_9_D_ID.bed