# BASIC SHELL THINGS TO KNOW :
__Bash__

> Bash is a Shell among Shells, a shell is a Command Line Interpreter that read command and passes them tho Linux kernel so that Linux kernel will send instruction directly to the hardware to do stuff

__Bin__

> This directory is for your own good to store all the programs and scripts

> to show the script function we should add `-x` at the end of #!

__Standard__ 

>   -standard input should be any thing you put in through keyboard
		
>   -standard output should be your monitor
		
>   -standard error just simply is your error message

__Redirect__
> is  that you choose whether the stdi or stdo in a program to be put in 
another program or file
		
etc: `echo “Script Errpr: This is an error message!” >&1`

	=> this means you sent the error msg to a standard error channel

__using PIPES:__

etc : `cat file | less`

=> pipe the output of the 'cat' command to 'less' which will show you only one scroll length of content at a time.

	

