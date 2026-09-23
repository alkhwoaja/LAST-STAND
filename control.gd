extends Control

func _ready():
	Reset_Timer()
	pass
	
	
	
	
var seconds=0 
var minutes=0 
var Dseconds=30 
var Dminutes=1 
func _on_Timer_timeout(): 
	if seconds==0: 
		if minutes>0: 
			minutes-=1
			seconds=60
	seconds-=1
	
	$Label.text-String(minutes)+":"+String(seconds) 
	pass
func Reset_Timer(): 
	seconds=Dseconds 
	minutes=Dminutes
	
