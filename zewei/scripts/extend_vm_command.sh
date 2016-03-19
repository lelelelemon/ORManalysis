#pkg-config

wget http://pkgconfig.freedesktop.org/releases/pkg-config-0.22.tar.gz

cd pkg-config-0.22

./configure

make

sudo make install



#rmagick

sudo apt-get install rpm

sudo apt-get install libmagickwand-dev

wget http://www.imagemagick.org/download/ImageMagick.tar.gz

cd ImageMagick-6.9.2-8

./configure

make

sudo make install

sudo gem install rmagick





#nokogiri

sudo apt-get install libxslt-dev libxml2-dev

sudo gem install nokogiri -v 'version'



#readline error

sudo apt-get install libreadline-dev

wget https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.7.tar.gz

tar -xvf ruby-2.1.7.tar.gz

cd ruby-2.1.7

./configure

make

sudo make install




