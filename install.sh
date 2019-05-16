#!/bin/sh


INDEX="https://pypi.org/simple/"
SETUPTOOLS=`grep "setuptools\s*\=\s*" versions.cfg | sed 's/\s*=\s*/==/g'`
ZCBUILDOUT=`grep "zc\.buildout\s*=\s*" versions.cfg | sed 's/\s*=\s*/==/g'`


if [ -s "bin/activate" ]; then

  echo "\n============================================================="
  echo "Buildout is already installed."
  echo "Please remove bin/activate if you want to re-run this script."
  echo "=============================================================\n"

  exit 0

else


echo "Installing virtualenv"
wget "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.6.4.tar.gz#md5=1072b66d53c24e019a8f1304ac9d9fc5" -O "/tmp/virtualenv-1.6.4.tar.gz"
tar -zxvf "/tmp/virtualenv-1.6.4.tar.gz" -C "/tmp/"



echo "Running: python2.4 virtualenv.py --clear --no-site-packages ."
python2.4 "/tmp/virtualenv-1.6.4/virtualenv.py" --clear  --no-site-packages .
rm "/tmp/virtualenv-1.6.4.tar.gz"
rm -r "/tmp/virtualenv-1.6.4"

. ./bin/activate

python -V 


echo "Pip install"
pip install -i $INDEX  $SETUPTOOLS $ZCBUILDOUT
pip install -i $INDEX  Pillow==1.7.8 



fi

echo "\n======================================================="
echo "All set. Now you can run ./bin/buildout -c buildout.cfg"
echo "=======================================================\n"

