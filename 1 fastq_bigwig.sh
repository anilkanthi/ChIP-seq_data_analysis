
#!/bin/bash -l
#SBATCH -J gen.bams.pks.bw
#SBATCH --mem=90G
#SBATCH --time=48:00:00
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --array=1-16

######
module load bowtie2/2.3.4.1
module load samtools/1.9
module load picard-tools/1.88
module unload python
module load perl
module load bedtools
module unload python

cd /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31

# Create file_names.txt manually in the FASTQ folder -->
#ls *_R1_001.fastq.gz| sed 's/_R1_001.fastq.gz//g'

#####################################################################
sample=$(awk "NR==${SLURM_ARRAY_TASK_ID} {print \$1}" file_names.txt)
#####################################################################

genome=mm10

#### Map reads to reference genome
bowtie2 --no-discordant -p 12 --no-mixed -N 1 -X 2000 --un unaligned_${sample}.sam -x /gpfs/data/skoklab/home/shared-ali-anil/ref_data/ref/${genome}/bowtie2.index/${genome} -1 ${sample}_R1_001.fastq.gz -2 ${sample}_R2_001.fastq.gz -S ${sample}.sam > bowtie_${sample}.out

####Filter chrom M and other weird chromosomes
sed '/chrM/d;/random/d;/alt/d;/chrUn/d' < ${sample}.sam > ${sample}_filtered.sam

####Run Samtools to convert SAM to BAM and filter for reads that have quality >30
samtools view -b -q 30 -h ${sample}_filtered.sam -o ${sample}_q30.bam

####Sort BAM File
samtools sort ${sample}_q30.bam -o ${sample}_q30_sorted.bam

####Remove Sequence Duplicates
java -Xmx1g -jar ${PICARD_ROOT}/MarkDuplicates.jar INPUT=${sample}_q30_sorted.bam OUTPUT=${sample}_q30_rmdup_sorted.bam METRICS_FILE=metrics_${sample}.txt REMOVE_DUPLICATES=true ASSUME_SORTED=true

###Index BAM file to obtain .bai files
samtools index -b ${sample}_q30_rmdup_sorted.bam

####Sort BAM file by read name
#samtools sort ${sample}.bam -o ${sample}_sorted.bam

#samtools merge

###Call Peaks with MACS2
module load macs2/2.1.1

#set -g parameter according the genome (2.7e9 = human, 1.87e9 = mouse)
macs2 callpeak -t ${sample}_q30_rmdup_sorted.bam -f AUTO -n ${sample}_macs2 -g 1.87e9 --qvalue 0.01 --nomodel --shift 0 -B --call-summits --outdir /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks

###Generate BigWigs
module unload python
module load python/cpu/2.7.15
module unload python
module load deeptools/3.1.0
module load samtools/1.9
bamCoverage -b ${sample}_q30_rmdup_sorted.bam --normalizeUsing RPKM -o ${sample}_rpkm.bw
