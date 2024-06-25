
#!/usr/bin/env bash
lang=`echo "go\npython" | fzf`
if [[ -z $lang ]]; then
    exit 0
fi

read -p "Name playground: " pgname

mkdir -p ~/Code/Playground/$lang/$pgname

case $lang in 
	go)
		cd ~/Code/Playground/$lang/$pgname
		if [ ! -f main.go ]; then
			echo "main.go not found"
			echo """package main

import \"fmt\"

func main(){
	fmt.Printf(\"Hello world\")
}
""" > main.go

			echo """package main

import (
	\"testing\"
)

func TestFoo(t *testing.T) {
	t.Error(\"Not implemented\")
}
"""> main_test.go
			go mod init github.com/pintjuk/Playground/$lang/$pgname
		else
			echo "playground already exists"
		fi

		tmux new-session -s pg-$lang-$pgname -d -c ~/Code/Playground/$lang/$pgname ~/dotfiles/bin/create-plg-go-vim-open.sh
		tmux switch-client -t pg-$lang-$pgname 
		;;
	*)
		;;
esac
