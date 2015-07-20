#!/bin/bash


for portal in $( ls -d * ); do
for fullpath in $( ls -d $portal/* ); do
  python update.py $fullpath
  # # EncryptFS compatibility
  # dirname=$(dirname $fullpath)
  # filename=$(basename $fullpath)
  # if [ -n "$(head $fullpath/data.json | head -n 2 | grep '@id')" ]; then
  #   echo $fullpath
  # fi

  #filename_length=$(echo $filename | wc -c)
  #if [ $filename_length -eq 63 ]; then
  #  #truncated_filename=$(echo $filename | head -c 143)
  #  #git mv $fullpath $dirname/$truncated_filename
  #  dupcount=$(ls -d ${fullpath}* | wc -l)
  #  if [ $dupcount -gt 1 ]; then
  #     #echo ========= $dupcount $fullpath ========
  #     #echo ========
  #     #echo $fullpath $dupcount
  #     git rm -r $fullpath
  #  fi
  #fi
  #dupcount=$(ls -d ${fullpath}* | wc -l)
  #if [ $dupcount -gt 1 ]; then
  #   #echo ========= $dupcount $fullpath ========
  #   #ls -d ${fullpath}*
  #   #echo ========
  #   #echo $fullpath $dupcount
  #   datasetnamelength=$(echo $fullpath | cut -d '/' -f 2 | wc -c)
  #   if [ $datasetnamelength -gt 61 ]; then
  #     git rm -r $fullpath
  #   fi
  #fi
done
done
#
#for filename in $( ls . ); do
#  portal=$(echo $filename | cut -d _ -f 2)
#  dataset=$(echo $filename | cut -d _ -f 3-)
#  mkdir -p $portal
#  git mv $filename $portal/$dataset
#done

#  cityofnewyork=data.cityofnewyork.us
#  cityofchicago=data.cityofchicago.org
#  #data.act.gov.au
#  melbourne=data.melbourne.vic.gov.au
#  colorado=data.colorado.gov
#  nola=data.nola.gov
#  healthmeasures=healthmeasures.aspe.hhs.gov
#  wa=data.wa.gov
#  opendata=opendata.go.ke
#  austintexas=data.austintexas.gov
#  #info.samhsa.gov
#  taxpayer=data.taxpayer.net
#  cityofmadison=data.cityofmadison.com
#  #slcgov=data.slcgov.com
#  illinois=data.illinois.gov
#  somervillema=data.somervillema.gov
#  iranhumanrightscom=iranhumanrights.socrata.com
#  hawaii=data.hawaii.gov
#  maryland=data.maryland.gov
#  ny=data.ny.gov
#  mo=data.mo.gov
#  nfpa=data.nfpa.org
#  #nmfs=nmfs.socrata.com
#  govloop=data.govloop.com
#  sunlightlabs=data.sunlightlabs.com
#  electionsdata=electionsdata.kingcounty.gov
#  undp=data.undp.org
#  deleoncom=deleon.socrata.com
#  energystar=data.energystar.gov
#  #explore=explore.data.gov
#  weatherfordtx=data.weatherfordtx.gov
#  bronx=bronx.lehman.cuny.edu
#  sfgov=data.sfgov.org
#  edmonton=data.edmonton.ca
#  consumerfinance=data.consumerfinance.gov
#  metrochicagodata=www.metrochicagodata.org
#  kingcounty=data.kingcounty.gov
#  baltimorecity=data.baltimorecity.gov
#  healthny=health.data.ny.gov
#  #dati.lombardia.it
#  datacatalog=datacatalog.cookcountyil.gov
#  opendatanyc=www.opendatanyc.com
#  cookcountycom=cookcounty.socrata.com
#  oregon=data.oregon.gov
#  oaklandnet=data.oaklandnet.com
#  raleighnc=data.raleighnc.gov
#  finances=finances.worldbank.org
#  honolulu=data.honolulu.gov
#  cityofboston=data.cityofboston.gov
#  ok=data.ok.gov
#  cms=data.cms.gov
#  #data.snostat.org
#  #www.halifaxopendata.ca
#  wellingtonfl=data.wellingtonfl.gov
#  gettingpastgocom=gettingpastgo.socrata.com
#  #www.data.act.gov.au
#  redmond=data.redmond.gov
#  seattle=data.seattle.gov
#  montgomerycountymd=data.montgomerycountymd.gov
#  acgov=data.acgov.org
#  medicare=data.medicare.gov
#  #lacity=data.lacity.org
#  #detroitmi=data.detroitmi.gov
#  
#  for filename in $( ls . ); do
#    host=${!filename}
#    if [ $host ]; then
#      git mv $filename $host  
#    fi
#    #else
#    #  echo ERROR $filename
#    #fi
#  done

