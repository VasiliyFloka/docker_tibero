if [ ! -f ./Tibero.tar.gz ]; then
   echo "Put file Tibero.tar.gz in current directory"
   exit 1;
fi;
if [ ! -f ./license.xml ]; then
   echo "Put file license.xml in current directory"
   exit 1;
fi;
if [ ! -f ./bash_profile.add ]; then
   echo "Put file bash_profile.add in current directory"
   exit 1;
fi;
if [ ! -f ./create_database.sql ]; then
   echo "Put file create_database.sql in current directory"
   exit 1;
fi;
if [ ! -f Dockerfile ]; then
   echo "Put file Dockerfile in current directory"
   exit 1;
fi;
if [ ! -f jdk.rpm ]; then
   echo "Put file jdk.rpm in current directory"
   exit 1;
fi;
docker build -t tibero6 .