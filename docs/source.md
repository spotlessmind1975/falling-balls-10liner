# SOURCE CODE (EXPLAINED)

Below you will find the source code of the game explained. The plain file can be read [here](../falling-balls-10liner-plain.bas), while the original (uncommented) source can be read [here](../falling-balls-10liner-original.bas). The source code has been written extensively (without abbreviations), in order to make it easier to understand. Each line has been commented to illustrate how the code works.

## INITIALIZATION (LINES 0-1)

      0 DEFINE STRING SPACE 256
        DEFINE STRING COUNT 32

These instructions are specific to [ugBasic](https://ugbasic.iwashere.eu), and they are intended to specify the actual space available to strings. The need to indicate this space depends on the fact that the rules oblige the program listing. It follows that, since the runtime module of [ugBasic](https://ugbasic.iwashere.eu) treats the source code like a "string", it is necessary to allocate an adequate amount of space for all computers in order to print it.

        DEFINE SCREEN MODE UNIQUE

This is a specific command of the  [ugBasic](https://ugbasic.iwashere.eu) language. The purpose is to ask the  [ugBasic](https://ugbasic.iwashere.eu) compiler to reduce code space by stripping out all that assembly code for graphics modes that won't be used. This command is very useful when you are certain that you are using just only one graphic mode. This command has nothing to do directly with the game algorithm.

        DEFINE TASK COUNT 3

These instructions are specific to [ugBasic](https://ugbasic.iwashere.eu), and they are intended to specify the actual space available to multitasking. Each task will occupy a specific space, and this command will allocate enough tasks to have three tasks: one to draw the ball, one to move the ball and one to recepit the user input. See [game state](./game-state.md#the-number-of-objects-a0) for more information.

        BITMAP ENABLE(16)

We ask for a resolution that gives a good number of colors. Let us remember that [ugBasic](https://ugbasic.iwashere.eu) is an isomorphic language. This means that it is not advisable to indicate a specific resolution or color or other characteristics for the graphics you want, but it is given the opportunity to suggest it. Each compiler will decide, according to the limits of hardware, what resolution and color depth of use.

        CONST a0 = (SCREEN HEIGHT / 100)
        CONST a1 = IF(a0=0,1,a0)
        CONST a2 = 2
        CONST a3 = a2*a1

First, we calculate a multiplication factor proportional to the height of the graph screen. This factor allows the ball's descent speed to be as homogeneous as possible between different targets. If the screen is so small that it gives a factor of zero, we set it back to 1. This is the step used for ball movement (2 pixel/step). Ultimately, this will really be the speed at which the ball will move.

        CONST a4 = ( SCREEN HEIGHT - 1 )
        CONST a4 = ( SCREEN HEIGHT - 1 )
        CONST a5 = a4 - 16
        CONST a6 = ( SCREEN WIDTH - 1 )
        CONST a7 = ( SCREEN HEIGHT - 12 )
        CONST a8 = ( SCREEN WIDTH - 1 )
        CONST b9 = ( SCREEN WIDTH - a3 - 12 )
        CONST b0 = 2*a2

We calculate a series of limits in the movement of the ball and in the design of game objects.

        CONST b1 = 300

We set the maximum distance value that the ball can travel to obtain a score, equal to 300 movements.

        CONST b2 = ( SCREEN WIDTH / 2 ) - 4

We calculate the initial position of the ball (in the center of the screen).

        CONST b3 = 20

Maximum number of balls per game.

        CONST b4 = SCREEN ROWS / 2 - 4
      1 CONST b5 = SCREEN COLUMNS - 11

We calculate other positions, such as the center of the screen and the position to print the words "BALLS:".

        DIM x%, y%, px%, py%, dx%, dy%, v@, b6@, b7@, c8@, _
          c9%, c0%, c1%, bx%, by%, c2@
        GLOBAL x, y, px, py, f, dx, dy, v, c9, c0, b6, b7, _
          c1, c8, c3, bx, by, c4, c5, c6, d7, c2

With these lines we define a series of variables, which will be used during the game. The variables are defined as "global", i.e. always accessible by all procedures and the main program.

        c6 := NEW IMAGE(16,10)

## SOME NEEDED PROCEDURES (LINES 2-8)

We define a graphic space (IMAGE) in which to store the background of the ball, before drawing on it. This space allows you to implement the ball as a "sprite".

        PROCEDURE d8
            LOCATE , 1
        END PROCEDURE

This is an auxiliary procedure that moves the cursor to the first line of the screen, where the game state line is.

        PROCEDURE d9
            dy = 0
            dx = 0
            y = 9
            x = b2
        END PROCEDURE

This routine places the ball back in its starting position.

        PROCEDURE d0
            WAIT 1000 MS
            LOCATE ,1: CENTER "              "
      2     DEC b6
            c2 = 0
            d9[]
        END PROCEDURE

This routine allows you to clear the status line and update the score. Moreover, it will wait for one second, move the ball to the starting position and decrement the number of balls.

        PROCEDURE d1
            CLS BLACK
            INK GREY
            BAR 0,0 TO 15,3
            INK BLUE
            DRAW"L16R2U3L2R16L2D3L4U3L3D3"
            c5 := NEW IMAGE(16,4)
            GET IMAGE c5 FROM 0, 0

This routine takes care of preparing the graphic elements of the game. First we draw the elementary bar, or the horizontal obstacle. We start by drawing the background and then draw the motif on top. The image thus drawn is stored as a "stencil", to draw it quickly.

            CLS 
            INK GREY
            BAR 0,0 TO 15,7
            INK BLUE
            DRAW"BU8D8L15U8"
            d7 := NEW IMAGE(16,8)
            GET IMAGE d7 FROM 0, 0

After that, we draw the basket. Again, we start from the background and then draw the border. The image thus drawn is stored as a "stencil", to draw it quickly.

            c8 = POINT(3,1)

This instruction allows us to retrieve what is the actual color to use to identify whether the ball has reached the basket.
            
            CLS
            INK RED
            CIRCLE 4,4,4
            PAINT(4,4)
            INK WHITE
            DRAW"BU2L1D1L1D1"
          3 c4 := NEW IMAGE(16,10)
            GET IMAGE c4 FROM 0, 0

Finally we draw the ball.

            CLS
            GET IMAGE c6 FROM 0, 0

Let's initialize the background.

            d9[]
        END PROCEDURE

Finally, we place the ball in the starting position.

        PROCEDURE d2
            IF px <> x OR py <> y THEN
                IF px <> 0 OR py <> 0 THEN
                    PUT IMAGE c6 AT px, py
                ENDIF
                GET IMAGE c6 FROM x, y
                PUT IMAGE c4 AT x, y WITH TRANSPARENCY
                px = x
                py = y
            ENDIF
        END PROCEDURE

This procedure draws the ball in motion. The prerequisite for drawing the ball is that it has moved. If in fact the previous position is different from the current one, we proceed to: restore the background in the previous position, recover the background in the new position and, finally, draw the ball in the new position, in transparency therefore "merging" the ball with the background. Eventually, the previous position is updated.

        PROCEDURE d3

            CLS
            LOCATE , b4
            INK BLUE
            CENTER "FALLING BALLS"
            PRINT
            INK GREY
            CENTER "press fire/space"
            PRINT
            INK RED
          4 CENTER "LAST: "+STR(c9)
            
We now move on to the procedure that designs the introductory screen. Then we draw the titles and the indication to press a button or the joystick FIRE in the center of the screen. We also print the last score achieved.

            c = 0
            DO
                d9[]
                x = RND(b9)
                DO
                    WAIT VBL y+16
                    d2[]
                    INC y:INC y
                    EXIT IF y > a5
                    c = JFIRE(0) OR SCANCODE > 0
                    EXIT IF c
                LOOP
                EXIT IF c
                PUT IMAGE c6 AT px, py
                px = x: py = y
            LOOP
        END PROCEDURE

This little routine moves the ball across the screen, dropping it from top to bottom. The innermost loop is responsible for drawing the ball while the outermost one is responsible for starting the movement from a random position, and to restore the screen at last. Both the internal and external ones are interrupted by pressing a button or by pressing the FIRE button on the joystick. Note that the drawing is preceded by the WAIT VBL instruction, which avoids flickering.

        PROCEDURE d4
            bx = 0
            j = RND(255): c = 0
            REPEAT
                IF (j AND 1) = 1 THEN
                    PUT IMAGE c5 AT bx, by
                    INC c
                    IF c > 5 THEN
                        INK GREY
                        BAR bx, by+8 TO bx+2+a3, by+12
                      5 ADD bx, 16
                        c = 0
                        j = RND(255)
                    ENDIF			
                ENDIF
                j = j \ 2
                IF j = 0 THEN 
                    j = RND(255)
                ENDIF
                ADD bx, 16
            UNTIL bx > a8
        END PROCEDURE

We now come to the procedure that deals with designing one of the horizontal barriers. The loop takes care of scanning the entire width of the screen. For each available space it is chosen, randomly, whether to draw the barrier there or leave it free. Every time a barrier is drawn, a count is kept. If the number of barriers designed is greater than five (5), a further obstacle is placed in the lower part of the barrier just designed while the following space will be left free. In this case, the random generator will be reinitialized.

        PROCEDURE d5
            CLS
            GET IMAGE c6 FROM 0, 0
            RANDOMIZE TIMER

This routine draws the game elements present on the screen. First, reset the ball background and initialize the random number generator.

            by = 24
            REPEAT
                d4[]
                ADD by, 16
            UNTIL by > a5

This first loop draws as many barriers as the screen can contain. We start by leaving enough room for scores and the status line and end by leaving enough room for baskets.

            bx = 8
            REPEAT
                PUT IMAGE d7 AT bx, by
                ADD bx, RND(16)
                ADD bx, 20
            UNTIL bx > b9

Now let's draw the various baskets, randomly moving them away from each other.

            INK BLUE
            DRAW 0,0 TO 0,a4
            DRAW 0,a4 TO a6,a4
            DRAW a6,0 TO a6,a4
        END PROCEDURE

Finally, we draw the edge of the screen.

      6 PARALLEL PROCEDURE e6

We now come to the first of the parallel routines, i.e. which will be implemented as a separate execution thread from the main program. This routine deals with updating the position of the ball based on a series of rules, linked to the playing field.

            DO
                IF dy OR dx THEN

The procedure is an infinite loop, which comes into operation only if the ball can move, i.e. if there is a vertical or horizontal "speed".

                    x3 = x-3: x4 = x+4: y9 = y+9
                    x9 = x+9: y4 = y+4

To speed up some calculations, let's calculate some hot points i.e. points around the ball. They are checkpoints to check for collisions.

                    IF POINT(x4,y9) = BLACK THEN
                        dy = a1
                        dx = 0
                        c2 = 0

The first case is if there is a "void" underneath the ball. In this case, the ball will drop downwards and we will also reset the bounce counter.

                    ELSE
                        dy = 0

Otherwise, we stop the ball's descent.

                        IF dx = 0 AND y < a7 THEN
                            IF RND(100) > 50 THEN
                                dx = a3
                            ELSE
                                dx = -a3
                            ENDIF
                        ENDIF

If the ball is completely still (because it has just touched a barrier), we decide a direction between left and right, at random.

                        IF POINT(x4,y9) = c8 THEN
                            d8[]
                            IF c1 < b1 THEN
                                e7 = b1 - c1
                                ADD c9, e7
                                CENTER "+"+STR(e7)+" points!"
                            ELSE
                                CENTER "no points!"
                          7 ENDIF
                            d0[]

Where the ball touches one of the baskets, the difference between the path taken and the maximum one will be calculated. A score will be assigned based on this value, which will be printed on the screen.


                        ELSEIF y > a7 THEN
                            d8[]
                            CENTER "missed!"
                            d0[]

If he has reached the end of the screen without touching the baskets, the turn will be considered a draw.

                        ELSEIF c2 > 3 THEN
                            d8[]
                            CENTER "draw!"
                            d0[]

If the ball bounces more than three times and remains on the same line, the turn will be considered a "draw".

                        ELSEIF x >= a8 AND dx > 0 THEN
                            dx = -a3
                        ELSEIF x < a3 AND dx < 0 THEN
                            dx = a3

If the ball reaches one of the edges of the screen, left or right, the direction will be reversed.

                        ELSEIF POINT(x9,y4) <> BLACK THEN
                            dx = -a3
                            INC c2
                        ELSEIF POINT(x3,y4) <> BLACK THEN
                            dx = a3
                            INC c2
                        ENDIF
                    ENDIF

If the ball touches one of the obstacles, left or right, it will reverse direction.

                    ADD x, dx
                    ADD y, dy
                    INC c1
                ENDIF
            LOOP
        END PROCEDURE

The position of the ball is updated with these lines, which also update the path taken.

        PARALLEL PROCEDURE e8
            DO
                WAIT VBL y+16
                d2[]
          8 LOOP
        END PROCEDURE

We now come to the second of the parallel routines. This routine deals with drawing the ball. It uses the WAIT VBL instruction to avoid flickering.

        PARALLEL PROCEDURE e9

Finally, the third and last of the parallel routines. This routine takes care of handling the user input and drawing the score.

        DO
            INK GREY
            IF c0 <> c9 THEN
                LOCATE 2,0
                PRINT c9
                c0 = c9
            ENDIF

We print the score if it is different from the previous one.

            IF b7 <> b6 THEN
                LOCATE b5, 0: PRINT "BALLS: "; b6;" "
                b7 = b6
            ENDIF

We do the same with "balls:".

            IF y = 9 THEN

Only if the ball is at the starting point, we will execute player's commands.

                IF ( JLEFT(0) OR KEY PRESSED(KEY A) ) AND x > b0 THEN
                    ADD x, -a3
                ENDIF

Move ball to left.

                IF ( JRIGHT(0) OR KEY PRESSED(KEY D) ) AND x < b9 THEN
                    ADD x, a3
                ENDIF

Move ball to right.

                IF JFIRE(0) OR KEY PRESSED(KEY SPACE) THEN
                    dy = a3:y = 11
                    c1 = 0
                ENDIF

Start moving ball.

                ENDIF
            LOOP
        END PROC

## MAIN PROGRAM (LINES 8-9)

      9 d1[]

From here on the main program begins. First, let's call the routine to prepare the graphic resources.

        DO
            d3[]

We show the titles.

            b6 = b3
            c0 = -1
            c9 = 0
            d9[]
            d = 1
            m = 0
            px = 0
            py = 0
                    
Initialize the game variables.

            d5[]

Let's draw the map of the barriers.

            e0 = SPAWN e6
            e1 = SPAWN e8
            e2 = SPAWN e9

Let's start a separate thread for each parallel procedure.

            DO
                EXIT IF b6 = 0
                RUN PARALLEL
            LOOP

Run an empty loop until the game is over (no balls left).

            KILL e0
            KILL e1
            KILL e2

Stops threads.

            LOCATE , b4
            INK RED
            CENTER "score: "+STR(c9)
            PRINT
            CENTER "press fire/space"
            WAIT KEY OR FIRE RELEASE

Print the final score.

            LOOP


