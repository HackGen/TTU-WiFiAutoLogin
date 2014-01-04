SCRIPT_PATH=$(dirname $(readlink -f $0))
source $SCRIPT_PATH/config.sh

result=$(curl -k -i -d "user=$user&password=$password&cmd=authenticate&Login=Log+In" $url 2> /dev/null | grep 'User Authenticated' | wc -l)

if [ $result -eq 1 ]; then
	echo "Success!!";
else
	echo "Something wrong!";
fi
