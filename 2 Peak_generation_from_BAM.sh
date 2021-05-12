#!/bin/bash -l
#SBATCH -J gen.bams.pks.bw
#SBATCH --mem=90G
#SBATCH --time=2-00:00:00
#SBATCH --array=1-10
#SBATCH -N 1
#SBATCH -c 12


###### Use for the Merged and Indexed BAM files from fastq_bigwig.sh

module load macs2/2.1.1

cd /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/BAM-DD


#ll *1_macs2*.xls | awk '{print $9}' | sed 's/1_macs2_peaks.xls//g' > file_names.txt

#ls *1.dd.bam| sed 's/1.dd.bam//g'

#####################################################################
sample=$(awk "NR==${SLURM_ARRAY_TASK_ID} {print \$1}" file_names.txt)
#####################################################################

###Call Peaks with MACS2

#set -g parameter according the genome (2.7e9 = human, 1.87e9 = mouse)

macs2 callpeak -t ${sample}_q30_rmdup_sorted.bam -f AUTO -n ${sample}_macs2 -g 1.87e9 --qvalue 0.01 --nomodel --shift 0 -B --call-summits \
--outdir /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks