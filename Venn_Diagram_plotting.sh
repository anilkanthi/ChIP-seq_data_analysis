# 3-way Venn Diagram:


# Common between inter_9_ID and CTCF ID ONLY -->
bedtools intersect -f .25 -r -a /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks/data_deeptools/9_vs_CTCF_BORIS/inter9_ID.bed -b C.ID.only.bed > a.bed

# Common between inter_9_ID and BORIS D ONLY -->
bedtools intersect -f .25 -r -a /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks/data_deeptools/9_vs_CTCF_BORIS/inter9_ID.bed -b B.D.only.bed > b.bed

# Common between inter_9_ID, CTCF ID ONLY and BORIS D ONLY -->
bedtools intersect -f .25 -r -a /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks/data_deeptools/9_vs_CTCF_BORIS/inter9_ID.bed -b C.ID.only.bed B.D.only.bed > c.bed

# Common between CTCF ID ONLY and BORIS D ONLY -->
bedtools intersect -f .25 -r -a C.ID.all.bed -b B.D.all.bed > COMMON_CTCF_BORIS.bed

# CTCF Only sites in 3-way Venn -->
bedtools intersect -f .25 -r -a C.ID.only.bed -b /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks/data_deeptools/9_vs_CTCF_BORIS/inter9_ID.bed B.D.only.bed -v > CTCF_ONLY_vs_inter9ID_B_D_Only.bed

# BORIS Only sites in 3-way Venn -->
bedtools intersect -f .25 -r -a B.D.only.bed -b /gpfs/data/skoklab/home/kantha01/CHIP_Seq/Priscillia_fastq_bigwig_script/fastq_2020_01_31/peaks/data_deeptools/9_vs_CTCF_BORIS/inter9_ID.bed C.ID.only.bed -v > BORIS_ONLY_vs_inter9ID_C_ID_Only.bed


# INTERVENE Venn Plotting -->

module load anaconda3/cpu/5.2.0

intervene -h

intervene venn

intervene venn -i 9_ID_MERGED_specific.bed C.ID.all.bed B.D.all.bed --names=9,CTCF,BORIS --colors=w,w,w --bordercolors=r,g,g --save-overlaps --bedtools-options f=0.25,r