library(bedr)

setwd("/gpfs/data/skoklab/home/kantha01/CHIP_Seq/bedr_narrowPeak_to_Count/")

###### Function: get a unique set of peaks for a condition using 2 chip-seq replicates ########################################
getConditionPeaks=function(x,y,condition){
  cols <- c("chr","start","end")
  
  narrowPeak1=x
  narrowPeak2=y
  condition=condition
  peaks_rep1 <- read.table(narrowPeak1,stringsAsFactors = F,header = F)
  peaks_rep2 <- read.table(narrowPeak2,stringsAsFactors = F,header = F)
  
  peaks_rep1 <- peaks_rep1[,1:3]
  peaks_rep2 <- peaks_rep2[,1:3]
  colnames(peaks_rep1)[1:3] <- cols
  colnames(peaks_rep2)[1:3] <- cols
  
  #Merge overlapped peaks (intra-replicate)
  ovlp = 0 #overlap criteria (intra-replicate)
  peaks_rep1_merged <- bedr.merge.region(peaks_rep1, distance = ovlp)
  peaks_rep2_merged <- bedr.merge.region(peaks_rep2, distance = ovlp)
  
  ### Keep peaks present in both replicates ### (inter-replicate)
  frac_ovlp = 0.0000000001  #overlap criteria (inter-replicate)
  temp_bedr <- bedr.join.multiple.region(x=list(R1=peaks_rep1_merged[1:3],R2=peaks_rep2_merged[1:3]),fraction.overlap = frac_ovlp,cluster = T)
  peaks_merged <- temp_bedr[temp_bedr$R1 > 0 & temp_bedr$R2 > 0, 1:3] #get the overlapped peaks inter-replicate
  peaks_merged <- peaks_merged[peaks_merged$V3-peaks_merged$V2 > 50,] #remove peaks < 50 bp
  write.table(peaks_merged,paste0(condition,"_merged.bed"),quote=F,row.names = F,col.names = F,sep="\t") #generate bed file
  return(peaks_merged)
}

D_9_merged <- getConditionPeaks(x="9D_S5_L002_macs2_peaks.narrowPeak",
                                y="9_2nd_D_S8_L002_macs2_peaks.narrowPeak",
                                condition="D_9")

ID_9_merged <- getConditionPeaks(x="9_ID_S6_L002_macs2_peaks.narrowPeak",
                                y="9_2nd_ID_S7_L002_macs2_peaks.narrowPeak",
                                condition="ID_9")

B_D_merged <- getConditionPeaks(x="Flag_ChIP_BOR_2i_D2_S29_L008_macs2_peaks.narrowPeak",
                                y="Flag_ChIP_BOR_2i_D3_S38_L005_macs2_peaks.narrowPeak",
                                condition="B_D")

B_ID_merged <- getConditionPeaks(x="Flag_ChIP_BOR_2i_ID2_S30_L008_macs2_peaks.narrowPeak",
                                 y="Flag_ChIP_BOR_2i_ID3_S39_L005_macs2_peaks.narrowPeak",
                                 condition="B_ID")

C_D_merged <- getConditionPeaks(x="Flag_ChIP_CTCF_2i_D3_S36_L005_macs2_peaks.narrowPeak",
                                y="Flag_ChIP_CTCF_2i_D4_S52_L008_macs2_peaks.narrowPeak",
                                condition="C_D")

C_ID_merged <- getConditionPeaks(x="Flag_ChIP_CTCF_2i_ID2_S28_L008_macs2_peaks.narrowPeak",
                                 y="Flag_ChIP_CTCF_2i_ID3_S37_L005_macs2_peaks.narrowPeak",
                                 condition="C_ID")


### Intersect peaks across conditions ##################################################################################
frac_ovlp = 0.7 #overlap criteria (inter-conditions)

##D_9 peaks -->

##set1                                       

temp_bedr <- bedr.join.multiple.region(x=list(C_ID=C_ID_merged[1:3]
                                              ,B_D=B_D_merged[1:3]
                                              ,D_9=D_9_merged[1:3])
                                       ,fraction.overlap = frac_ovlp,cluster = T)

temp_bedr=temp_bedr[temp_bedr$V3-temp_bedr$V2 >50,]

C_only_peaks <- temp_bedr[temp_bedr$C_ID > 0 & temp_bedr$B_D == 0,] #present in C_ID only
B_only_peaks <- temp_bedr[temp_bedr$C_ID == 0 & temp_bedr$B_D > 0,] #present in B_D only
CB_common_peaks <- temp_bedr[temp_bedr$C_ID > 0 & temp_bedr$B_D > 0,] #present in C_ID and B_D

#v1
#D_9 peaks -->
D_9_only_peaks <- temp_bedr[temp_bedr$C_ID == 0 & temp_bedr$B_D == 0 & temp_bedr$D_9 > 0,] #present in D_9 only (not in C_ID & B_D)

write.table(C_only_peaks,"C.only.bed",quote = F,row.names = F,col.names = F,sep="\t")
write.table(B_only_peaks,"B.only.bed",quote = F,row.names = F,col.names = F,sep="\t")
write.table(CB_common_peaks,"CB.common.bed",quote = F,row.names = F,col.names = F,sep="\t")

write.table(D_9_only_peaks,"D_9.only.bed",quote = F,row.names = F,col.names = F,sep="\t")

##ID_9 peaks -->

##set2
temp_bedr2 <- bedr.join.multiple.region(x=list(C_ID=C_ID_merged[1:3]
                                              ,B_ID=B_ID_merged[1:3]
                                              ,ID_9=ID_9_merged[1:3])
                                       ,fraction.overlap = frac_ovlp,cluster = T)
                                       
temp_bedr2=temp_bedr2[temp_bedr2$V3-temp_bedr2$V2 >50,]

#v1
ID_9_only_peaks <- temp_bedr2[temp_bedr2$C_ID == 0 & temp_bedr2$B_ID == 0 & temp_bedr2$ID_9 > 0,] #present in ID_9 only (not in C_ID & B_ID)



write.table(ID_9_only_peaks,"ID_9.only.bed",quote = F,row.names = F,col.names = F,sep="\t")

#view count
dim(C_only_peaks)
dim(B_only_peaks)
dim(CB_common_peaks)

dim(D_9_only_peaks)

dim(ID_9_only_peaks)


### Get Fasta from Beds (can be used for Motif Analysis) ##########################################################
bedToFasta=function(x){ ## for mouse genome
  peak=x
  label=deparse(substitute(x))
  
  x <- as.data.frame(peak)
  colnames(x) <- c("chr","start","end")
  x$chr <- as.character(x$chr)
  x$start <- as.numeric(x$start)
  x$end <- as.numeric(x$end)
  x <- x[,1:3]
  x <- x[x$end-x$start > 50,]
  x_fasta <- get.fasta(x=x, fasta = "/gpfs/data/skoklab/home/shared-ali-anil/ref_data/ref/mm10/bowtie2.index/mm10.fa",output.fasta = T)
  write.table(x_fasta,paste0(label,".fa"),quote = F,row.names = F,col.names = F) #generate fasta file
}

bedToFasta(C_only_peaks) #generate peaks fasta files
bedToFasta(B_only_peaks)
bedToFasta(CB_common_peaks) 

bedToFasta(D_9_only_peaks)

bedToFasta(ID_9_only_peaks)