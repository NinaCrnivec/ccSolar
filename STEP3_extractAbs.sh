#! /bin/bash

. VARIABLES

IDENT=$1

ffname='mysti'

if [ "$IDENT" == "mcipa" ]
then
   ffname='mcipa'
fi

echo
echo "Shell script sucessfully running!"
echo

echo
echo "Extract data"
echo

# Go out of run folder:
cd ..

FN_ABS="dataabs_"$ffname
FN_FLX="dataflx_"$ffname

mkdir $FN_ABS
mkdir $FN_FLX

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
   
	          FOLDER_NAME=$ffname'_navg001_t'$it'_sza'$isza'_f'$wcf'_isim'$isim
	          echo 'Folder name = ' $FOLDER_NAME  
	          cd $FOLDER_NAME
	          cd output
	          cp *out.abs.spc ../../$FN_ABS/
	          cp *out.flx.spc ../../$FN_FLX/    
	          cd ..
	          cd ..
	   
         done #over isim
      done #over wcf
   done #over isza
done #over it

echo
echo 'The END'
echo
