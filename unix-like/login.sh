source ./config.sh

curl -i -d "user=$user&password=$password&cmd=authenticate&Login=Log+In" $url
