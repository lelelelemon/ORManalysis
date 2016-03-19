sudo apt-get install g++

sudo apt-get install make

sudo apt-get install cmake

#sudo apt-get install bundler



#sqllite

sudo apt-get install libsqlite3-dev

sudo gem install sqlite3



#mysql

sudo apt-get install mysql-server

sudo apt-get install mysql-client

sudo apt-get install libmysqlclient-dev

sudo gem install mysql2



#postgresql

sudo apt-get install -y postgresql postgresql-client libpq-dev



#nodejs, runtime

sudo apt-get install nodejs



#solarized, optional...

sudo apt-get install git

#git clone git://github.com/altercation/vim-colors-solarized.git

#cd vim-colors-solarized/colors

#mkdir ~/.vim

#mkdir ~/.vim/colors

#mv solarized.vim ~/.vim/colors/



#add to ~/.vimrc

#set mouse=a

#set clipboard=unnamed

#syntax on

#set go+=a

#syntax enable

#set background=dark

#colorscheme solarized



#rm -rf vim-colors-solarized



#ruby 2.1, optional

wget https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.7.tar.gz

tar -xvf ruby-2.1.7.tar.gz

cd ruby-2.1.7

./configure

make

sudo make install

sudo gem install bundle





sudo apt-get install firefox
