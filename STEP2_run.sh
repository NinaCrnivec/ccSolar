#! /bin/bash

. VARIABLES

echo
echo "Shell script sucessfully running!"
echo

echo
echo "RUN SIMULATIONS"
echo

#First go out of run folder:
cd ..

for it in "${time_array[@]}"
do 
   echo
   echo 'time = ' $it

   for isza in "${sza_array[@]}"
   do
      echo 'sza = ' $sza 
      
      for wcf in "${wcf_array[@]}"
      do
  
      echo 'wcf = ' $wcf

         for isim in "${isim_array[@]}"
         do

         echo 'isim = ' $isim        

         FOLDER_NAME_mysti='mysti_navg001_t'$it'_sza'$isza'_f'$wcf'_isim'$isim
         echo 'Entering folder ' $FOLDER_NAME_mysti
         cd $FOLDER_NAME_mysti
         # RUN SHELL SCRIPT TO RUN INDIVIDUAL LIBRADTRAN SIMULATIONS:
         sbatch ./sol_HR.sh      
         cd ..
    
         FOLDER_NAME_mcipa='mcipa_navg001_t'$it'_sza'$isza'_f'$wcf'_isim'$isim
         echo 'Entering folder ' $FOLDER_NAME_mcipa
         cd $FOLDER_NAME_mcipa
         # RUN SHELL SCRIPT TO RUN INDIVIDUAL LIBRADTRAN SIMULATIONS:
         sbatch ./sol_HR.sh      
         cd ..

         done
      done
   done    
done

          
echo
echo 'The END'
echo






























