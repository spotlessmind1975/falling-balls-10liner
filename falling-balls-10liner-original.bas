DEFINE STRING SPACE 256
DEFINE STRING COUNT 32
DEFINE SCREEN MODE UNIQUE
DEFINE TASK COUNT 3

BITMAP ENABLE(16)

CONST factor = (SCREEN HEIGHT / 100)
CONST speedFactor = IF(factor=0,1,factor)
CONST step = 2
CONST stepSpeedFactor = step*speedFactor
CONST screenLimitH = ( SCREEN HEIGHT - 1 )
CONST screenLimitH2 = screenLimitH - 16
CONST screenLimitW = ( SCREEN WIDTH - 1 )
CONST screenLimitBH = ( SCREEN HEIGHT - 12 )
CONST screenLimitBW = ( SCREEN WIDTH - 1 )
CONST screenLimitBWB = ( SCREEN WIDTH - stepSpeedFactor - 12 )
CONST screenLimitL = 2*step
CONST maxDistancePerPath = 300
CONST startPosX = ( SCREEN WIDTH / 2 ) - 4
CONST maxBallPerGame = 20
CONST centerScreenY = SCREEN ROWS / 2 - 4
CONST currentBallsX = SCREEN COLUMNS - 11

DIM x%, y%, px%, py%, dx%, dy%, v@, currentballs@, oldballs@, winColor@, score%, oldscore%,distance%, bx%, by%, ccd@

GLOBAL x, y, px, py, f, dx, dy, v, score, oldscore, currentballs, oldballs, distance, winColor, blockColor, bx, by, ball, bar, bgball, basket, ccd

bgball := NEW IMAGE(16,10)

PROCEDURE moveToStatusLine
	LOCATE , 1
END PROCEDURE

PROCEDURE resetBallPosition
	dy = 0
	dx = 0
	y = 9
	x = startPosX
END PROCEDURE

PROCEDURE clearStatusLineAndUpdateScore
	WAIT 1000 MS
	LOCATE ,1: CENTER "              "
	DEC currentballs
	ccd = 0
	resetBallPosition[]
END PROCEDURE

PROCEDURE prepareGraphics

	CLS BLACK

	INK GREY
	BAR 0,0 TO 15,3
	INK BLUE
	DRAW"L16R2U3L2R16L2D3L4U3L3D3"
	bar := NEW IMAGE(16,4)
	GET IMAGE bar FROM 0, 0

	CLS 
	INK GREY
	BAR 0,0 TO 15,7
	INK BLUE
	DRAW"BU8D8L15U8"
	basket := NEW IMAGE(16,8)
	GET IMAGE basket FROM 0, 0
	
	winColor = POINT(3,1)
	
	CLS
	INK RED
	CIRCLE 4,4,4
	PAINT(4,4)
	INK WHITE
	DRAW"BU2L1D1L1D1"
	ball := NEW IMAGE(16,10)
	GET IMAGE ball FROM 0, 0
	
	CLS

	GET IMAGE bgball FROM 0, 0

	resetBallPosition[]
	
END PROCEDURE

PROCEDURE drawBall
	IF px <> x OR py <> y THEN
		IF px <> 0 OR py <> 0 THEN
			PUT IMAGE bgball AT px, py
		ENDIF
		GET IMAGE bgball FROM x, y
		PUT IMAGE ball AT x, y WITH TRANSPARENCY
		px = x
		py = y
	ENDIF
END PROCEDURE

PROCEDURE titleScreen

	CLS
	LOCATE , centerScreenY
	INK BLUE
	CENTER "FALLING BALLS"
	PRINT
	INK GREY
	CENTER "press fire/space"
	PRINT
	INK RED
	CENTER "LAST: "+STR(score)
	
	c = 0
	DO
		resetBallPosition[]
		x = RND(screenLimitBWB)
		DO
			WAIT VBL y+16
			drawBall[]
			INC y:INC y
			EXIT IF y > screenLimitH2
			c = JFIRE(0) OR SCANCODE > 0
			EXIT IF c
		LOOP
		EXIT IF c
		PUT IMAGE bgball AT px, py
		px = x: py = y
	LOOP
	
END PROCEDURE

PROCEDURE drawBarrier
	bx = 0
	j = RND(255): c = 0
	REPEAT
		IF (j AND 1) = 1 THEN
			PUT IMAGE bar AT bx, by
			INC c
			IF c > 5 THEN
				INK GREY
				BAR bx, by+8 TO bx+2+stepSpeedFactor, by+12
				ADD bx, 16
				c = 0
				j = RND(255)
			ENDIF			
		ENDIF
		j = j \ 2
		IF j = 0 THEN 
			j = RND(255)
		ENDIF
		ADD bx, 16
	UNTIL bx > screenLimitBW
END PROCEDURE

PROCEDURE drawBarriersAndBaskets
	CLS
	GET IMAGE bgball FROM 0, 0
	RANDOMIZE TIMER
	by = 24
	REPEAT
		drawBarrier[]
		ADD by, 16
	UNTIL by > screenLimitH2
	bx = 8
	REPEAT
		PUT IMAGE basket AT bx, by
		ADD bx, RND(16)
		ADD bx, 20
	UNTIL bx > screenLimitBWB
	INK BLUE
	DRAW 0,0 TO 0,screenLimitH
	DRAW 0,screenLimitH TO screenLimitW,screenLimitH
	DRAW screenLimitW,0 TO screenLimitW,screenLimitH
END PROCEDURE

PARALLEL PROCEDURE moveBall
	DO
		IF dy OR dx THEN
			x3 = x-3: x4 = x+4: y9 = y+9
			x9 = x+9: y4 = y+4
			IF POINT(x4,y9) = BLACK THEN
				dy = speedFactor
				dx = 0
				ccd = 0
			ELSE
				dy = 0
				IF dx = 0 AND y < screenLimitBH THEN
					IF RND(100) > 50 THEN
						dx = stepSpeedFactor
					ELSE
						dx = -stepSpeedFactor
					ENDIF
				ENDIF
				IF POINT(x4,y9) = winColor THEN
					moveToStatusLine[]
					IF distance < maxDistancePerPath THEN
						diff = maxDistancePerPath - distance
						ADD score, diff
						CENTER "+"+STR(diff)+" points!"
					ELSE
						CENTER "no points!"
					ENDIF
					clearStatusLineAndUpdateScore[]
				ELSEIF y > screenLimitBH THEN
					moveToStatusLine[]
					CENTER "missed!"
					clearStatusLineAndUpdateScore[]
				ELSEIF ccd > 3 THEN
					moveToStatusLine[]
					CENTER "draw!"
					clearStatusLineAndUpdateScore[]
				ELSEIF x >= screenLimitBW AND dx > 0 THEN
					dx = -stepSpeedFactor
				ELSEIF x < stepSpeedFactor AND dx < 0 THEN
					dx = stepSpeedFactor
				ELSEIF POINT(x9,y4) <> BLACK THEN
					dx = -stepSpeedFactor
					INC ccd
				ELSEIF POINT(x3,y4) <> BLACK THEN
					dx = stepSpeedFactor
					INC ccd
				ENDIF
			ENDIF
			ADD x, dx
			ADD y, dy
 			INC distance
		ENDIF
	LOOP
END PROCEDURE

PARALLEL PROCEDURE drawBalls

	DO
		WAIT VBL y+16
		drawBall[]
	LOOP
	
END PROCEDURE

PARALLEL PROCEDURE movePlayerAndDrawScore

	DO
		INK GREY
		IF oldscore <> score THEN
			LOCATE 2,0
			PRINT score
			oldscore = score
		ENDIF
		IF oldballs <> currentballs THEN
			LOCATE currentBallsX, 0: PRINT "BALLS: "; currentballs;" "
			oldballs = currentballs
		ENDIF
		IF y = 9 THEN
			IF ( JLEFT(0) OR KEY PRESSED(KEY A) ) AND x > screenLimitL THEN
				ADD x, -stepSpeedFactor
			ENDIF
			IF ( JRIGHT(0) OR KEY PRESSED(KEY D) ) AND x < screenLimitBWB THEN
				ADD x, stepSpeedFactor
			ENDIF
			IF JFIRE(0) OR KEY PRESSED(KEY SPACE) THEN
				dy = stepSpeedFactor:y = 11
				distance = 0
			ENDIF
		ENDIF
	LOOP
		
END PROC

prepareGraphics[]

DO

	titleScreen[]
	
	currentballs = maxBallPerGame
	oldscore = -1
	score = 0
	resetBallPosition[]
	d = 1
	m = 0
	px = 0
	py = 0
	
	drawBarriersAndBaskets[]
		
	tmb = SPAWN moveBall
	tdb = SPAWN drawBalls
	tmp = SPAWN movePlayerAndDrawScore

	DO
		EXIT IF currentballs = 0
		RUN PARALLEL
	LOOP

	KILL tmb
	KILL tdb
	KILL tmp
	
	LOCATE , centerScreenY
	INK RED
	CENTER "score: "+STR(score)
	PRINT
	CENTER "press fire/space"
	WAIT KEY OR FIRE RELEASE

LOOP
