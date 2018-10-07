#!/bin/bash

#user a to turn left
#user w to turn up
#user s to turn down
#user d to turn right
#length of snake increase by 2 when it takes a turn
tput smcup
left=1
right=1
up=1
down=1
if [ -t 0 ]; then stty -icanon ; fi
count=0
keypress=''
tput civis
height=$(tput lines);
width=$(tput cols);

key="b";
frand=9
brand=9
stty -echo
tput bold;
set_backgroun=$(tput setab 1)
	echo $set_backgroun
setbackground(){
	brand=$((1 + RANDOM % 7))
	while [[ $brand -eq $frand ]]; do
		brand=$((1 + RANDOM % 7))
	done
	set_background=$(tput setab $brand)
	echo $set_background
}

setColor(){
	frand=$((1 + RANDOM % 7))
	set_foreground=$(tput setaf $frand)
	echo -n $set_foreground
}

foodX=0
foodY=0
generateFood(){
	if [[ $foodX -eq 0 ]] && [[ $foodY -eq 0 ]]; then
		rand1=$((1 + RANDOM % (width-2)))
		rand2=$((1 + RANDOM % (height-2)))
		foodX=$rand2
		foodY=$rand1
		tput cup $rand2 $rand1
		echo "O"
	else
		tput cup $foodX $foodY
		echo "O"
	fi
	
}

increaseSize(){
	length=$((length+=2))
	yC[$length-1]=${yC[$length-3]}
	xC[$length-1]=${xC[$length -3]}	
	yC[$length-2]=${yC[$length-3]}
	xC[$length-2]=${xC[$length -3]}	
	
}

eaten(){
	if [[ $foodX -eq $x ]] && [[ $foodY -eq $y ]]; then
		foodX=0
		foodY=0
		tput cup 0 $(($width-15))
		((sco++))
		echo "Score = "$sco
		generateFood
	fi
}

restart() {
		clear
		length=4
		left=1
		right=1
		up=1
		down=1
		timer=0
        y=$((width/2))
		x=$((height/2))
		key="b"
		sco=0
		# setbackground
		setColor
		echo "Use w,a,s,d for movement , q for quit"
		tput cup 0 $(($width-15))
		echo "Score = "$sco
		
		for (( i = 0; i < $length; i++ )); do
			yC[i]=$(($y+1))
			xC[i]=$x
			((y++))
		done
		for (( i = 0; i < $length; i++ )); do
			tput cup ${xC[$i]} ${yC[$i]}
			echo "*"
		done
		generateFood
		
}

changeArray(){
	for (( i = 1; i < $length; i++ )); do
		yC[(($i-1))]=${yC[$i]}
		xC[(($i-1))]=${xC[$i]}
	done
}
moveLeft(){
	((y--))
	right=0
	up=1
	down=1
	tput cup ${xC[0]} ${yC[0]} 
		echo " "
	changeArray
	yC[(($length-1))]=$y
	xC[(($length-1))]=$x
	tput cup $x $y
		echo "*"
}
moveRight(){
	((y++))
	left=0
	up=1
	down=1
	tput cup ${xC[0]} ${yC[0]} 
		echo " "
	changeArray
	yC[(($length-1))]=$y
	xC[(($length-1))]=$x
	tput cup $x $y
		echo "*"
}
moveUp(){
	((x--))
	down=0
	right=1
	left=1
	tput cup ${xC[0]} ${yC[0]} 
		echo " "
	changeArray
	yC[(($length-1))]=$y
	xC[(($length-1))]=$x
	tput cup $x $y
		echo "*"
}
moveDown(){
	((x++))
	up=0
	right=1
	left=1	
	tput cup ${xC[0]} ${yC[0]} 
		echo " "
	changeArray
	yC[(($length-1))]=$y
	xC[(($length-1))]=$x
	tput cup $x $y
		echo "*"
}
restart;
# exit
while [ 1 -eq 1 ];do
		if [ $x -le 0 ] || [ $x -ge $(($height-1)) ] || [ $y -ge $(($width-1)) ] || [ $y -le 0 ] ; then
        	restart;
        fi
        if [[ $timer -eq 15 ]]; then
        	increaseSize
        	timer=$((timer%15))
        fi
        ((timer++))
		read -s -t 0.1 -n 1  keypress	     		
		if [ -z $keypress ];
		then	
			if [[ "$key" == "up"  ]]; then
				moveUp	
				eaten
			fi
			if [[ "$key" == "down"  ]]; then
				moveDown				
				eaten
			fi
			if [[ "$key" == "right"  ]]; then
				moveRight
				eaten
			fi
			if [[ "$key" == "left"  ]]; then
				moveLeft
				eaten
			fi
			if [[ "$key" == "b"  ]]; then
				moveRight
				eaten
			fi
		fi
		if [[ "$keypress" == "w" ]] && [ $up -ne 0 ]; then
			key=up
			setColor
			moveUp
			eaten

		fi
		if [[ "$keypress" == "s" ]]  && [ $down -ne 0 ]; then
			key=down
			setColor
			moveDown
			eaten
		fi
		if [[ "$keypress" == "d" ]] && [ $right -ne 0 ]; then
			key=right
			setColor
			moveRight
			eaten
		fi
		if [[ "$keypress" == "a" ]] && [ $left -ne 0 ]; then
			key=left
			setColor
			moveLeft
			eaten
		fi
		if [[ "$keypress" == "q" ]]; then
			break;
		fi
        
done

stty echo
if [ -t 0 ]; then stty sane; fi
tput rmcup
echo "Thanks for playing."
exit 0
