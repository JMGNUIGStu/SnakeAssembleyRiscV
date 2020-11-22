#RISC V Snake Game using Rows x1 - x8 as game area
# Created by Jack McGirl and Meadhbh Fitzpatrick, National University of Ireland, Galway
# Creation date: November 2020


# register allocation
#  x1-x8 - Used to display snake and food
#  x9    - Used to get coordinates for food
#  x10   - Used Snake location
#  x11   - General Use Register
#  x12   - general use register 
#  x13   - general use register
#  x14   - general use register 
#  x15   - Score 

# Controls
#   Use inport (1:0) to control snake
#   Assert and Deassert 1 to turn snake counterclockwise
#   Assert and deassert 0 to turn snake clockwise

initialiseRegisters:
lui x3, 0x00010000
lui x9, 0x0bcde
addi x9, x0, 321
lui x10  

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

moveSnake:

checkFoodEaten:

incrementScore:

killSnake: