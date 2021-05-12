#!/bin/bash -l
#SBATCH -J merge.bam
#SBATCH --mem=90G
#SBATCH --time=2-00:00:00
#SBATCH --array=1-10
#SBATCH -N 1
#SBATCH -c 12


######

module load samtools

cd ../BAM-DD


# generate file_name # did it manually becuase file names are different. non of this worked. 
#ll *.bam | awk '{print $9}' | sed 's/.dd.bam//g' > file_names.txt
#ll *R1* | awk '{print $9}' | sed 's/fastq.gz//g' > file_names2.txt
#ll *R1* | awk '{print $9}' | sed 's/.fastq.gz//g'
#ll *R1* | awk '{print $9}'  > file_names2.txt

#ll *1.dd.bam | awk '{print $9}' | sed 's/1.dd.bam//g' > file_names2.txt

#####################################################################
#sample=$(awk "NR==${SLURM_ARRAY_TASK_ID} {print \$1}" file_names.txt)


## merge replicates of bam files. 
#samtools merge ${sample}-merged.dd.bam ${sample}1.dd.bam ${sample}2.dd.bam

#1 377 D
#2 377 ID
#3 9 D
#4 9 ID

samtools merge Rad21-ChIP_BBC_ID-merged.dd.bam Rad21_ChIP_BBC_ID1.dd.bam Rad21-ChIP_BBC_ID2.dd.bam
samtools merge Rad21-ChIP_BCC_ID-merged.dd.bam Rad21-ChIP_BCC_ID1.dd.bam Rad21_ChIP_BCC_ID2.dd.bam



