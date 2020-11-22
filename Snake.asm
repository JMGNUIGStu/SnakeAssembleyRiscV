#RISC V Snake Game using Rows x1 - x8 as game area
# Created by Jack McGirl and Meadhbh Fitzpatrick, National University of Ireland, Galway
# Creation date: November 2020


# register allocation
#  x1-x8 - Used to display snake and food
#  x9    - Used to get coordinates for food
#  x10   - Used to track Snake location + direction
#  x11   - general use register
#  x12   - general use register
#  x13   - general use register
#  x14   - Loop Counter
#  x15   - Score 

# Controls
#   Use inport (1:0) to control snake
#   Assert and Deassert 1 to turn snake clockwise
#   Assert and deassert 0 to turn snake counterclockwise

initialiseRegisters:
lui x3, 0x00010000
lui x9, 0x0bcde
addi x9, x0, 321
lui x10, 0x00010000  

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

placeFood:
# x9(3:0) - Used to get X Co ordinate for food
# x9(6:4) - Used to get Y Co Ordinate for food
# x9(7)   - Used to aid RNG
sub x12, x12            # Clear x12
add x12, x9, x0         # Store x9 value
slli x9, x9, 2          # Shift x9 Left 2 to remove upper digits
srli x9, x9, 5          # Shift x9 Right 5 to remove lower digits, x9 now contains x12(5:3)
add x13, x9, x12        # Add x9 to x12 and store in x14
slli x9,  x13, 5        # Shift x14 Left 5 to remove upper digits
srli x9, x9, 7          # Shift x9 Right 7 Digits to remove lower digits
stli x11, x9, 8         # Set x11 = 1 if x9 < 8
beq x11, 1, setFoodX    # If x11 = 1, go to setFoodX
addi x9, x0, -8         # Subtract 8 from x9
stli x11, x9, 8         # Set x11 = 1 if x9 < 8
beq x11, 1, setFoodX    # If x11 = 1, go to setFoodX

setFoodX:               # Chooses which row to place Food on depending on value of x14
beq x14, 1, setFood1    
beq x14, 2, setFood2
beq x14, 3, setFood3
beq x14, 4, setFood4
beq x14, 5, setFood5
beq x14, 6, setFood6
beq x14, 7, setFood7
beq x14, 8, setFood8
addi x14, x14, -3   # If none, subtract 3 from x14
bge x14, 8, setFoodX

moveSnake:
# If x10(7)     = 1, Snake in x1
# If x10(7)     = 2, Snake in x2
# If x10(7)     = 3, Snake in x3
# If x10(7)     = 4, Snake in x4
# If x10(7)     = 5, Snake in x5
# If x10(7)     = 6, Snake in x6
# If x10(7)     = 7, Snake in x7
# If x10(7)     = 8, Snake in x8

# If x10(0)     = 1, Snake Moving Left
# If rIn(1:0)   = 01 then x10(0) = 4 (Move snake down)
# If rIn(1:0)   = 10 then x10(0) = 2 (Move snake up)  

# If x10(0)     = 2, Snake Moving Up
# If rIn(1:0)   = 01 then x10(0) = 1 (Move snake left)
# If rIn(1:0)   = 10 then x10(0) = 3 (Move snake right)

# If x10(0)     = 3, Snake Moving Right
# If rIn(1:0)   = 01 then x10(0) = 2 (Move snake up)
# If rIn(1:0)   = 10 then x10(0) = 4 (Move snake down)  

# If x10(0)     = 4, Snake Moving Down
# If rIn(1:0)   = 01 then x10(0) = 3 (Move snake right)
# If rIn(1:0)   = 10 then x10(0) = 1 (Move snake left)  

# Move Left     = sub x10(7), x9
#                 add, x10(7)(As a register), x10(As a register) e.g. Remove food from row, multiply row by 2, add food back. This prevents the food moving away from the snake
#                 add x10(7), x9

# Move Right    = sub x10(7), x9
#                 sub, x10(7)(As a register), x10(As a register) e.g. Divide value of row by 2
#                 add x10(7), x9

# Move Up       = sub x10(7), x9
#                 add, x11, x10(7)
#                 lui x10(7)-1, x11         e.g. Write current row to x11, then move x11 into the row above and clear the starting row
#                 sub x10(7), x10(7)
#                 add x10(7), x9

# Move Down     = sub x10(7), x9
#                 add, x11, x10(7)
#                 lui x10(7)+1, x11         e.g. Write current row to x11, then move x11 into the row below and clear the starting row
#                 sub x10(7), x10(7)
#                 add x10(7), x9

checkFoodEaten:
#                       This is a bit finicky
# if x10(7)(the register i.e. current row) = x9(0)
# and if x10(7)(the value of the row the snake is in) = x9(6:1)
# Increment score by 1
# placeFood

incrementScore:
addi x15, x15, 1

killSnake:
# If x10(7) = 1     #If snake is in x1 and moves up
# And x10(0) = 2 
endGame
# If x10(7) = 8     #If snake is in x8 and moves down
# And x10(0) = 4 
endGame
# If x10(7)(vlaue of the row the snake is in) = 0xf0000000 
# And x10(0) = 1    # If snake is at far left and moves left
endGame
# If x10(7)(vlaue of the row the snake is in) = 0x0000000f
# And x10(0) = 3    # If snake is at far right and moves right
endGame
