module load bedtools

# To get the Unique regions BED file for the sample to run in MEME-ChIP (Takes the combined ID1 and ID2 BED files and merges close coordinates):
sort -k1,1 -k2,2n inter9_ID.bed  | mergeBed > inter_9_ID_UNIQ.bed

# To get the FASTA sequence by looking up the coordinates in BED file and extracting FASTA from the Mouse Genome 
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed inter_9_ID_UNIQ.bed -fo Inter_9_ID_UNIQ_ALL.fa

****************************************************************************************************************************************************

sort -k1,1 -k2,2n ID_9_2nd_replicate_np0.15_ov0.15_9-ID_only.bed  | mergeBed > 9_ID_uniq.bed
sort -k1,1 -k2,2n ID_9_2nd_replicate_np0.15_ov0.15_BORIS_9-ID.bed  | mergeBed > BORIS_9_ID_uniq.bed
sort -k1,1 -k2,2n ID_9_2nd_replicate_np0.15_ov0.15_BORIS_only.bed  | mergeBed > BORIS_uniq.bed
sort -k1,1 -k2,2n ID_9_2nd_replicate_np0.15_ov0.15_CTCF_9-ID.bed  | mergeBed > CTCF_9_ID_uniq.bed
sort -k1,1 -k2,2n ID_9_2nd_replicate_np0.15_ov0.15_CTCF_BORIS_9-ID_all.bed  | mergeBed > CTCF_BORIS_9_ID_uniq.bed
sort -k1,1 -k2,2n ID_9_2nd_replicate_np0.15_ov0.15_CTCF_BORIS.bed  | mergeBed > CTCF_BORIS_uniq.bed
sort -k1,1 -k2,2n ID_9_2nd_replicate_np0.15_ov0.15_CTCF_only.bed  | mergeBed > CTCF_uniq.bed

bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed 9_ID_uniq.bed  -fo 9_ID_uniq.fa
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed BORIS_9_ID_uniq.bed  -fo BORIS_9_ID_uniq.fa
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed BORIS_uniq.bed  -fo BORIS_uniq.fa
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed CTCF_9_ID_uniq.bed  -fo CTCF_9_ID_uniq.fa
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed CTCF_BORIS_9_ID_uniq.bed  -fo CTCF_BORIS_9_ID_uniq.fa
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed CTCF_BORIS_uniq.bed  -fo CTCF_BORIS_uniq.fa
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed CTCF_uniq.bed  -fo CTCF_uniq.fa




****************************************************************************************************************************************************

srun -t 0-10 --pty bash
module load bedtools

sort -k1,1 -k2,2n WT_ID_specific_vs377_ID.bed | mergeBed > WT_ID_specific_vs377_uniq.bed
sort -k1,1 -k2,2n interCTCF_377_ID.bed  | mergeBed > interCTCF_377_ID_uniq.bed
sort -k1,1 -k2,2n 377_ID_specific.bed  | mergeBed > 377_ID_specific_uniq.bed

bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed WT_ID_specific_vs377_uniq.bed -fo WT_ID_specific_vs377.fa
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed interCTCF_377_ID_uniq.bed -fo interCTCF_377_ID.fa
bedtools getfasta -fi /gpfs/share/apps/iGenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -bed 377_ID_specific_uniq.bed -fo 377_ID_specific.fa


****************************************************************************************************************************************************