# Chessboard-Gameboard-Grid-editor
raylib Raygui Free Pascal, editor to create chessboard and gameboard v.099

# Functions:

You can create plain square or alernate squares in the grid.

You can update the  numbers of rows and columns.

You can update the heigth and the width of the square ( 1 to 200 pixels).

You can modify the colors : color number 1 is the color for plain square ou alternate squares.

The color number 2 is the other color for the alternate squares, and to draw the grid for the plain square.

You can update the color background.

You can draw or not the coordonates of the grid. You can choose alphabet or numbers.

You can save it. 2 files will be create, 1 the screnshot of the gameboard, 2 a csv file with comma with all data of the all square
to recreate the board ou use in your application. The file has header in the first line, the others lines are data for each square. 
you have the unique id of the square, column, row, x, y (left high point), heigth, width, rgb colors, central vector (x,y) of the square
and others

You have a function to reload the saved grids.

# What are the points of this:

You can use the grid in the screenshot to create your game (sudoku, 2048, chessboard, tic-tac-toe, etc...). You use it to put textures, pictures on it. You know the witdh and the heigth, you
can use it to detect the clic of your mouse by your program.

you can use the data to know the square for collisions.
 

![image](https://github.com/user-attachments/assets/164b5ace-b99b-48d8-8de9-f3b480d07268)



case unie 


![image](https://github.com/user-attachments/assets/042f3307-281a-4431-8e28-f07b151a12b6)

les coordonnées on été rajoutées en haut et à gauche, numeriques ou alphabetiques.
Le système graphique a été revu, le board est dessiné par l 'id de la case et non plus par le numéro de colonne et de ligne.
Bien que tous ces éléménts sont dans la structure.

![image](https://github.com/user-attachments/assets/beecf1f5-2017-488e-b52b-607667594965)

an example of chessboard with its regular notation

![image](https://github.com/user-attachments/assets/a71eb4ff-ca5d-4b5e-af49-d66b082f48de)

La sauvegarde et le rechargement d'un ancien échiquier fonctionne. la sauvegarde crée 2 fichiers, un screenshot
de l image, un fichier csv qui contient toutes les coordonées du tableau  et de ses couleurs, le vecteur central de la case.

![image](https://github.com/user-attachments/assets/ab8df150-4bf8-46ec-b27d-eea2cb676fab)

il reste à affiner les coordonnées.



