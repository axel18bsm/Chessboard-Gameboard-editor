unit plateauMle;

{$mode ObjFPC}{$H+} {$modeSwitch advancedRecords}

interface

uses
  Classes, SysUtils,raylib,raygui;

type
  Tplateau= record
    Id:Integer;
    lenom:PChar;
    NbreLigne: integer;
    NbreColonne:integer;
    LargCase:Integer;
    HautCase:Integer;
    Couleur1Case:TColor;
    Couleur2Case:TColor;
    PlateauUni:boolean;
    ClearBackground:TColor;
    A1:Boolean;              //coordonées gauche
    A2:Boolean;               //coordonées hautes
    DrawCoord:boolean;
    Caselected:Integer;
    boardWidth, boardHeight: Integer;
    offsetX,offsetY:integer;
    nbrecase:Integer;
   end;

  type
  TCase = record
    id: Integer;
    x, y: Integer;
    width, height: Integer;
    color1: TColor;
    color2:TColor;
    alpha: Single;
    ligne,colonne:Integer;
    milieuX,milieuy:Integer;
  end;


  const
  SCREEN_WIDTH = 1680;
  SCREEN_HEIGHT = 1050;
  SQUARE_SIZE_heigth = 50;
  SQUARE_SIZE_width =50;
  DECAL_Hauteur=10;
  DECAL_Largeur =20;




  Var
    Leboard:Tplateau;
    board: array of TCase; // va permettre de stocker toutes les cases, on ne connait pas le nombre.
    toggleSliderActive: integer =1 ;
    statustext:pchar ='Info';
    ButtonExit,colorPickerBounds,case1, case2, clearbg,alphaSliderBounds,ligneBounds,colonneBounds,hautCasebounds,largCasebounds :TRectangle;
    colorSelected: TColor;
    mousePos: TVector2;
   colorText: string;
   alphaValue:Single;

   valueBoxEditcolonne:boolean =false;
   valueBoxEditligne:boolean =false;
   spinnerEditlarg:boolean=false;
   spinnerEditHaut:boolean=false;

  procedure initBoard();
  procedure DrawBoardalterne();
  procedure DrawBoarduni();
  procedure DrawCoordinates();
  procedure gui();
  procedure majcouleur(typeechiquier:boolean);
  procedure majEchiquier;
  implementation

  procedure majcouleur(typeechiquier: boolean);
  var i: Integer;
  begin
      if typeechiquier= False then
      begin
       for i := 0 to leboard.nbrecase-1 do
       begin
         if ((board[i].ligne + board[i].colonne) mod 2 = 0) then
            board[i].color1 := leboard.Couleur1Case
            else
            board[i].color1 := leboard.Couleur2Case;
       End;


  end;
 end;
  procedure majechiquier();
  // il y a eu un changement de taille et de nombre dans l échiquer,
  //je dois tout recalculer
  var
   i:integer;
  begin
  leboard.nbrecase:=leboard.NbreLigne*leboard.NbreColonne;
  SetLength(board, Leboard.nbrecase);                       //mise à jour des la taille du tableau

  for i := 0 to leboard.nbrecase-1 do
begin
  board[i].id := i;


  board[i].ligne := i div leboard.NbreColonne + 1;    // Division par nombre de colonnes
  board[i].colonne := i mod leboard.NbreColonne + 1;  // Reste par nombre de colonnes


  board[i].x := leboard.offsetX + ((board[i].colonne - 1) * leboard.largcase);  // x varie avec colonne
  board[i].y := leboard.offsetY + ((board[i].ligne - 1) * leboard.hautcase);    // y varie avec ligne

  board[i].width := leboard.LargCase;
  board[i].height := leboard.HautCase;                                 if leboard.nbrecolonne=0 then leboard.nbrecolonne:=1;

  board[i].milieuX:=board[i].x+trunc(leboard.LargCase/2);
  board[i].milieuy:=board[i].y+trunc(leboard.hautCase/2);



   if ((board[i].ligne + board[i].colonne) mod 2 = 0) then
    board[i].color1 := leboard.Couleur1Case
  else
    board[i].color1 := leboard.Couleur2Case;
   end;


  board[i].alpha := 1.0;
  end;
  procedure gui();

begin

        GuiLabel(RectangleCreate( 1500, 10, 140, 30 ), 'Plateau');              //
        //GuiSetStyle(SLIDER, SLIDER_PADDING, 2);
        GuiToggleSlider(RectangleCreate( 1500, 50, 150, 25 ), 'UNI;Alterne', @toggleSliderActive);
        If toggleSliderActive = 1  then
            Leboard.PlateauUni:=false                         //alterné
            else
            Leboard.PlateauUni:=true;                            //uni


        //0 ou 1 dans toggleslideractive
        //GuiSetStyle(SLIDER, SLIDER_PADDING, 0);

        case1:=RectangleCreate(1500, 80, 20, 20);
         DrawRectanglerec(case1, leboard.Couleur1Case);                  // couleur1
        // Dessiner le contour en noir
        DrawRectangleLinesEx(case1,1, BLACK);
        GuiLabel(rectanglecreate(1520,80,80,20), 'Couleur N°1');

        case2:=RectangleCreate(1500, 110, 20, 20);
         DrawRectanglerec(case2, leboard.Couleur2Case);                  // couleur2 /inteligne
        // Dessiner le contour en noir
        DrawRectangleLinesex(case2,1, BLACK);
        GuiLabel(rectanglecreate(1520,110,150,20), 'Couleur N°2/ Interligne');

        clearbg:=RectangleCreate(1500, 140, 20, 20);
        DrawRectanglerec(clearbg, Leboard.ClearBackground);                  // couleur2 fond
        // Dessiner le contour en noir
        DrawRectangleLinesex(clearbg,1, BLACK);
        GuiLabel(rectanglecreate(1520,140,80,20), 'Couleur Fond');
         mousePos := GetMousePosition();

        if IsMouseButtonDown(MOUSE_LEFT_BUTTON) and
       CheckCollisionPointRec(mousePos, case1) then
    begin
     Leboard.Caselected:=1;
    end;

        if IsMouseButtonDown(MOUSE_LEFT_BUTTON) and
       CheckCollisionPointRec(mousePos, case2) then
    begin
     Leboard.Caselected:=2;
    end;

         if IsMouseButtonDown(MOUSE_LEFT_BUTTON) and
       CheckCollisionPointRec(mousePos, clearbg) then
    begin
     Leboard.Caselected:=3;
    end;

        colorPickerBounds:=RectangleCreate(1500,170,150,100);                    // panel couleurs
        GuiColorPicker(colorPickerBounds, nil, @colorSelected);
        //alphaSliderBounds:=RectangleCreate(1540,270,110,20);
        //GuiSlider(alphaSliderBounds, 'Alpha', nil, @alphaValue, 0, 255);        // slider alpha couleur
        //colorSelected.a := Round(alphaValue);
    if IsMouseButtonDown(MOUSE_LEFT_BUTTON) and
       CheckCollisionPointRec(mousePos, colorPickerBounds) then
    begin
     //colorSelected.a := Round(alphaValue);
     case Leboard.Caselected of
        1: leboard.Couleur1Case:=colorselected;
        2: leboard.Couleur2Case:=colorselected;
        3: leboard.ClearBackground:=colorSelected;
     end;
    end;
        
        colonneBounds:=RectangleCreate(1500,280,30,20);
         if GuiValueBox(colonneBounds, 'colonne(s)', @leboard.nbrecolonne, 2, 100, valueBoxEditcolonne) <> 0          // nombre de colonnes
        then
         begin
          valueBoxEditcolonne := not valueBoxEditcolonne;

          majEchiquier()
         end;
        ligneBounds:=RectangleCreate(1500,305,30,20);
         if GuiValueBox(ligneBounds, 'ligne(s)', @leboard.nbreligne, 2, 100, valueBoxEditligne) <> 0                 // nombre de lignes
        then
        begin
          valueBoxEditligne := not valueBoxEditligne;
           majEchiquier()                                                                                               // on repositionne nombre de case
        end;


         hautCasebounds:=RectangleCreate(1500,330,100,20);
         if GuiSpinner(hautCasebounds, 'Hauteur Case', @leboard.HautCase, 1, 100, spinnerEditHaut) <> 0              // hauteur de la case
        then
        begin
         spinnerEditHaut := not spinnerEditHaut;
         majEchiquier()
        end;

          largCasebounds:=RectangleCreate(1500,355,100,20);
         if GuiSpinner(largCasebounds, 'largeur Case', @leboard.LargCase, 1, 100, spinnerEditlarg) <> 0              //largeur de la case.
        then
        begin
           spinnerEditlarg := not spinnerEditlarg;
           majEchiquier()
        end;



    //       // panel couleur

        GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);                  //status
         GuiStatusBar(RectangleCreate( 0, GetScreenHeight() - 20, GetScreenWidth(), 20) , statustext);
         GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);
end;
  procedure initBoard();
  var i:integer;
  begin
   with Leboard do
   begin
      id:=1;
      lenom:='Plateau';
    NbreLigne:=8;
    NbreColonne:=6 ;
    hautCase:=SQUARE_SIZE_heigth;
    largCase:=SQUARE_SIZE_width;
    Couleur1Case:=WHITE;
    Couleur2Case:=black;
    ClearBackground:=GRAY;
    PlateauUni:=False;
    A1:=false;
    A2:=false;
    Caselected:=0;
    DrawCoord:=true;
    boardWidth := NbreColonne * SQUARE_SIZE_heigth;
    boardHeight := NbreLigne * SQUARE_SIZE_width;
    offsetX :=40;// ( SCREEN_WIDTH - boardWidth) div 2;
    offsetY :=40;// (screen_Height - boardHeight) div 2;
    nbrecase:=NbreLigne*NbreColonne;
   end;
      colorSelected:=red;
      colorSelected.a:=255;



  SetLength(board, Leboard.nbrecase);

  for i := 0 to leboard.nbrecase-1 do
begin
  board[i].id := i;


  board[i].ligne := i div leboard.NbreColonne + 1;    // Division par nombre de colonnes
  board[i].colonne := i mod leboard.NbreColonne + 1;  // Reste par nombre de colonnes


  board[i].x := leboard.offsetX + ((board[i].colonne - 1) * leboard.largcase);  // x varie avec colonne
  board[i].y := leboard.offsetY + ((board[i].ligne - 1) * leboard.hautcase);    // y varie avec ligne

  board[i].width := leboard.LargCase;
  board[i].height := leboard.HautCase;

  board[i].milieuX:=board[i].x+trunc(leboard.LargCase/2);
  board[i].milieuy:=board[i].y+trunc(leboard.hautCase/2);



   if ((board[i].ligne + board[i].colonne) mod 2 = 0) then
    board[i].color1 := leboard.Couleur1Case
  else
    board[i].color1 := leboard.Couleur2Case;
   end;


  board[i].alpha := 1.0;
end;



  procedure DrawBoardalterne();

  var
    i: integer;

  begin
    // Dessiner l'échiquier
    for i := 0 to leboard.nbrecase-1 do
    begin


  DrawRectangle(board[i].x, board[i].y, board[i].width, board[i].height,board[i].color1);
       end;

      end;


    procedure DrawBoarduni();
  var
    i: integer;


   begin
    // Dessiner l'échiquier
    for i := 0 to leboard.nbrecase-1 do
    begin
    board[i].color1:=Leboard.Couleur1Case;
  DrawRectangle(board[i].x, board[i].y, board[i].width, board[i].height,board[i].color1);
  board[i].color2:=Leboard.Couleur2Case;
  DrawRectanglelines(board[i].x, board[i].y, board[i].width, board[i].height,board[i].color2);
       end;
end;


  procedure DrawCoordinates();
var
  i: Integer;
  CoordText: ansistring;
  TextX, TextY: Integer;
begin
  with Leboard do
  begin
    // 1. Coordonnées verticales (à gauche) : lignes de bas en haut
    for i := 0 to NbreLigne - 1 do
    begin
      if A1 then
        // Lettres : A en bas, jusqu'à NbreLigne (ex: A, B, C...)
        CoordText := Chr(Ord('A') + i)
      else
        // Nombres : 1 en bas, jusqu'à NbreLigne
        CoordText := IntToStr(i + 1);

      // Position à gauche de l'échiquier
      TextX := offsetX - 20; // Un peu à gauche du board
      TextY := offsetY + (NbreLigne - 1 - i) * HautCase + HautCase div 2 - 10; // Centré verticalement
      DrawText(PChar(CoordText), TextX, TextY, 20, LIGHTGRAY);
    end;

    // 2. Coordonnées horizontales (en haut) : colonnes de gauche à droite
    for i := 0 to NbreColonne - 1 do
    begin
      if A2 then
        // Lettres : A à gauche, jusqu'à NbreColonne (ex: A, B, C...)
        CoordText := Chr(Ord('A') + i)
      else
        // Nombres : 1 à gauche, jusqu'à NbreColonne
        CoordText := IntToStr(i + 1);

      // Position au-dessus de l'échiquier
      TextX := offsetX + i * LargCase + LargCase div 2 - 10; // Centré horizontalement
      TextY := offsetY - 20; // Au-dessus du board
      DrawText(PChar(CoordText), TextX, TextY, 20, LIGHTGRAY);
    end;
  end;
end;

end.

