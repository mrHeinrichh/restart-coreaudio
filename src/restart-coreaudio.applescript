on run
	do shell script "kill -9 $(ps ax | grep 'coreaudio[a-z]' | awk '{print $1}' )" with administrator privileges
end run
