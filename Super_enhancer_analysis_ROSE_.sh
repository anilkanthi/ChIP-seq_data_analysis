module load samtools r/3.6.1

cd /gpfs/data/skoklab/home/kantha01/CHIP_Seq/super_enhancer_analysis/ROSE

# Peak calling
macs2 callpeak \
-t H3K27ac-D-1_S5_q30_rmdup_sorted.bam H3K27ac-D-2_S6_q30_rmdup_sorted.bam \
-f AUTO \
-n H3K27ac-D_macs2 \
-g 1.87e9 \
--qvalue 0.01 \
--nomodel \
--shift 0 \
-B --call-summits \
--outdir /gpfs/data/skoklab/home/kantha01/CHIP_Seq/super_enhancer_analysis/FASTQ/BAM_rmdup/

# Convert narrowPeaks to GFF
awk '{print $1"\t"$4"\t"".""\t"$2"\t"$3"\t"".""\t"".""\t"".""\t"$4}' H3K27ac-I_macs2_peaks.narrowPeak > H3K27ac-I_macs2_peaks.gff

# Merge replicate BAM files
samtools merge H3K27ac-UI_MERGED.bam H3K27ac-U-1_S1_q30_rmdup_sorted.bam H3K27ac-U-2_S2_q30_rmdup_sorted.bam

# ROSE Main script
python ROSE_main.py \
-g MM10 -i H3K27ac-D_macs2_peaks.gff \
-r /gpfs/data/skoklab/home/kantha01/CHIP_Seq/super_enhancer_analysis/FASTQ/BAM_rmdup/H3K27ac-D_MERGED.bam \
-c /gpfs/data/skoklab/home/kantha01/CHIP_Seq/super_enhancer_analysis/FASTQ/BAM_rmdup/H3K27ac-UI_MERGED.bam \
-s 12500 \
-t 2500 \
-o bowtie_combinedMacs2_ROSE_output_files

# ROSE Annotation
python ROSE_geneMapper.py \
-g MM10 \
-i I_bowtie_combinedMacs2_ROSE_output_files/H3K27ac-I_macs2_peaks_SuperEnhancers.table.txt \
-o geneMapper_result_UI_vs_I"