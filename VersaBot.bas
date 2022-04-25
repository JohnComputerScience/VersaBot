'Symbol declarations

'variables
symbol temp = w0
symbol temp1 = w1
symbol temp2 = w2

'Pin to Symbol Assignments
symbol lLED = B.0        
symbol leftMotor = B.1     
symbol P2 = B.2        
symbol P3 = B.3        
symbol P4 = B.4        
symbol P5 = B.5        
symbol buttonOne = pinB.6     
symbol buzzer = B.7
symbol P8  = C.0 
symbol P9  = C.1 
symbol P10 = C.2 
symbol rightMotor = C.3
symbol rLED = C.4 
symbol rightBump = pinC.5
symbol P14 = C.6 
symbol leftBump = pinC.7


StartOfProgram:
 	high rightMotor
 	high leftMotor
 	pause 50

StopRobot:
	do ' Ensure the button is un pressed before primary condition
 	loop until buttonOne = 0
	do ' Wait until button pushed
 	loop until buttonOne = 1 

Main:
	if buttonOne = 1 then StopRobot
	gosub HugLeft
	pause 1000 'increase time to decrease frequency of left turn checks
return

'This naive algorithm solves the specific maze built and used by the Sierra College Robotics Club
HardCodeSolve:
	'forward a bit, turn left
	gosub GoForward
	pause 150
	gosub TurnLeft
	'forward until hit wall, turn right
	gosub GoForward
	gosub BumperTurnRight
	'forward until hit wall, turn right
	gosub BumperTurnRight
	'forward until hit wall, turn right
	gosub BumperTurnRight
	'forward until hit wall, turn left
	gosub BumperTurnLeft
	'forward until hit wall, turn right
	gosub BumperTurnRight
	'forward a bit, turn right
	pause 1500
	gosub TurnRight
	'forward until hit wall, turn right
	gosub GoForward
	gosub BumperTurnRight
	'forward until hit wall, turn left
	gosub BumperTurnLeft
	'forward until hit wall, turn left
	gosub BumperTurnLeft
return

'***UNTESTED***
'This algorithm hugs the left wall of the maze by regularly turning to the left and checking for its presence
'If the wall is missing, it will drive through the opening until it finds a new wall to hug on the left
HugLeft:
	gosub TurnLeft
	gosub UntilBump
	gosub GoBackward
	pause 100 'this length needs to be tested
	gosub TurnRight
	gosub GoForward
return

'Drives forward until bumps
'right now it does not take into account the condition where only one sensor is activated
UntilBump:
	do while leftBump = 0 and rightBump = 0
		gosub GoForward
	loop
return

'routines for the maze algorithm
CheckLeft:
	gosub Turnleft
	gosub GoForward
	for temp = 1 to 25
		pause 15
		;if leftBump = 1 or rightBump = 1 then SensorHit
	next
return
	
FullBump:
	gosub GoBackward
	pause 700
	gosub SweepLeft
	pause 50
	sound buzzer, (100, 10)
return

BumperTurnLeft:
	gosub GoForward
	do loop until leftBump = 1 or rightBump = 1
	gosub SensorHitLeft
return

BumperTurnRight:
	gosub GoForward
	do loop until leftBump = 1 or rightBump = 1
	gosub SensorHitRight
return
SensorHitLeft:
	gosub GoBackward
	pause 800
	gosub TurnLeft
	gosub GoForward
return
SensorHitRight:
	gosub GoBackward
	pause 800
	gosub TurnRight
	gosub GoForward
return


'routines forturning the robot
'Sweep turns place the pivot around the wheel opposite the turn
SweepLeft:
	gosub FullStop
	SEROUT leftMotor, T2400, ("C",  0)
	SEROUT rightMotor, T2400, ("C", 100)
	pause 1200 ; radius of turn, 1200 for 90 degree turn
	gosub FullStop
return
SweepRight:
	gosub FullStop
	SEROUT leftMotor, T2400, ("A",  100)
	SEROUT rightMotor, T2400, ("C", 0)
	pause 1200 ; radius of turn, 1200 for 90 degree turn
	gosub FullStop
return

'Turns here pivot around the center of the robot
TurnLeft:
	gosub FullStop
	SEROUT leftMotor, T2400, ("C",  95)
	SEROUT rightMotor, T2400, ("C", 100)
	pause 620 ; radius of turn, 620 for 90 degree turn
	gosub FullStop
return
TurnRight:
	gosub FullStop
	SEROUT leftMotor, T2400, ("A",  100)
	SEROUT rightMotor, T2400, ("A", 95)
	pause 620 ;  radius of turn, 620 for 90 degree turn
	gosub FullStop
return

'The following subroutines are designed to navigate around an obsticle activatin only one of the bump sensors
'Around left navigates to to the right of an obstacle blocking its left half
AroundLeft:
	gosub FullStop
	gosub GoBackward
	pause 400
	gosub TurnRight
	gosub GoForward
	pause 500
	gosub TurnLeft
	gosub GoForward
	pause 700
	gosub TurnLeft
	gosub GoForward
	pause 500
	gosub TurnRight
	gosub GoForward
return
'Aroung right navigates to the left of an obstacle blocking its right half
AroundRight:
	gosub FullStop
	gosub GoBackward
	pause 400
	gosub TurnLeft
	gosub GoForward
	pause 500
	gosub TurnRight
	gosub GoForward
	pause 700
	gosub TurnRight
	gosub GoForward
	pause 500
	gosub TurnLeft
	gosub GoForward
return


'routines for forwards and backwards motion
'These might need to be tuned for the specific versa bot for consistant motion
GoForward:
	SEROUT leftMotor, T2400, ("A",  150)
	SEROUT rightMotor, T2400, ("C", 150)
return	
FastForward:
	SEROUT leftMotor, T2400, ("A",  225)
	SEROUT rightMotor, T2400, ("C", 225)
return
GoBackward:
	SEROUT leftMotor, T2400, ("C",  100)
	SEROUT rightMotor, T2400, ("A", 100)
return
FullStop:
	PULSOUT leftMotor, 6
	PULSOUT rightMotor, 6
	SEROUT leftMotor, T2400, ("A", 0 )
	SEROUT rightMotor, T2400, ("C", 0 )
return	
QuickStop:
	PULSOUT leftMotor, 6
	PULSOUT rightMotor, 6
return

