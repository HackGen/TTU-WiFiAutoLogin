source ./config.sh

result=$(curl -i -d "user=$user&password=$password&cmd=authenticate&Login=Log+In" $url 2> /dev/null | grep 'User Authenticated' | wc -l)

if [ $result -eq 1 ]; then
	echo "Success!!";
else
	echo "Something wrong!";
fi
