#!/bin/bash
#SBATCH -J deeptools
#SBATCH --mem=96G
#SBATCH --time=48:00:00
#SBATCH -N 1
​

cd /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks/data_deeptools/heatmap_profiles

module purge
module load deeptools/3.1.0
​

BED="/gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks/data_deeptools/CTCF_vs_377/CTCF_Flag_vs_377_ID.bed"

group_plot(){

computeMatrix reference-point --referencePoint center --scoreFileName ${BW_1} ${BW_2} ${BW_3} --regionsFileName ${BED} --sortRegions descend --sortUsingSamples 1 --outFileName ${OUTPUT_FILE_PREFIX}_matrix.gz --missingDataAsZero --beforeRegionStartLength ${Midpoint} --afterRegionStartLength ${Midpoint}

plotHeatmap --matrixFile ${OUTPUT_FILE_PREFIX}_matrix.gz --outFileName ${OUTPUT_FILE_PREFIX}_heatmap.pdf --colorMap ${color} --heatmapHeight 50 --sortRegions descend --sortUsingSamples 1 --legendLocation none --whatToShow 'heatmap and colorbar' --zMin ${zMin} --zMax ${zMax}

plotProfile --matrixFile ${OUTPUT_FILE_PREFIX}_matrix.gz --outFileName ${OUTPUT_FILE_PREFIX}_pergroupprofilePlot.pdf --colors red darkred blue darkblue green darkgreen --legendLocation 'upper-center' --yMin ${y_scale_min} --yMax ${y_scale_max} --perGroup
plotProfile --matrixFile ${OUTPUT_FILE_PREFIX}_matrix.gz --outFileName ${OUTPUT_FILE_PREFIX}_profilePlot.pdf --colors red blue green --legendLocation 'upper-center' --yMin ${y_scale_min} --yMax ${y_scale_max}
}

###3kb###
RUNDIR=/gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks/data_deeptools/heatmap_profiles
Midpoint=3000
y_scale_min=0
y_scale_max=20
color=Purples
zMin=0
zMax=10
​
BW_1="/gpfs/data/skoklab/home/shared-ali-anil/Flag-chip-from-paper/merged_bigwigs/BORIS_CTCF/Flag_ChIP_CTCF_2i_ID_mergeR2R3.bw"
BW_2="/gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/BIGWIG_MERGED_BAM/377_D_rpkm.bw"
BW_3="/gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/BIGWIG_MERGED_BAM/377_ID_rpkm.bw"
#BW_4="/gpfs/data/skoklab/home/shared-ali-anil/Flag-chip-from-paper/merged_bigwigs/BORIS_CTCF/Flag_ChIP_BOR_2i_ID_mergeR2R3.bw"
#BW_5="/gpfs/data/skoklab/home/shared-ali-anil/Flag-chip-from-paper/merged_bigwigs/BORIS_CTCF/Flag_ChIP_BOR_2i_D_mergeR2R3.bw"
#BW_6="/gpfs/data/skoklab/home/shared-ali-anil/Flag-chip-from-paper/merged_bigwigs/BORIS_CTCF/Flag_ChIP_BOR_2i_D_mergeR2R3.bw"
​
cd ${RUNDIR}
OUTPUT_FILE_PREFIX="CTCF_FLAG_377_D_ID_ONLY_D1"
group_plot