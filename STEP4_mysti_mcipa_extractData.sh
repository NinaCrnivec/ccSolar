#! /bin/bash

. VARIABLES

echo
echo "Shell script sucessfully running!"
echo

echo
echo "Extract data"
echo

#First go out of run folder:
cd ..

mkdir dataabs_mysti
mkdir dataflx_mysti

mkdir dataabs_mcipa
mkdir dataflx_mcipa


for it in "${time_array[@]}"
do 
   echo
   echo 'time = ' $it

   for isza in "${sza_array[@]}"
   do
      echo
      echo 'sza = ' $isza
      
      for wcf in "${wcf_array[@]}"
      do

         for isim in "${isim_array[@]}"
         do
   
	      FOLDER_NAME_mysti='mysti_navg001_t'$it'_sza'$isza'_f'$wcf'_isim'$isim
	      echo 'Folder name = ' $FOLDER_NAME_mysti  
	      cd $FOLDER_NAME_mysti
	      cd output
	      cp *out.abs.spc ../../dataabs_mysti/
	      cp *out.flx.spc ../../dataflx_mysti/    
	      cd ..
	      cd ..
	   
	      FOLDER_NAME_mcipa='mcipa_navg001_t'$it'_sza'$isza'_f'$wcf'_isim'$isim
	      echo 'Folder name = ' $FOLDER_NAME_mcipa  
	      cd $FOLDER_NAME_mcipa
	      cd output
	      cp *out.abs.spc ../../dataabs_mcipa/
	      cp *out.flx.spc ../../dataflx_mcipa/    
	      cd ..
	      cd ..
	   
         done #over isim 
      done #over wcf
   done #over isza
done #over it

echo
echo 'The END'
echo


