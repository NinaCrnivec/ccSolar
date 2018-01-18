#!/usr/bin/env bash

. VARIABLES

IDENT=$1

ffname='mysti'

if [ "$IDENT" == "mcipa" ]
then
    MCIPA="mc_ipa"
    ffname='mcipa'
fi
echo MCIPA :: $MCIPA

SCRIPTDIR=$(pwd)

echo
echo "Shell script sucessfully running!"
echo

echo
echo "BUILD FOLDER NAMES AND INPUT FILES"
echo

#First go out of run folder:
cd ..

for it in "${time_array[@]}"
do 
    echo 'time = ' $it

    CLOUD_FILE_INP='cloudFilesInp/wc3D_dx25m_time_'$it'.dat'
    ZVALUES="$(head -n2 ${CLOUD_FILE_INP} | tail -n1 | cut -d " " -f 4-)"

    #Set initial dx:
    sgdxdy=0.400
    
    for wcf in "${wcf_array[@]}"
    do
    
        echo
        echo "wcf = " $wcf 
        echo "sgdxdy = " $sgdxdy
     
        # Create cloud file name:
        CLOUD_FILE='wc3D_dx25m_time_'$it'_'$wcf'.dat'
        echo
        echo 'CLOUD_FILE = ' $CLOUD_FILE
    
        head -n1 ${CLOUD_FILE_INP} > cloudFiles/$CLOUD_FILE
        echo "$sgdxdy $sgdxdy $ZVALUES" >> cloudFiles/$CLOUD_FILE
        tail -n +3 ${CLOUD_FILE_INP} >> cloudFiles/$CLOUD_FILE
    
        for isza in "${sza_array[@]}"
        do
    	echo "sza = " $isza
    

            for isim in "${isim_array[@]}"
            do       
                echo  
                echo "isim = " $isim
                # Create libradtran output file name:
                OUT_FILE=$ffname'_navg001_t'$it'_sza'$isza'_f'$wcf'_isim'$isim'.out'
    
                echo 'OUT_FILE = ' $OUT_FILE
         
                FOLDER_NAME=$ffname'_navg001_t'$it'_sza'$isza'_f'$wcf'_isim'$isim
		 
                mkdir $FOLDER_NAME
		    
	        cd $FOLDER_NAME
		 
	        echo 'Entering folder name = ' $FOLDER_NAME
		 
	        # Create output folder for results:
	        mkdir output  
	    
INP_FILE_NAME='libsetup.inp'
LIBRAD="$HOME/libRadtran"
    
############################
# CREATE INPUT FILE HERE !!!   
cat > $INP_FILE_NAME << EOF 
data_files_path $LIBRAD/data/
atmosphere_file $LIBRAD/data/atmmod/afglus.int
source solar $LIBRAD/data/solar_flux/kato
wavelength_index 1 32
output_process sum
mol_abs_param kato2
albedo 0.25
#Choose appropriate cloud file:
wc_file 3D ../cloudFiles/$CLOUD_FILE
wc_properties hu interpolate
#Vary sza here:
sza $isza
phi0 0 #(SOUTH)
zout all_levels
rte_solver montecarlo
$MCIPA
mc_std
mc_forward_output absorption K_per_day
mc_photons 655360 #(256**2*1e1)1e1 photons per pixel
#mc_photons 6553600 #(256**2*1e2)1e2 photons per pixel
mc_sample_grid 256 256 $sgdxdy $sgdxdy
#mc_sample_grid 256 256 .025 .025
#mc_sample_grid 1 1 6.4 6.4
mc_basename ./output/$OUT_FILE
#quiet
verbose
EOF
### END OF INPUT FILE ###########
################################# 

cat >sol_HR.sh<<EOF
#! /bin/bash

#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1
#SBATCH --partition=cluster,ws
#SBATCH --mem=6G
#SBATCH --time=6:00:00
#SBATCH --output=libsol.sh.%j.out
#SBATCH --error=libsol.sh.%j.err 
#SBATCH --export=NONE
#SBATCH --mail-type=END
#SBATCH --mail-user=$USER@physik.uni-muenchen.de

cd $(pwd)
echo "Job started @ \$(date)"
$LIBRAD/bin/uvspec < $INP_FILE_NAME 
echo "Job finished @ \$(date)"
EOF

           #Leave mysti/mcipa folder:
           cd ..

           done #over isim 
   
       done #over sza
       
      #Calculate new dx:
      sgdxdy=$(echo "scale=11; $sgdxdy/2." | bc)
   
      
   done # over wcf
done # over itime

echo
echo 'The END'
echo

