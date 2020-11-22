#RISC V Snake Game using Rows x1 - x8 as game area
# Created by Jack McGirl and Meadhbh Fitzpatrick, National University of Ireland, Galway
# Creation date: November 2020


# register allocation
#  x1-x8 - Used to display snake and food
#  x9    - Used to get X coordinate for food 
#  x10   - Used for Y Cordinate for food
#  x11   - General Use Register
#  x12   - general use register 
#  x13   - general use register
#  x14   - general use register 
#  x15   - Score 

# Controls
#   Use inport (1:0) to control snake
#   Assert and Deassert 1 to turn snake counterclockwise
#   Assert and deassert 0 to turn snake clockwise