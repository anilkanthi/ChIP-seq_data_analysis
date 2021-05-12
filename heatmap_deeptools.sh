#!/bin/bash
#SBATCH --partition=fn_medium
#SBATCH -J deeptools
#SBATCH --mem=96G
#SBATCH --time=48:00:00
#SBATCH -N 1

set -e

module load deeptools/3.1.0

BED="$1"
if [[ ! -f "$BED" ]]; then
    echo File "$BED" does not exist >&2
    exit 1
fi

OUTPUT_FILE_PREFIX="$2"

############################################################# ADD BIGWIG FILES AS NEEDED ###############################################################################################

#BW_1="/gpfs/data/skoklab/home/shared-ali-anil/Flag-chip/merged_flag/CTCF_ID_rpkm.bw"

BW_1="bigwigs/9-2nd-ID_S7_L002_rpkm.bw"
BW_2="bigwigs/377_ID_rpkm.bw"
BW_3="bigwigs/418_ID_rpkm.bw"
BW_4="bigwigs/448_ID_rpkm.bw"
BW_5="bigwigs/455_ID_rpkm.bw"

###3kb###
Midpoint=3000
y_scale_min=0
y_scale_max=80									# Change number if needed
color=Purples
zMin=0
zMax=20										# Change number if needed

computeMatrix reference-point \
    --referencePoint center \
    --scoreFileName ${BW_1} ${BW_2} ${BW_3} ${BW_4} ${BW_5} \
    --regionsFileName ${BED} \
    --sortRegions descend \
    --sortUsingSamples 1 \
    --outFileName ${OUTPUT_FILE_PREFIX}_matrix.gz \
    --missingDataAsZero \
    --beforeRegionStartLength ${Midpoint} \
    --afterRegionStartLength ${Midpoint}

plotHeatmap \
    --matrixFile ${OUTPUT_FILE_PREFIX}_matrix.gz \
    --outFileName ${OUTPUT_FILE_PREFIX}_heatmap.pdf \
    --colorMap ${color} \
    --heatmapHeight 50 \
    --sortRegions descend \
    --sortUsingSamples 1 \
    --legendLocation none \
    --whatToShow 'heatmap and colorbar' \
    --zMin ${zMin} \
    --zMax ${zMax} \
    --samplesLabel 9_ID 377_ID 418_ID 448_ID 455_ID

plotProfile \
    --matrixFile ${OUTPUT_FILE_PREFIX}_matrix.gz \
    --outFileName ${OUTPUT_FILE_PREFIX}_pergroupprofilePlot.pdf \
    --colors red darkred blue darkblue green darkgreen \
    --legendLocation 'upper-center' \
    --yMin ${y_scale_min} \
    --yMax ${y_scale_max} \
    --perGroup

plotProfile \
    --matrixFile ${OUTPUT_FILE_PREFIX}_matrix.gz \
    --outFileName ${OUTPUT_FILE_PREFIX}_profilePlot.pdf \
    --colors red darkred blue darkblue green darkgreen \
    --legendLocation 'upper-center' \
    --yMin ${y_scale_min} \
    --yMax ${y_scale_max}
