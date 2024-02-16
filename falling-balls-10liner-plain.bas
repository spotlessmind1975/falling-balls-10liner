De S1 Sp 256
De S1 C% 32
De Sc M# Uq
De Ts C% 3

Bm En(16)

C# a0 = (Sc Hg / 100)
C# a1 = If(a0=0,1,a0)
C# a2 = 2
C# a3 = a2*a1
C# a4 = ( Sc Hg - 1 )
C# a5 = a4 - 16
C# a6 = ( Sc Wd - 1 )
C# a7 = ( Sc Hg - 12 )
C# a8 = ( Sc Wd - 1 )
C# b9 = ( Sc Wd - a3 - 12 )
C# b0 = 2*a2
C# b1 = 300
C# b2 = ( Sc Wd / 2 ) - 4
C# b3 = 20
C# b4 = Sc Rws / 2 - 4
C# b5 = Sc Cms - 11

Di x%, y%, px%, py%, dx%, dy%, v@, b6@, b7@, c8@, c9%, c0%,c1%, bx%, by%, c2@

Gb x, y, px, py, f, dx, dy, v, c9, c0, b6, b7, c1, c8, c3, bx, by, c4, c5, c6, d7, c2

c6 := Nw Im(16,10)

Prcd d8
	Lc , 1
Ee Prcd

Prcd d9
	dy = 0
	dx = 0
	y = 9
	x = b2
Ee Prcd

Prcd d0
	Wt 1000 MS
	Lc ,1: Ce "              "
	DEC b6
	c2 = 0
	d9[]
Ee Prcd

Prcd d1

	Cl Bl

	Ik GREY
	Br 0,0 To 15,3
	Ik Bu
	Dr"L16R2U3L2R16L2D3L4U3L3D3"
	c5 := Nw Im(16,4)
	Ge Im c5 Fm 0, 0

	Cl 
	Ik GREY
	Br 0,0 To 15,7
	Ik Bu
	Dr"BU8D8L15U8"
	d7 := Nw Im(16,8)
	Ge Im d7 Fm 0, 0
	
	c8 = Pt(3,1)
	
	Cl
	Ik Re
	Ci 4,4,4
	P#(4,4)
	Ik Wht
	Dr"BU2L1D1L1D1"
	c4 := Nw Im(16,10)
	Ge Im c4 Fm 0, 0
	
	Cl

	Ge Im c6 Fm 0, 0

	d9[]
	
Ee Prcd

Prcd d2
	If px <> x OR py <> y Th
		If px <> 0 OR py <> 0 Th
			Pu Im c6 At px, py
		Ei
		Ge Im c6 Fm x, y
		Pu Im c4 At x, y Wi Trs
		px = x
		py = y
	Ei
Ee Prcd

Prcd d3

	Cl
	Lc , b4
	Ik Bu
	Ce "FALLING BALLS"
	?
	Ik GREY
	Ce "press fire/space"
	?
	Ik Re
	Ce "LAST: "+STR(c9)
	
	c = 0
	Do
		d9[]
		x = RND(b9)
		Do
			Wt Vb y+16
			d2[]
			INC y:INC y
			Ex If y > a5
			c = Jf(0) OR Scc > 0
			Ex If c
		Lp
		Ex If c
		Pu Im c6 At px, py
		px = x: py = y
	Lp
	
Ee Prcd

Prcd d4
	bx = 0
	j = RND(255): c = 0
	Rpt
		If (j An 1) = 1 Th
			Pu Im c5 At bx, by
			INC c
			If c > 5 Th
				Ik GREY
				Br bx, by+8 To bx+2+a3, by+12
				Ad bx, 16
				c = 0
				j = RND(255)
			Ei			
		Ei
		j = j \ 2
		If j = 0 Th 
			j = RND(255)
		Ei
		Ad bx, 16
	Un bx > a8
Ee Prcd

Prcd d5
	Cl
	Ge Im c6 Fm 0, 0
	Rdm Tmr
	by = 24
	Rpt
		d4[]
		Ad by, 16
	Un by > a5
	bx = 8
	Rpt
		Pu Im d7 At bx, by
		Ad bx, RND(16)
		Ad bx, 20
	Un bx > b9
	Ik Bu
	Dr 0,0 To 0,a4
	Dr 0,a4 To a6,a4
	Dr a6,0 To a6,a4
Ee Prcd

Pr Prcd e6
	Do
		If dy OR dx Th
			x3 = x-3: x4 = x+4: y9 = y+9
			x9 = x+9: y4 = y+4
			If Pt(x4,y9) = Bl Th
				dy = a1
				dx = 0
				c2 = 0
			El
				dy = 0
				If dx = 0 An y < a7 Th
					If RND(100) > 50 Th
						dx = a3
					El
						dx = -a3
					Ei
				Ei
				If Pt(x4,y9) = c8 Th
					d8[]
					If c1 < b1 Th
						e7 = b1 - c1
						Ad c9, e7
						Ce "+"+STR(e7)+" points!"
					El
						Ce "no points!"
					Ei
					d0[]
				Eif y > a7 Th
					d8[]
					Ce "missed!"
					d0[]
				Eif c2 > 3 Th
					d8[]
					Ce "draw!"
					d0[]
				Eif x >= a8 An dx > 0 Th
					dx = -a3
				Eif x < a3 An dx < 0 Th
					dx = a3
				Eif Pt(x9,y4) <> Bl Th
					dx = -a3
					INC c2
				Eif Pt(x3,y4) <> Bl Th
					dx = a3
					INC c2
				Ei
			Ei
			Ad x, dx
			Ad y, dy
 			INC c1
		Ei
	Lp
Ee Prcd

Pr Prcd e8

	Do
		Wt Vb y+16
		d2[]
	Lp
	
Ee Prcd

Pr Prcd e9

	Do
		Ik GREY
		If c0 <> c9 Th
			Lc 2,0
			? c9
			c0 = c9
		Ei
		If b7 <> b6 Th
			Lc b5, 0: ? "BALLS: "; b6;" "
			b7 = b6
		Ei
		If y = 9 Th
			If ( Jl(0) OR Ky Px(Ky A) ) An x > b0 Th
				Ad x, -a3
			Ei
			If ( Jr(0) OR Ky Px(Ky D) ) An x < b9 Th
				Ad x, a3
			Ei
			If Jf(0) OR Ky Px(Ky Sp) Th
				dy = a3:y = 11
				c1 = 0
			Ei
		Ei
	Lp
		
Ee Prb

d1[]

Do

	d3[]
	
	b6 = b3
	c0 = -1
	c9 = 0
	d9[]
	d = 1
	m = 0
	px = 0
	py = 0
	
	d5[]
		
	e0 = Sw e6
	e1 = Sw e8
	e2 = Sw e9

	Do
		Ex If b6 = 0
		RUN Pr
	Lp

	Ki e0
	Ki e1
	Ki e2
	
	Lc , b4
	Ik Re
	Ce "score: "+STR(c9)
	?
	Ce "press fire/space"
	Wt Ky OR Fi Rl

Lp

 ' VARIABLE MAPPING:
 '
 ' factor -> a0
 ' speedFactor -> a1
 ' step -> a2
 ' stepSpeedFactor -> a3
 ' screenLimitH -> a4
 ' screenLimitH2 -> a5
 ' screenLimitW -> a6
 ' screenLimitBH -> a7
 ' screenLimitBW -> a8
 ' screenLimitBWB -> b9
 ' screenLimitL -> b0
 ' maxDistancePerPath -> b1
 ' startPosX -> b2
 ' maxBallPerGame -> b3
 ' centerScreenY -> b4
 ' currentBallsX -> b5
 ' currentballs -> b6
 ' oldballs -> b7
 ' winColor -> c8
 ' score -> c9
 ' oldscore -> c0
 ' distance -> c1
 ' ccd -> c2
 ' blockColor -> c3
 ' ball -> c4
 ' bar -> c5
 ' bgball -> c6
 ' basket -> d7
 ' moveToStatusLine -> d8
 ' resetBallPosition -> d9
 ' clearStatusLineAndUpdateScore -> d0
 ' prepareGraphics -> d1
 ' drawBall -> d2
 ' titleScreen -> d3
 ' drawBarrier -> d4
 ' drawBarriersAndBaskets -> d5
 ' moveBall -> e6
 ' diff -> e7
 ' drawBalls -> e8
 ' movePlayerAndDrawScore -> e9
 ' tmb -> e0
 ' tdb -> e1
 ' tmp -> e2


