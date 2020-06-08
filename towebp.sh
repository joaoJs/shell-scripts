#!/bin/sh
while getopts 't:q:h' OPTION; do
  case "$OPTION" in
    t)
      type="$OPTARG"
      ;;
    q)
      quality="$OPTARG"
      ;;
    h)
      echo "usage:"
      echo "-t image type: png or jpg"
      echo "-q quality. Integer between 0 and 100."
      echo "-h help"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [ -z "$type" ]
then
    echo "please provide image type";
    exit 1
elif [[ "$type" != "png" &&  "$type" != "jpg" ]]
then 
    echo "incorrect image type. Please enter 'png' or 'jpg'";
    exit 1
else 
    echo "image type is: $type"
fi

re='^[0-9]+$'
if [ -z "$quality" ]
then
    echo "quality set to 80"
elif ! [[ $quality =~ $re ]] ; 
then
   echo "error: quality must be an integer" >&2; 
   exit 1
elif [[ $quality -lt 0 || $quality -gt 100 ]]
then 
    echo "error: quality must be between 0 and 100."
    exit 1
else 
    echo "quality is $quality"
fi

for f in src/img/*.$type ; do
    original="$(basename -- $f)"
    new="${original/$type/webp}"
    if [ -z "$quality" ] 
    then
        cwebp src/img/$original -o src/img/webP/$new ;
    else
        cwebp -q $quality src/img/$original -o src/img/webP/$new ;
    fi
done

echo "images successfully converted!"
exit 0