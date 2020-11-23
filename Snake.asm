#RISC V Snake Game using Rows x1 - x8 as game area
# Created by Jack McGirl and Meadhbh Fitzpatrick, National University of Ireland, Galway
# Creation date: November 2020

# register allocation
#  x1-x8 - Used to display snake and food
#  x9    - Used to get coordinates for food
#  x10   - Use to track Snake location
#  x11   - general use register
#  x12   - general use register
#  x13   - general use register
#  x14   - Used to track food location
#  x15   - Score 

# Controls
#   Use inport (3:0) to control snake
#   Assert and Deassert 3 to move snake left
#   Assert and deassert 2 to move snake up
#   Assert and Deassert 1 to move snake right
#   Assert and deassert 0 to move snake down

initialiseRegisters:
lui x4, 0x00010                 # Snake starts in middle of x4
lui x9, 0x0bcde                 # Randomizer used to place food
addi x9, x0, 321
addi x10, x0, 4                 # x10 used to track snakes vertical position

# Following block courtesy of Fearghal Morgan, National University of Ireland Galway
# We required the similar controls and delay as his target shooting game.
pollForRInport0Eq1:            # read rInport, mask bit (0), repeat until rInport(0) = 1 
 lw     x14, 0xc(x15)  
 andi   x12, x14,  1   
 beq    x12, x0, pollForRInport0Eq1 
pollForRInport0Eq0: # read rInport, mask bit (0), repeat until rInport(0) = 0
 lw     x14, 0xc(x15)
 andi   x12, x14,  1
 bne    x12, x0, pollForRInport0Eq0
mainLoop:  			         
 lui    x12, 0x00601  		       # delayCount 0x00060100. Approx 0.5 second delay for 12.5MHz clk
decrDelayCountUntil0:              # Delay Loop
 addi  x12, x12,  -1                
 bne   x12, x0,  decrDelayCountUntil0

placeFood:              # We use some of the centre elements of x9 to determine where the food will be placed. A modified middle-square method is used for psuedorandom elements and speed
sub x12, x12, x12       # Clear x12
add x12, x9, x0         # Store x9 value
slli x9, x9, 2          # Shift x9 Left 2 to remove upper digits
srli x9, x9, 5          # Shift x9 Right 5 to remove lower digits, x9 now contains x12(5:3)
add x13, x9, x12        # Add x9 to x12 and store in x13
slli x9,  x13, 5        # Shift x13 Left 5 to remove upper digits
srli x9, x9, 7          # Shift x9 Right 7 Digits to remove lower digits
slti x11, x9, 8         # Set x11 = 1 if x9 < 8
sub x12, x12, x12       # Clear x12
addi x12, x0, 1
beq x11, x12, setFoodX    # If x11 = 1, go to setFoodX
addi x9, x0, -8         # Subtract 8 from x9
slti x11, x9, 8         # Set x11 = 1 if x9 < 8
beq x11, x12, setFoodX    # If x11 = 1, go to setFoodX
sub x12, x12, x12       # Clear x12

setFoodX:               # Chooses which row to place Food on depending on value of x14
sub x12, x12, x12       # x12 is incremented from 1-8 and compared to x14 to loop correctly when they are equal
addi x12, x0, 1         # I dont know a better way to loop like this so its repeated a few times throughout
beq x14, x12, setFood1
addi x12, x0, 1
beq x14, x12, setFood2
addi x12, x0, 1
beq x14, x12, setFood3
addi x12, x0, 1
beq x14, x12, setFood4
addi x12, x0, 1
beq x14, x12, setFood5
addi x12, x0, 1
beq x14, x12, setFood6
addi x12, x0, 1
beq x14, x12, setFood7
addi x12, x0, 1
beq x14, x12, setFood8
addi x14, x14, -3       # If none, subtract 3 from x14, 3 chosen to give a pseudorandom element to placement
bge x14, x12, setFoodX

setFood1:
addi x1, x0, 1
srl x1, x1, x13             # Shift x1 Left Logical value in x13
add x9, x9, x1              # Add current value of x1 to x9 to add pseudorandom element to future x9

setFood2:
addi x2, x0, 1
srl x2, x2, x13             # Shift x2 Left Logical value in x13
add x9, x9, x2              # Add current value of x2 to x9 to add pseudorandom element to future x9

setFood3:
addi x3, x0, 1
srl x3, x3, x13             # Shift x3 Left Logical value in x13
add x9, x9, x3              # Add current value of x3 to x9 to add pseudorandom element to future x9

setFood4:
addi x4, x0, 1
srl x4, x4, x13             # Shift x4 Left Logical value in x13
add x9, x9, x4              # Add current value of x4 to x9 to add pseudorandom element to future x9

setFood5:
addi x5, x0, 1
srl x5, x5, x13             # Shift x5 Left Logical value in x13
add x9, x9, x5              # Add current value of x5 to x9 to add pseudorandom element to future x9

setFood6:
addi x6, x0, 1
srl x6, x6, x13             # Shift x6 Left Logical value in x13
add x9, x9, x6              # Add current value of x6 to x9 to add pseudorandom element to future x9

setFood7:
addi x7, x0, 1
srl x7, x7, x13             # Shift x7 Left Logical value in x13
add x9, x9, x7              # Add current value of x7 to x9 to add pseudorandom element to future x9

setFood8:
addi x8, x0, 1
srl x8, x8, x13             # Shift x8 Left Logical value in x13
add x9, x9, x8              # Add current value of x8 to x9 to add pseudorandom element to future x9

hideFoodX:               # Used when moving snake to prevent food moving also
sub x12, x12, x12        # x12 is incremented from 1-8 and compared to x14 to loop correctly when they are equal
addi x12, x0, 1
beq x14, x12, hideFood1 
addi x12, x0, 1   
beq x14, x12, hideFood2
addi x12, x0, 1
beq x14, x12, hideFood3
addi x12, x0, 1
beq x14, x12, hideFood4
addi x12, x0, 1
beq x14, x12, hideFood5
addi x12, x0, 1
beq x14, x12, hideFood6
addi x12, x0, 1
beq x14, x12, hideFood7
addi x12, x0, 1
beq x14, x12, hideFood8

hideFood1:
sub x1, x1, x1

hideFood2:
sub x2, x2, x2

hideFood3:
sub x3, x3, x3

hideFood4:
sub x4, x4, x4

hideFood5:
sub x5, x5, x5

hideFood6:
sub x6, x6, x6

hideFood7:
sub x7, x7, x7

hideFood8:
sub x8, x8, x8

moveSnakeLeftX:             # Food is removed, the snake is shifted one left. Food removed to prevent it moving away from snake when they are on the same row
beq x0, x0, hideFoodX
sub x12, x12, x12
addi x12, x0, 1
beq x10, x12, moveSnakeLeft1
addi x12, x0, 1
beq x10, x12, moveSnakeLeft2
addi x12, x0, 1
beq x10, x12, moveSnakeLeft3
addi x12, x0, 1
beq x10, x12, moveSnakeLeft4
addi x12, x0, 1
beq x10, x12, moveSnakeLeft5
addi x12, x0, 1
beq x10, x12, moveSnakeLeft6
addi x12, x0, 1
beq x10, x12, moveSnakeLeft7
addi x12, x0, 1
beq x10, x12, moveSnakeLeft8

moveSnakeLeft1:
slli x1, x1, 1
beq x0, x0, setFoodX    # Places food back in grid

moveSnakeLeft2:
slli x2, x2, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeLeft3:
slli x3, x3, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeLeft4:
slli x4, x4, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeLeft5:
slli x5, x5, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeLeft6:
slli x6, x6, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeLeft7:
slli x7, x7, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeLeft8:
slli x8, x8, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeRightX:            # Food is removed, the snake is shifted one right. Food removed to prevent it moving away from snake when they are on the same row
beq x0, x0, hideFoodX
sub x12, x12, x12
addi x12, x0, 1
beq x10, x12, moveSnakeRight1
addi x12, x0, 1
beq x10, x12, moveSnakeRight2
addi x12, x0, 1
beq x10, x12, moveSnakeRight3
addi x12, x0, 1
beq x10, x12, moveSnakeRight4
addi x12, x0, 1
beq x10, x12, moveSnakeRight5
addi x12, x0, 1
beq x10, x12, moveSnakeRight6
addi x12, x0, 1
beq x10, x12, moveSnakeRight7
addi x12, x0, 1
beq x10, x12, moveSnakeRight8

moveSnakeRight1:
srli x1, x1, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeRight2:
srli x2, x2, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeRight3:
srli x3, x3, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeRight4:
srli x4, x4, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeRight5:
srli x5, x5, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeRight6:
srli x6, x6, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeRight7:
srli x7, x7, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeRight8:
srli x8, x8, 1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeUpX:               # Food is removed, the snake is shifted one up. Food removed to prevent it moving away from snake when they are on the same column
beq x0, x0, hideFoodX
sub x12, x12, x12
addi x12, x0, 1
beq x10, x12, moveSnakeUp1
addi x12, x0, 1
beq x10, x12, moveSnakeUp2
addi x12, x0, 1
beq x10, x12, moveSnakeUp3
addi x12, x0, 1
beq x10, x12, moveSnakeUp4
addi x12, x0, 1
beq x10, x12, moveSnakeUp5
addi x12, x0, 1
beq x10, x12, moveSnakeUp6
addi x12, x0, 1
beq x10, x12, moveSnakeUp7
addi x12, x0, 1
beq x10, x12, moveSnakeUp8

moveSnakeUp1:
beq x0, x0, gameOver

moveSnakeUp2:
add x1, x2, x0
sub x2, x2, x2
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeUp3:
add x2, x3, x0
sub x3, x3, x3
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeUp4:
add x3, x4, x0
sub x4, x4, x4
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeUp5:
add x4, x5, x0
sub x5, x5, x5
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeUp6:
add x5, x6, x0
sub x6, x6, x6
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeUp7:
add x6, x7, x0
sub x7, x7, x7
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeUp8:
add x7, x8, x0
sub x8, x8, x8
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeDownX:               # Food is removed, the snake is shifted one down. Food removed to prevent it moving away from snake when they are on the same column
beq x0, x0, hideFoodX
sub x12, x12, x12
beq x10, x12, moveSnakeDown1
addi x12, x0, 1
beq x10, x12, moveSnakeDown2
addi x12, x0, 1
beq x10, x12, moveSnakeDown3
addi x12, x0, 1
beq x10, x12, moveSnakeDown4
addi x12, x0, 1
beq x10, x12, moveSnakeDown5
addi x12, x0, 1
beq x10, x12, moveSnakeDown6
addi x12, x0, 1
beq x10, x12, moveSnakeDown7
addi x12, x0, 1
beq x10, x12, moveSnakeDown8

moveSnakeDown1:
add x2, x1, x0
sub x1, x1, x1
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeDown2:
add x3, x2, x0
sub x2, x2, x2
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeDown3:
add x4, x3, x0
sub x3, x3, x3
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeDown4:
add x5, x4, x0
sub x4, x4, x4
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeDown5:
add x6, x5, x0
sub x5, x5, x5
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeDown6:
add x7, x6, x0
sub x6, x6, x6
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeDown7:
add x8, x7, x0
sub x7, x7, x7
beq x0, x0, setFoodX
beq x0, x0, checkFoodEatenColumn

moveSnakeDown8:
beq x0, x0, gameOver

checkFoodEatenColumn:
sub x12, x12, x12
addi x12, x0, 1                         # Use x12 to track food        
srl x12, x12, x13        
beq x1, x12, checkFoodEatenRow1
beq x2, x12, checkFoodEatenRow2
beq x3, x12, checkFoodEatenRow3
beq x4, x12, checkFoodEatenRow4
beq x5, x12, checkFoodEatenRow5
beq x6, x12, checkFoodEatenRow6
beq x7, x12, checkFoodEatenRow7
beq x8, x12, checkFoodEatenRow8

checkFoodEatenRow1:
beq x10, x14, incrementScore

checkFoodEatenRow2:
beq x10, x14, incrementScore

checkFoodEatenRow3:
beq x10, x14, incrementScore

checkFoodEatenRow4:
beq x10, x14, incrementScore

checkFoodEatenRow5:
beq x10, x14, incrementScore

checkFoodEatenRow6:
beq x10, x14, incrementScore

checkFoodEatenRow7:
beq x10, x14, incrementScore

checkFoodEatenRow8:
beq x10, x14, incrementScore

incrementScore:
addi x15, x15, 1
beq x0, x0, setFoodX

gameOver:
beq x0, x0, gameOver            # Infinite Loop

============================
Post-assembly program listing
PC instruction    basic assembly     original assembly             Notes
     (31:0)        code                 code 
00      0x00010237	lui x4 16	lui x4, 0x00010 # Snake starts in middle of x4
04      0x0bcde4b7	lui x9 48350	lui x9, 0x0bcde # Randomizer used to place food
08        0x14100493	addi x9 x0 321	addi x9, x0, 321
0c        0x00400513	addi x10 x0 4	addi x10, x0, 4 # x10 used to track snakes vertical position
10        0x00c7a703	lw x14 12(x15)	lw x14, 0xc(x15)
14        0x00177613	andi x12 x14 1	andi x12, x14, 1
18        0xfe060ce3	beq x12 x0 -8	beq x12, x0, pollForRInport0Eq1
1c        0x00c7a703	lw x14 12(x15)	lw x14, 0xc(x15)
20        0x00177613	andi x12 x14 1	andi x12, x14, 1
24        0xfe061ce3	bne x12 x0 -8	bne x12, x0, pollForRInport0Eq0
28        0x00601637	lui x12 1537	lui x12, 0x00601 # delayCount 0x00060100. Approx 0.5 second delay for 12.5MHz clk
2c        0xfff60613	addi x12 x12 -1	addi x12, x12, -1
30        0xfe061ee3	bne x12 x0 -4	bne x12, x0, decrDelayCountUntil0
34        0x40c60633	sub x12 x12 x12	sub x12, x12, x12 # Clear x12
38        0x00048633	add x12 x9 x0	add x12, x9, x0 # Store x9 value
3c        0x00249493	slli x9 x9 2	slli x9, x9, 2 # Shift x9 Left 2 to remove upper digits
40        0x0054d493	srli x9 x9 5	srli x9, x9, 5 # Shift x9 Right 5 to remove lower digits, x9 now contains x12(5:3)
44        0x00c486b3	add x13 x9 x12	add x13, x9, x12 # Add x9 to x12 and store in x13
48        0x00569493	slli x9 x13 5	slli x9, x13, 5 # Shift x13 Left 5 to remove upper digits
4c        0x0074d493	srli x9 x9 7	srli x9, x9, 7 # Shift x9 Right 7 Digits to remove lower digits
50        0x0084a593	slti x11 x9 8	slti x11, x9, 8 # Set x11 = 1 if x9 < 8
54        0x40c60633	sub x12 x12 x12	sub x12, x12, x12 # Clear x12
58        0x00100613	addi x12 x0 1	addi x12, x0, 1
5c        0x00c58a63	beq x11 x12 20	beq x11, x12, setFoodX # If x11 = 1, go to setFoodX
60        0xff800493	addi x9 x0 -8	addi x9, x0, -8 # Subtract 8 from x9
64        0x0084a593	slti x11 x9 8	slti x11, x9, 8 # Set x11 = 1 if x9 < 8
68        0x00c58463	beq x11 x12 8	beq x11, x12, setFoodX # If x11 = 1, go to setFoodX
6c        0x40c60633	sub x12 x12 x12	sub x12, x12, x12 # Clear x12
70        0x40c60633	sub x12 x12 x12	sub x12, x12, x12 # x12 is incremented from 1-8 and compared to x14 to loop correctly when they are equal
74        0x00100613	addi x12 x0 1	addi x12, x0, 1 # I dont know a better way to loop like this so its repeated a few times throughout
78        0x04c70263	beq x14 x12 68	beq x14, x12, setFood1
7c        0x00100613	addi x12 x0 1	addi x12, x0, 1
80        0x04c70463	beq x14 x12 72	beq x14, x12, setFood2
84        0x00100613	addi x12 x0 1	addi x12, x0, 1
88        0x04c70663	beq x14 x12 76	beq x14, x12, setFood3
8c        0x00100613	addi x12 x0 1	addi x12, x0, 1
90        0x04c70863	beq x14 x12 80	beq x14, x12, setFood4
94        0x00100613	addi x12 x0 1	addi x12, x0, 1
98        0x04c70a63	beq x14 x12 84	beq x14, x12, setFood5
9c        0x00100613	addi x12 x0 1	addi x12, x0, 1
A0        0x04c70c63	beq x14 x12 88	beq x14, x12, setFood6
A4        0x00100613	addi x12 x0 1	addi x12, x0, 1
a8        0x04c70e63	beq x14 x12 92	beq x14, x12, setFood7
ac        0x00100613	addi x12 x0 1	addi x12, x0, 1
b0        0x06c70063	beq x14 x12 96	beq x14, x12, setFood8
b4        0xffd70713	addi x14 x14 -3	addi x14, x14, -3 # If none, subtract 3 from x14, 3 chosen to give a pseudorandom element to placement
b8        0xfac75ce3	bge x14 x12 -72	bge x14, x12, setFoodX
bc        0x00100093	addi x1 x0 1	addi x1, x0, 1
c0        0x00d0d0b3	srl x1 x1 x13	srl x1, x1, x13 # Shift x1 Left Logical value in x13
c4        0x001484b3	add x9 x9 x1	add x9, x9, x1 # Add current value of x1 to x9 to add pseudorandom element to future x9
c8        0x00100113	addi x2 x0 1	addi x2, x0, 1
cc        0x00d15133	srl x2 x2 x13	srl x2, x2, x13 # Shift x2 Left Logical value in x13
d0        0x002484b3	add x9 x9 x2	add x9, x9, x2 # Add current value of x2 to x9 to add pseudorandom element to future x9
d4        0x00100193	addi x3 x0 1	addi x3, x0, 1
d8        0x00d1d1b3	srl x3 x3 x13	srl x3, x3, x13 # Shift x3 Left Logical value in x13
dc        0x003484b3	add x9 x9 x3	add x9, x9, x3 # Add current value of x3 to x9 to add pseudorandom element to future x9
e0        0x00100213	addi x4 x0 1	addi x4, x0, 1
e4        0x00d25233	srl x4 x4 x13	srl x4, x4, x13 # Shift x4 Left Logical value in x13
e8        0x004484b3	add x9 x9 x4	add x9, x9, x4 # Add current value of x4 to x9 to add pseudorandom element to future x9
ec        0x00100293	addi x5 x0 1	addi x5, x0, 1
f0        0x00d2d2b3	srl x5 x5 x13	srl x5, x5, x13 # Shift x5 Left Logical value in x13
f4        0x005484b3	add x9 x9 x5	add x9, x9, x5 # Add current value of x5 to x9 to add pseudorandom element to future x9
f8        0x00100313	addi x6 x0 1	addi x6, x0, 1
fc        0x00d35333	srl x6 x6 x13	srl x6, x6, x13 # Shift x6 Left Logical value in x13
100        0x006484b3	add x9 x9 x6	add x9, x9, x6 # Add current value of x6 to x9 to add pseudorandom element to future x9
104        0x00100393	addi x7 x0 1	addi x7, x0, 1
108        0x00d3d3b3	srl x7 x7 x13	srl x7, x7, x13 # Shift x7 Left Logical value in x13
10c        0x007484b3	add x9 x9 x7	add x9, x9, x7 # Add current value of x7 to x9 to add pseudorandom element to future x9
110        0x00100413	addi x8 x0 1	addi x8, x0, 1
114        0x00d45433	srl x8 x8 x13	srl x8, x8, x13 # Shift x8 Left Logical value in x13
118        0x008484b3	add x9 x9 x8	add x9, x9, x8 # Add current value of x8 to x9 to add pseudorandom element to future x9
11c        0x40c60633	sub x12 x12 x12	sub x12, x12, x12 # x12 is incremented from 1-8 and compared to x14 to loop correctly when they are equal
120        0x00100613	addi x12 x0 1	addi x12, x0, 1
124        0x02c70e63	beq x14 x12 60	beq x14, x12, hideFood1
128        0x00100613	addi x12 x0 1	addi x12, x0, 1
12c        0x02c70c63	beq x14 x12 56	beq x14, x12, hideFood2
130        0x00100613	addi x12 x0 1	addi x12, x0, 1
134        0x02c70a63	beq x14 x12 52	beq x14, x12, hideFood3
138        0x00100613	addi x12 x0 1	addi x12, x0, 1
13c        0x02c70863	beq x14 x12 48	beq x14, x12, hideFood4
140        0x00100613	addi x12 x0 1	addi x12, x0, 1
144        0x02c70663	beq x14 x12 44	beq x14, x12, hideFood5
148        0x00100613	addi x12 x0 1	addi x12, x0, 1
14c        0x02c70463	beq x14 x12 40	beq x14, x12, hideFood6
150        0x00100613	addi x12 x0 1	addi x12, x0, 1
154        0x02c70263	beq x14 x12 36	beq x14, x12, hideFood7
158        0x00100613	addi x12 x0 1	addi x12, x0, 1
15c        0x02c70063	beq x14 x12 32	beq x14, x12, hideFood8
160        0x401080b3	sub x1 x1 x1	sub x1, x1, x1
164        0x40210133	sub x2 x2 x2	sub x2, x2, x2
168        0x403181b3	sub x3 x3 x3	sub x3, x3, x3
16c        0x40420233	sub x4 x4 x4	sub x4, x4, x4
170        0x405282b3	sub x5 x5 x5	sub x5, x5, x5
174        0x40630333	sub x6 x6 x6	sub x6, x6, x6
178        0x407383b3	sub x7 x7 x7	sub x7, x7, x7
17c        0x40840433	sub x8 x8 x8	sub x8, x8, x8
180        0xf8000ee3	beq x0 x0 -100	beq x0, x0, hideFoodX
184        0x40c60633	sub x12 x12 x12	sub x12, x12, x12
188        0x00100613	addi x12 x0 1	addi x12, x0, 1
18c        0x02c50e63	beq x10 x12 60	beq x10, x12, moveSnakeLeft1
190        0x00100613	addi x12 x0 1	addi x12, x0, 1
194        0x02c50e63	beq x10 x12 60	beq x10, x12, moveSnakeLeft2
198        0x00100613	addi x12 x0 1	addi x12, x0, 1
19c        0x04c50063	beq x10 x12 64	beq x10, x12, moveSnakeLeft3
1a0        0x00100613	addi x12 x0 1	addi x12, x0, 1
1a4        0x04c50263	beq x10 x12 68	beq x10, x12, moveSnakeLeft4
1a8        0x00100613	addi x12 x0 1	addi x12, x0, 1
1ac        0x04c50463	beq x10 x12 72	beq x10, x12, moveSnakeLeft5
1b0        0x00100613	addi x12 x0 1	addi x12, x0, 1
1b4        0x04c50663	beq x10 x12 76	beq x10, x12, moveSnakeLeft6
1b8        0x00100613	addi x12 x0 1	addi x12, x0, 1
1bc        0x04c50863	beq x10 x12 80	beq x10, x12, moveSnakeLeft7
1c0        0x00100613	addi x12 x0 1	addi x12, x0, 1
1c4        0x04c50a63	beq x10 x12 84	beq x10, x12, moveSnakeLeft8
1c8        0x00109093	slli x1 x1 1	slli x1, x1, 1
1cc       0xea0002e3	beq x0 x0 -348	beq x0, x0, setFoodX # Places food back in grid
1d0        0x00111113	slli x2 x2 1	slli x2, x2, 1
1d4        0xe8000ee3	beq x0 x0 -356	beq x0, x0, setFoodX
1d8        0x26000463	beq x0 x0 616	beq x0, x0, checkFoodEatenColumn
1dc        0x00119193	slli x3 x3 1	slli x3, x3, 1
1e0       0xe80008e3	beq x0 x0 -368	beq x0, x0, setFoodX
1e4        0x24000e63	beq x0 x0 604	beq x0, x0, checkFoodEatenColumn
1e8        0x00121213	slli x4 x4 1	slli x4, x4, 1
1ec        0xe80002e3	beq x0 x0 -380	beq x0, x0, setFoodX
1f0        0x24000863	beq x0 x0 592	beq x0, x0, checkFoodEatenColumn
1f4        0x00129293	slli x5 x5 1	slli x5, x5, 1
1f8        0xe6000ce3	beq x0 x0 -392	beq x0, x0, setFoodX
1fc        0x24000263	beq x0 x0 580	beq x0, x0, checkFoodEatenColumn
200        0x00131313	slli x6 x6 1	slli x6, x6, 1
204        0xe60006e3	beq x0 x0 -404	beq x0, x0, setFoodX
208        0x22000c63	beq x0 x0 568	beq x0, x0, checkFoodEatenColumn
20c        0x00139393	slli x7 x7 1	slli x7, x7, 1
210        0xe60000e3	beq x0 x0 -416	beq x0, x0, setFoodX
214        0x22000663	beq x0 x0 556	beq x0, x0, checkFoodEatenColumn
218       0x00141413	slli x8 x8 1	slli x8, x8, 1
21c        0xe4000ae3	beq x0 x0 -428	beq x0, x0, setFoodX
220      0x22000063	beq x0 x0 544	beq x0, x0, checkFoodEatenColumn
224      0xee000ce3	beq x0 x0 -264	beq x0, x0, hideFoodX
228      0x40c60633	sub x12 x12 x12	sub x12, x12, x12
22c      0x00100613	addi x12 x0 1	addi x12, x0, 1
230        0x02c50e63	beq x10 x12 60	beq x10, x12, moveSnakeRight1
234        0x00100613	addi x12 x0 1	addi x12, x0, 1
238        0x04c50063	beq x10 x12 64	beq x10, x12, moveSnakeRight2
23c        0x00100613	addi x12 x0 1	addi x12, x0, 1
240        0x04c50263	beq x10 x12 68	beq x10, x12, moveSnakeRight3
244        0x00100613	addi x12 x0 1	addi x12, x0, 1
248        0x04c50463	beq x10 x12 72	beq x10, x12, moveSnakeRight4
24c        0x00100613	addi x12 x0 1	addi x12, x0, 1
250        0x04c50663	beq x10 x12 76	beq x10, x12, moveSnakeRight5
254        0x00100613	addi x12 x0 1	addi x12, x0, 1
258        0x04c50863	beq x10 x12 80	beq x10, x12, moveSnakeRight6
25c        0x00100613	addi x12 x0 1	addi x12, x0, 1
260        0x04c50a63	beq x10 x12 84	beq x10, x12, moveSnakeRight7
264        0x00100613	addi x12 x0 1	addi x12, x0, 1
268        0x04c50c63	beq x10 x12 88	beq x10, x12, moveSnakeRight8
26c        0x0010d093	srli x1 x1 1	srli x1, x1, 1
270        0xe00000e3	beq x0 x0 -512	beq x0, x0, setFoodX
274        0x1c000663	beq x0 x0 460	beq x0, x0, checkFoodEatenColumn
278        0x00115113	srli x2 x2 1	srli x2, x2, 1
27c        0xde000ae3	beq x0 x0 -524	beq x0, x0, setFoodX
280        0x1c000063	beq x0 x0 448	beq x0, x0, checkFoodEatenColumn
284        0x0011d193	srli x3 x3 1	srli x3, x3, 1
288        0xde0004e3	beq x0 x0 -536	beq x0, x0, setFoodX
28c        0x1a000a63	beq x0 x0 436	beq x0, x0, checkFoodEatenColumn
290      0x00125213	srli x4 x4 1	srli x4, x4, 1
294        0xdc000ee3	beq x0 x0 -548	beq x0, x0, setFoodX
298      0x1a000463	beq x0 x0 424	beq x0, x0, checkFoodEatenColumn
29c      0x0012d293	srli x5 x5 1	srli x5, x5, 1
2a0      0xdc0008e3	beq x0 x0 -560	beq x0, x0, setFoodX
2a4      0x18000e63	beq x0 x0 412	beq x0, x0, checkFoodEatenColumn
2a8      0x00135313	srli x6 x6 1	srli x6, x6, 1
2ac      0xdc0002e3	beq x0 x0 -572	beq x0, x0, setFoodX
2b0      0x18000863	beq x0 x0 400	beq x0, x0, checkFoodEatenColumn
2b4      0x0013d393	srli x7 x7 1	srli x7, x7, 1
2b8      0xda000ce3	beq x0 x0 -584	beq x0, x0, setFoodX
2bc      0x18000263	beq x0 x0 388	beq x0, x0, checkFoodEatenColumn
2c0      0x00145413	srli x8 x8 1	srli x8, x8, 1
2c4      0xda0006e3	beq x0 x0 -596	beq x0, x0, setFoodX
2c8      0x16000c63	beq x0 x0 376	beq x0, x0, checkFoodEatenColumn
2cc      0xe40008e3	beq x0 x0 -432	beq x0, x0, hideFoodX
2d0      0x40c60633	sub x12 x12 x12	sub x12, x12, x12
2d4      0x00100613	addi x12 x0 1	addi x12, x0, 1
2d8      0x02c50e63	beq x10 x12 60	beq x10, x12, moveSnakeUp1
2dc      0x00100613	addi x12 x0 1	addi x12, x0, 1
2e0      0x02c50c63	beq x10 x12 56	beq x10, x12, moveSnakeUp2
2e4      0x00100613	addi x12 x0 1	addi x12, x0, 1
2e8      0x04c50063	beq x10 x12 64	beq x10, x12, moveSnakeUp3
2ec        0x00100613	addi x12 x0 1	addi x12, x0, 1
2f0    0x04c50463	beq x10 x12 72	beq x10, x12, moveSnakeUp4
2f4      0x00100613	addi x12 x0 1	addi x12, x0, 1
2f8      0x04c50863	beq x10 x12 80	beq x10, x12, moveSnakeUp5
2fc      0x00100613	addi x12 x0 1	addi x12, x0, 1
300        0x04c50c63	beq x10 x12 88	beq x10, x12, moveSnakeUp6
304        0x00100613	addi x12 x0 1	addi x12, x0, 1
308      0x06c50063	beq x10 x12 96	beq x10, x12, moveSnakeUp7
30c      0x00100613	addi x12 x0 1	addi x12, x0, 1
310      0x06c50463	beq x10 x12 104	beq x10, x12, moveSnakeUp8
314       0x18000063	beq x0 x0 384	beq x0, x0, gameOver
318      0x000100b3	add x1 x2 x0	add x1, x2, x0
31c      0x40210133	sub x2 x2 x2	sub x2, x2, x2
320      0xd40008e3	beq x0 x0 -688	beq x0, x0, setFoodX
324      0x10000e63	beq x0 x0 284	beq x0, x0, checkFoodEatenColumn
328      0x00018133	add x2 x3 x0	add x2, x3, x0
32c      0x403181b3	sub x3 x3 x3	sub x3, x3, x3
330      0xd40000e3	beq x0 x0 -704	beq x0, x0, setFoodX
334      0x10000663	beq x0 x0 268	beq x0, x0, checkFoodEatenColumn
338      0x000201b3	add x3 x4 x0	add x3, x4, x0
33c      0x40420233	sub x4 x4 x4	sub x4, x4, x4
340      0xd20008e3	beq x0 x0 -720	beq x0, x0, setFoodX
344      0x0e000e63	beq x0 x0 252	beq x0, x0, checkFoodEatenColumn
348      0x00028233	add x4 x5 x0	add x4, x5, x0
34c      0x405282b3	sub x5 x5 x5	sub x5, x5, x5
350      0xd20000e3	beq x0 x0 -736	beq x0, x0, setFoodX
354      0x0e000663	beq x0 x0 236	beq x0, x0, checkFoodEatenColumn
358      0x000302b3	add x5 x6 x0	add x5, x6, x0
35c      0x40630333	sub x6 x6 x6	sub x6, x6, x6
360      0xd00008e3	beq x0 x0 -752	beq x0, x0, setFoodX
364      0x0c000e63	beq x0 x0 220	beq x0, x0, checkFoodEatenColumn
368      0x00038333	add x6 x7 x0	add x6, x7, x0
36c      0x407383b3	sub x7 x7 x7	sub x7, x7, x7
370      0xd00000e3	beq x0 x0 -768	beq x0, x0, setFoodX
374      0x0c000663	beq x0 x0 204	beq x0, x0, checkFoodEatenColumn
378      0x000403b3	add x7 x8 x0	add x7, x8, x0
37c      0x40840433	sub x8 x8 x8	sub x8, x8, x8
380      0xce0008e3	beq x0 x0 -784	beq x0, x0, setFoodX
384      0x0a000e63	beq x0 x0 188	beq x0, x0, checkFoodEatenColumn
388      0xd8000ae3	beq x0 x0 -620	beq x0, x0, hideFoodX
38c      0x40c60633	sub x12 x12 x12	sub x12, x12, x12
390      0x02c50e63	beq x10 x12 60	beq x10, x12, moveSnakeDown1
394      0x00100613	addi x12 x0 1	addi x12, x0, 1
398      0x04c50263	beq x10 x12 68	beq x10, x12, moveSnakeDown2
39c      0x00100613	addi x12 x0 1	addi x12, x0, 1
3a0      0x04c50663	beq x10 x12 76	beq x10, x12, moveSnakeDown3
3a4      0x00100613	addi x12 x0 1	addi x12, x0, 1
3a8      0x04c50a63	beq x10 x12 84	beq x10, x12, moveSnakeDown4
3ac      0x00100613	addi x12 x0 1	addi x12, x0, 1
3b0      0x04c50e63	beq x10 x12 92	beq x10, x12, moveSnakeDown5
3b4      0x00100613	addi x12 x0 1	addi x12, x0, 1
3b8      0x06c50263	beq x10 x12 100	beq x10, x12, moveSnakeDown6
3bc      0x00100613	addi x12 x0 1	addi x12, x0, 1
3c0      0x06c50663	beq x10 x12 108	beq x10, x12, moveSnakeDown7
3c4     0x00100613	addi x12 x0 1	addi x12, x0, 1
3c8      0x06c50a63	beq x10 x12 116	beq x10, x12, moveSnakeDown8
3cc      0x00008133	add x2 x1 x0	add x2, x1, x0
3d0      0x401080b3	sub x1 x1 x1	sub x1, x1, x1
3d4      0xc8000ee3	beq x0 x0 -868	beq x0, x0, setFoodX
3d8      0x06000463	beq x0 x0 104	beq x0, x0, checkFoodEatenColumn
3dc      0x000101b3	add x3 x2 x0	add x3, x2, x0
3e0      0x40210133	sub x2 x2 x2	sub x2, x2, x2
3e4      0xc80006e3	beq x0 x0 -884	beq x0, x0, setFoodX
3e8      0x04000c63	beq x0 x0 88	beq x0, x0, checkFoodEatenColumn
3ec      0x00018233	add x4 x3 x0	add x4, x3, x0
3f0      0x403181b3	sub x3 x3 x3	sub x3, x3, x3
3f4      0xc6000ee3	beq x0 x0 -900	beq x0, x0, setFoodX
3f8      0x04000463	beq x0 x0 72	beq x0, x0, checkFoodEatenColumn
3fc      0x000202b3	add x5 x4 x0	add x5, x4, x0
400      0x40420233	sub x4 x4 x4	sub x4, x4, x4
404      0xc60006e3	beq x0 x0 -916	beq x0, x0, setFoodX
408      0x02000c63	beq x0 x0 56	beq x0, x0, checkFoodEatenColumn
40c      0x00028333	add x6 x5 x0	add x6, x5, x0
410      0x405282b3	sub x5 x5 x5	sub x5, x5, x5
414      0xc4000ee3	beq x0 x0 -932	beq x0, x0, setFoodX
418      0x02000463	beq x0 x0 40	beq x0, x0, checkFoodEatenColumn
41c      0x000303b3	add x7 x6 x0	add x7, x6, x0
420      0x40630333	sub x6 x6 x6	sub x6, x6, x6
424      0xc40006e3	beq x0 x0 -948	beq x0, x0, setFoodX
428      0x00000c63	beq x0 x0 24	beq x0, x0, checkFoodEatenColumn
42c      0x00038433	add x8 x7 x0	add x8, x7, x0
430      0x407383b3	sub x7 x7 x7	sub x7, x7, x7
434      0xc2000ee3	beq x0 x0 -964	beq x0, x0, setFoodX
438      0x00000463	beq x0 x0 8	beq x0, x0, checkFoodEatenColumn
43c      0x04000c63	beq x0 x0 88	beq x0, x0, gameOver
440      0x40c60633	sub x12 x12 x12	sub x12, x12, x12
444      0x00100613	addi x12 x0 1	addi x12, x0, 1 # Use x12 to track food
448      0x00d65633	srl x12 x12 x13	srl x12, x12, x13
44c      0x02c08063	beq x1 x12 32	beq x1, x12, checkFoodEatenRow1
450      0x02c10063	beq x2 x12 32	beq x2, x12, checkFoodEatenRow2
454      0x02c18063	beq x3 x12 32	beq x3, x12, checkFoodEatenRow3
458      0x02c20063	beq x4 x12 32	beq x4, x12, checkFoodEatenRow4
45c      0x02c28063	beq x5 x12 32	beq x5, x12, checkFoodEatenRow5
460      0x02c30063	beq x6 x12 32	beq x6, x12, checkFoodEatenRow6
464      0x02c38063	beq x7 x12 32	beq x7, x12, checkFoodEatenRow7
468      0x02c40063	beq x8 x12 32	beq x8, x12, checkFoodEatenRow8
46c      0x02e50063	beq x10 x14 32	beq x10, x14, incrementScore
470      0x00e50e63	beq x10 x14 28	beq x10, x14, incrementScore
474      0x00e50c63	beq x10 x14 24	beq x10, x14, incrementScore
478      0x00e50a63	beq x10 x14 20	beq x10, x14, incrementScore
47c      0x00e50863	beq x10 x14 16	beq x10, x14, incrementScore
480      0x00e50663	beq x10 x14 12	beq x10, x14, incrementScore
484      0x00e50463	beq x10 x14 8	beq x10, x14, incrementScore
488      0x00e50263	beq x10 x14 4	beq x10, x14, incrementScore
48c      0x00178793	addi x15 x15 1	addi x15, x15, 1
490      0xbe0000e3	beq x0 x0 -1056	beq x0, x0, setFoodX
494      0x00000063	beq x0 x0 0	beq x0, x0, gameOver # Infinite Loop

============================
Venus 'dump' program binary. No of instructions n = 11

00010237
0bcde4b7
14100493
00400513
00c7a703
00177613
fe060ce3
00c7a703
00177613
fe061ce3
00601637
fff60613
fe061ee3
40c60633
00048633
00249493
0054d493
00c486b3
00569493
0074d493
0084a593
40c60633
00100613
00c58a63
ff800493
0084a593
00c58463
40c60633
40c60633
00100613
04c70263
00100613
04c70463
00100613
04c70663
00100613
04c70863
00100613
04c70a63
00100613
04c70c63
00100613
04c70e63
00100613
06c70063
ffd70713
fac75ce3
00100093
00d0d0b3
001484b3
00100113
00d15133
002484b3
00100193
00d1d1b3
003484b3
00100213
00d25233
004484b3
00100293
00d2d2b3
005484b3
00100313
00d35333
006484b3
00100393
00d3d3b3
007484b3
00100413
00d45433
008484b3
40c60633
00100613
02c70e63
00100613
02c70c63
00100613
02c70a63
00100613
02c70863
00100613
02c70663
00100613
02c70463
00100613
02c70263
00100613
02c70063
401080b3
40210133
403181b3
40420233
405282b3
40630333
407383b3
40840433
f8000ee3
40c60633
00100613
02c50e63
00100613
02c50e63
00100613
04c50063
00100613
04c50263
00100613
04c50463
00100613
04c50663
00100613
04c50863
00100613
04c50a63
00109093
ea0002e3
00111113
e8000ee3
26000463
00119193
e80008e3
24000e63
00121213
e80002e3
24000863
00129293
e6000ce3
24000263
00131313
e60006e3
22000c63
00139393
e60000e3
22000663
00141413
e4000ae3
22000063
ee000ce3
40c60633
00100613
02c50e63
00100613
04c50063
00100613
04c50263
00100613
04c50463
00100613
04c50663
00100613
04c50863
00100613
04c50a63
00100613
04c50c63
0010d093
e00000e3
1c000663
00115113
de000ae3
1c000063
0011d193
de0004e3
1a000a63
00125213
dc000ee3
1a000463
0012d293
dc0008e3
18000e63
00135313
dc0002e3
18000863
0013d393
da000ce3
18000263
00145413
da0006e3
16000c63
e40008e3
40c60633
00100613
02c50e63
00100613
02c50c63
00100613
04c50063
00100613
04c50463
00100613
04c50863
00100613
04c50c63
00100613
06c50063
00100613
06c50463
18000063
000100b3
40210133
d40008e3
10000e63
00018133
403181b3
d40000e3
10000663
000201b3
40420233
d20008e3
0e000e63
00028233
405282b3
d20000e3
0e000663
000302b3
40630333
d00008e3
0c000e63
00038333
407383b3
d00000e3
0c000663
000403b3
40840433
ce0008e3
0a000e63
d8000ae3
40c60633
02c50e63
00100613
04c50263
00100613
04c50663
00100613
04c50a63
00100613
04c50e63
00100613
06c50263
00100613
06c50663
00100613
06c50a63
00008133
401080b3
c8000ee3
06000463
000101b3
40210133
c80006e3
04000c63
00018233
403181b3
c6000ee3
04000463
000202b3
40420233
c60006e3
02000c63
00028333
405282b3
c4000ee3
02000463
000303b3
40630333
c40006e3
00000c63
00038433
407383b3
c2000ee3
00000463
04000c63
40c60633
00100613
00d65633
02c08063
02c10063
02c18063
02c20063
02c28063
02c30063
02c38063
02c40063
02e50063
00e50e63
00e50c63
00e50a63
00e50863
00e50663
00e50463
00e50263
00178793
be0000e3
00000063


============================
Program binary formatted, for use in vicilogic online RISC-V processor
i.e, 8x32-bit instructions, 
000102370bcde4b7141004930040051300c7a70300177613fe060ce300c7a703
00177613fe061ce300601637fff60613fe061ee340c606330004863300249493
0054d49300c486b3005694930074d4930084a59340c606330010061300c58a63
ff8004930084a59300c5846340c6063340c606330010061304c7026300100613
04c704630010061304c706630010061304c708630010061304c70a6300100613
04c70c630010061304c70e630010061306c70063ffd70713fac75ce300100093
00d0d0b3001484b30010011300d15133002484b30010019300d1d1b3003484b3
0010021300d25233004484b30010029300d2d2b3005484b30010031300d35333
006484b30010039300d3d3b3007484b30010041300d45433008484b340c60633
0010061302c70e630010061302c70c630010061302c70a630010061302c70863
0010061302c706630010061302c704630010061302c702630010061302c70063
401080b340210133403181b340420233405282b340630333407383b340840433
f8000ee340c606330010061302c50e630010061302c50e630010061304c50063
0010061304c502630010061304c504630010061304c506630010061304c50863
0010061304c50a6300109093ea0002e300111113e8000ee32600046300119193
e80008e324000e6300121213e80002e32400086300129293e6000ce324000263
00131313e60006e322000c6300139393e60000e32200066300141413e4000ae3
22000063ee000ce340c606330010061302c50e630010061304c5006300100613
04c502630010061304c504630010061304c506630010061304c5086300100613
04c50a630010061304c50c630010d093e00000e31c00066300115113de000ae3
1c0000630011d193de0004e31a000a6300125213dc000ee31a0004630012d293
dc0008e318000e6300135313dc0002e3180008630013d393da000ce318000263
00145413da0006e316000c63e40008e340c606330010061302c50e6300100613
02c50c630010061304c500630010061304c504630010061304c5086300100613
04c50c630010061306c500630010061306c5046318000063000100b340210133
d40008e310000e6300018133403181b3d40000e310000663000201b340420233
d20008e30e000e6300028233405282b3d20000e30e000663000302b340630333
d00008e30c000e6300038333407383b3d00000e30c000663000403b340840433
ce0008e30a000e63d8000ae340c6063302c50e630010061304c5026300100613
04c506630010061304c50a630010061304c50e630010061306c5026300100613
06c506630010061306c50a6300008133401080b3c8000ee306000463000101b3
40210133c80006e304000c6300018233403181b3c6000ee304000463000202b3
40420233c60006e302000c6300028333405282b3c4000ee302000463000303b3
40630333c40006e300000c6300038433407383b3c2000ee30000046304000c63
40c606330010061300d6563302c0806302c1006302c1806302c2006302c28063
02c3006302c3806302c4006302e5006300e50e6300e50c6300e50a6300e50863
00e5066300e5046300e5026300178793be0000e3000000630000000000000000
