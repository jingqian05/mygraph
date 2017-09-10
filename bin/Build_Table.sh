#!/usr/bin/bash
VERS=0.001.170907;  #usually begin with 0.001.
LICENSE='The MIT License (MIT)
Copyright (c) 2017 jingqian
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.'; #license
echo "Build_Table.sh $VERS"
 

# Command Line Options


URL="http://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens";

usage() { echo "Usage: $0 -f Homo_sapiens.GRCh37.75.gtf.gz [-l]" 1>&2; exit 1; }
#Loop
while getopts ":f:l" o; do

    case "${o}" in
        f)
            f=${OPTARG}
            ;;
        l)
            echo $LICENSE;exit 1;
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ -z "${f}" ]; then
    usage
fi


GTF=$(echo $f | sed 's/.gz$//');
if [ ! -f $f ] && [ ! -f $GTF ]; then
    echo "Retreiving f = $URL/${f}"
    $(wget $URL/${f});
fi
#unzip
if [ ! -f $GTF ]; then
   echo "Unzipping";
   $(gunzip $f);
   echo "file $f is unzipped as and should be ${GTF}"
fi
(awk '$3 ~ /gene/ { print $2,$1,$4,$5}' Homo_sapiens.GRCh37.75.gtf | sed 's/ /,/g' | sed -e '1ifeature,chr,start,end'> gene_dist_head.csv)
exit 0;
