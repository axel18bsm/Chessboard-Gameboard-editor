# Chessboard-Gameboard-Grid-editor
Raylib Raygui Free Pascal Lazarus, editor to create chessboard and gameboard v.099

# Functions:

You can create plain square or alernate squares in the grid.

You can update the  numbers of rows and columns.

You can update the heigth and the width of the square ( 1 to 200 pixels).

You can modify the colors : color number 1 is the color for plain square ou alternate squares.

The color number 2 is the other color for the alternate squares, and to draw the grid for the plain square.

You can update the color background.

A superb tic tac toe grid 

![image](https://github.com/user-attachments/assets/d78ff263-0700-4184-b1f1-36bfe6152e22)


You can draw or not the coordonates of the grid. You can choose alphabet or numbers.

You can save it. 2 files will be create, 1 the screnshot of the gameboard, 2 a csv file with comma with all data of the all square
to recreate the board ou use in your application. The file has header in the first line, the others lines are data for each square. 
you have the unique id of the square, column, row, x, y (left high point), heigth, width, rgb colors, central vector (x,y) of the square
and others

You have a function to reload the saved grids.

Classical Chessboard with coordonates

![image](https://github.com/user-attachments/assets/17b8c379-18a0-4c74-970b-a6690c7b95f4)



# What are the points of this:

You can use the grid in the screenshot to create your game (sudoku, 2048, chessboard, tic-tac-toe, etc...). You use it to put textures, pictures on it. You know the witdh and the heigth, you
can use it to detect the clic of your mouse by your program.

you can use the data to know the square for collisions.
 
# Installation :

1) You create a directory in windows.
2) put the raylib.dll and echiquier.exe files in this directory.
3) Create in the main directory, a second one  with the name "gui_styles"
4) in the last directory, put all files from the amber directory. (If you miss this step, it s not important, the gui takes the standard one)
5)  That s all folks !

The saved grids ans screenshots will be in the main directory with the names screenshot_xxx.png and echiquier_xxx.csv. 
XXX are the same number.

# Technically and new compilation :
Use Lazarus and free Pascal, you must have the headers of raylib and raygui to compile. Headers from Guvacode (Thanks to him)
You load the file.lpr and you play with the code.

