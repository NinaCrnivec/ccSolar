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
echo "RUN SIMULATIONS"
echo

#Go out of run folder:
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

            FOLDER_NAME=$ffname'_navg001_t'$it'_sza'$isza'_f'$wcf'_isim'$isim
            echo 'Entering folder ' $FOLDER_NAME
            cd $FOLDER_NAME
            sbatch ./sol_HR.sh      
            cd ..
         done
      done
   done    
done
          
echo
echo 'The END'
echo






























