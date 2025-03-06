unit plateauMle;

{$mode ObjFPC}{$H+} {$modeSwitch advancedRecords}

interface

uses
  Classes, SysUtils,raylib,raygui;

type
  Tplateau= record
    Id:longint;
    lenom:PChar;
    NbreLigne: integer;
    NbreColonne:integer;
    LargCase:Integer;
    HautCase:Integer;
    Largsauv:Integer;
    Largsauvmax:Integer;
    Largsauvmin:Integer;
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
    x, y,width, height: Integer;
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
    toggleSliderActive,toggleSliderActiveGauche,toggleSliderActivehaut: integer  ;
    statustext:pchar ='Info';
    ButtonExit,colorPickerBounds,case1, case2, clearbg,alphaSliderBounds,ligneBounds,colonneBounds,hautCasebounds,largCasebounds, checkbounds :TRectangle;
    colorSelected: TColor;
    mousePos: TVector2;
   colorText: string;
   alphaValue:Single;

   valueBoxEditcolonne:boolean =false;
   valueBoxEditligne:boolean =false;
   spinnerEditlarg:boolean=false;
   spinnerEditHaut:boolean=false;
   spinnerEditSauv:Boolean=false;
  a3selected:Boolean=true;
  showcoord:boolean=false;

  procedure initBoard();
  procedure DrawBoardalterne();
  procedure DrawBoarduni();
  procedure DrawCoordinates();
  procedure gui();
  procedure majcouleur(typeechiquier:boolean);
  procedure majEchiquier;
  procedure SaveBoardAndScreenshot;
  procedure LoadBoardFromFile(const FileName: string);
  procedure comptesauvegarde;
  implementation

  procedure comptesauvegarde();
   var
  screenshotFile, csvFile: string;
  fileNum, i: Integer;
  F: TextFile;

begin
  fileNum := 1;

  repeat
    screenshotFile := Format('screenshot_%d.png', [fileNum]);
    Inc(fileNum);
  until not FileExists(pchar(screenshotFile));
       Dec(filenum); Dec(filenum);
    if filenum>1 then
    begin
       leboard.Largsauvmin:=1;
       leboard.Largsauvmax:=filenum;
       Leboard.Largsauv:=filenum;
    end
    else
    begin
       leboard.Largsauvmin:=0;
       leboard.Largsauvmax:=0;
       Leboard.Largsauv:=filenum;
    end;
  end;



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
  procedure gui();

begin

        GuiLabel(RectangleCreate( 1500, 10, 140, 30 ), 'Plateau');              //
        GuiSetStyle(SLIDER, SLIDER_PADDING, 2);
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
         if GuiSpinner(hautCasebounds, 'Hauteur Case', @leboard.HautCase, 1, 200, spinnerEditHaut) <> 0              // hauteur de la case
        then
        begin
         spinnerEditHaut := not spinnerEditHaut;
         majEchiquier()
        end;

          largCasebounds:=RectangleCreate(1500,355,100,20);
         if GuiSpinner(largCasebounds, 'largeur Case', @leboard.LargCase, 1, 200, spinnerEditlarg) <> 0              //largeur de la case.
        then
        begin
           spinnerEditlarg := not spinnerEditlarg;
        end;


          if GuiSpinner(RectangleCreate(1500, 500, 80, 30), '# Sauvegarde(s)', @leboard.Largsauv, leboard.Largsauvmin, leboard.Largsauvmax, spinnerEditSauv) <> 0 //nombre de sauvegarde.
        then
        begin
           spinnerEditSauv := not spinnerEditSauv;
                end;

         checkbounds:=RectangleCreate(1500,380,20,20);
          if GuiCheckBox(checkbounds, 'Sélection Coordonnées', @A3selected)>0 then
          showcoord:=true
          else
          showcoord:=false;
        GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);

        GuiSetStyle(SLIDER, SLIDER_PADDING, 2);
        GuiToggleSlider(RectangleCreate( 1500, 405, 140, 25 ), 'Gauche 123;Gauche ABC', @toggleSliderActiveGauche);
        If toggleSliderActiveGauche = 1  then
            Leboard.A1:=true                         //alterné
            else
            Leboard.A1:=false;

        GuiSetStyle(SLIDER, SLIDER_PADDING, 2);
        GuiToggleSlider(RectangleCreate( 1500, 430, 140, 25 ), 'Haut 123;Haut ABC', @toggleSliderActiveHaut);
        If toggleSliderActiveHaut = 1  then
            Leboard.A2:=true                         //alterné
            else
            Leboard.A2:=false;

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
    Largsauv:=0;
    Couleur1Case:=WHITE;
    Couleur2Case:=black;
    ClearBackground:=GRAY;
    PlateauUni:=False;
    A1:=false;
    A2:=true;
    Caselected:=0;
    DrawCoord:=true;
    boardWidth := NbreColonne * SQUARE_SIZE_heigth;
    boardHeight := NbreLigne * SQUARE_SIZE_width;
    offsetX :=60;// ( SCREEN_WIDTH - boardWidth) div 2;
    offsetY :=60;// (screen_Height - boardHeight) div 2;
    nbrecase:=NbreLigne*NbreColonne;
   end;
      colorSelected:=red;
      colorSelected.a:=255;

    toggleSliderActive:=1;
    toggleSliderActivehaut:=1;
    toggleSlideractivegauche:=1;

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

  comptesauvegarde();                               // on compte les fichiers de sauvegarde !

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
if A3selected =true then
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
      TextX := offsetX - 30; // Un peu à gauche du board
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
      TextY := offsetY - 25; // Au-dessus du board
      DrawText(PChar(CoordText), TextX, TextY, 20, LIGHTGRAY);
    end;
  end;

 end;
End;

 procedure SaveBoardAndScreenshot;
var
  screenshotFile, csvFile: string;
  fileNum, i: Integer;
  F: TextFile;
begin
  fileNum := 1;

  repeat
    screenshotFile := Format('screenshot_%d.png', [fileNum]);
    Inc(fileNum);
  until not FileExists(pchar(screenshotFile));
  Dec(fileNum);

  TakeScreenshot(PChar(screenshotFile));

  csvFile := Format('echiquier_%d.csv', [fileNum]);
  AssignFile(F, csvFile);
  try
    Rewrite(F);
    // Ajouter ClearBackground dans l'en-tête
    WriteLn(F, 'ID,X,Y,Width,Height,Color1R,Color1G,Color1B,Color1A,Color2R,Color2G,Color2B,Color2A,Alpha,Ligne,Colonne,MilieuX,MilieuY,PlateauID,PlateauNbreLigne,PlateauNbreColonne,ClearBgR,ClearBgG,ClearBgB,ClearBgA');
    for i := 0 to Leboard.nbrecase - 1 do
    begin
      WriteLn(F, Format('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d',
        [board[i].id, board[i].x, board[i].y, board[i].width, board[i].height,
         board[i].color1.r, board[i].color1.g, board[i].color1.b, board[i].color1.a,
         board[i].color2.r, board[i].color2.g, board[i].color2.b, board[i].color2.a,
          board[i].ligne, board[i].colonne, board[i].milieuX, board[i].milieuY,
         Leboard.Id, Leboard.NbreLigne, Leboard.NbreColonne,
         Leboard.ClearBackground.r, Leboard.ClearBackground.g, Leboard.ClearBackground.b, Leboard.ClearBackground.a]));
    end;
    CloseFile(F);
  except
    on E: Exception do
    begin
      CloseFile(F);
      WriteLn('Erreur lors de la sauvegarde CSV : ', E.Message);
    end;
  end;
  comptesauvegarde();
end;

procedure LoadBoardFromFile(const FileName: string);
var
  F: TextFile;
  Line: string;
  Fields: TStringList;
  i: Integer;
  tempNom: string;
begin
  Fields := TStringList.Create;
  Fields.Delimiter := ',';
  Fields.StrictDelimiter := True;

  AssignFile(F, FileName);
  try
    Reset(F);

    // Ignorer l'en-tête
    if not EOF(F) then
      ReadLn(F, Line);

    // Lire la première ligne pour mettre à jour Leboard
    if not EOF(F) then
    begin
      ReadLn(F, Line);
      Fields.DelimitedText := Line;

      // Mettre à jour Leboard
      Leboard.NbreLigne := StrToInt(Fields[18]);      // PlateauNbreLigne
      Leboard.NbreColonne := StrToInt(Fields[19]);    // PlateauNbreColonne
      Leboard.nbrecase := Leboard.NbreLigne * Leboard.NbreColonne;
      Leboard.Id := StrToInt(Fields[17]);             // PlateauID

      Leboard.LargCase := board[0].width;
      Leboard.HautCase := board[0].height;
      Leboard.offsetX := board[0].x - (board[0].colonne - 1) * Leboard.LargCase;
      Leboard.offsetY := board[0].y - (board[0].ligne - 1) * Leboard.HautCase;
      Leboard.boardWidth := Leboard.NbreColonne * Leboard.LargCase;
      Leboard.boardHeight := Leboard.NbreLigne * Leboard.HautCase;


      // Charger les couleurs depuis la première ligne
      Leboard.Couleur1Case.r := StrToInt(Fields[5]);
      Leboard.Couleur1Case.g := StrToInt(Fields[6]);
      Leboard.Couleur1Case.b := StrToInt(Fields[7]);
      Leboard.Couleur1Case.a := StrToInt(Fields[8]);
      Leboard.Couleur2Case.r := StrToInt(Fields[9]);
      Leboard.Couleur2Case.g := StrToInt(Fields[10]);
      Leboard.Couleur2Case.b := StrToInt(Fields[11]);
      Leboard.Couleur2Case.a := StrToInt(Fields[12]);
      Leboard.ClearBackground.r := StrToInt(Fields[20]);
      Leboard.ClearBackground.g := StrToInt(Fields[21]);
      Leboard.ClearBackground.b := StrToInt(Fields[22]);
      Leboard.ClearBackground.a := StrToInt(Fields[23]);

      // Redimensionner board
      SetLength(board, Leboard.nbrecase);

      // Charger la première case
      i := 0;
      board[i].id := StrToInt(Fields[0]);
      board[i].x := StrToInt(Fields[1]);
      board[i].y := StrToInt(Fields[2]);
      board[i].width := StrToInt(Fields[3]);
      board[i].height := StrToInt(Fields[4]);
      board[i].color1.r := StrToInt(Fields[5]);
      board[i].color1.g := StrToInt(Fields[6]);
      board[i].color1.b := StrToInt(Fields[7]);
      board[i].color1.a := StrToInt(Fields[8]);
      board[i].color2.r := StrToInt(Fields[9]);
      board[i].color2.g := StrToInt(Fields[10]);
      board[i].color2.b := StrToInt(Fields[11]);
      board[i].color2.a := StrToInt(Fields[12]);
      board[i].ligne := StrToInt(Fields[13]);
      board[i].colonne := StrToInt(Fields[14]);
      board[i].milieuX := StrToInt(Fields[15]);
      board[i].milieuY := StrToInt(Fields[16]);
      Inc(i);
    end;

    //Charger la deuxième case
      ReadLn(F, Line);
      Fields.DelimitedText := Line;

      board[i].id := StrToInt(Fields[0]);
      board[i].x := StrToInt(Fields[1]);
      board[i].y := StrToInt(Fields[2]);
      board[i].width := StrToInt(Fields[3]);
      board[i].height := StrToInt(Fields[4]);
      board[i].color1.r := StrToInt(Fields[5]);
      board[i].color1.g := StrToInt(Fields[6]);
      board[i].color1.b := StrToInt(Fields[7]);
      board[i].color1.a := StrToInt(Fields[8]);
      board[i].color2.r := StrToInt(Fields[9]);
      board[i].color2.g := StrToInt(Fields[10]);
      board[i].color2.b := StrToInt(Fields[11]);
      board[i].color2.a := StrToInt(Fields[12]);
      board[i].ligne := StrToInt(Fields[13]);
      board[i].colonne := StrToInt(Fields[14]);
      board[i].milieuX := StrToInt(Fields[15]);
      board[i].milieuY := StrToInt(Fields[16]);

      Leboard.Couleur2Case.r := StrToInt(Fields[5]);
      Leboard.Couleur2Case.g := StrToInt(Fields[6]);
      Leboard.Couleur2Case.b := StrToInt(Fields[7]);
      Leboard.Couleur2Case.a := StrToInt(Fields[8]);


      Inc(i);

    // Charger les autres cases
    while not EOF(F) do
    begin
      ReadLn(F, Line);
      Fields.DelimitedText := Line;

      board[i].id := StrToInt(Fields[0]);
      board[i].x := StrToInt(Fields[1]);
      board[i].y := StrToInt(Fields[2]);
      board[i].width := StrToInt(Fields[3]);
      board[i].height := StrToInt(Fields[4]);
      board[i].color1.r := StrToInt(Fields[5]);
      board[i].color1.g := StrToInt(Fields[6]);
      board[i].color1.b := StrToInt(Fields[7]);
      board[i].color1.a := StrToInt(Fields[8]);
      board[i].color2.r := StrToInt(Fields[9]);
      board[i].color2.g := StrToInt(Fields[10]);
      board[i].color2.b := StrToInt(Fields[11]);
      board[i].color2.a := StrToInt(Fields[12]);
      board[i].ligne := StrToInt(Fields[13]);
      board[i].colonne := StrToInt(Fields[15]);
      board[i].milieuX := StrToInt(Fields[15]);
      board[i].milieuY := StrToInt(Fields[16]);
      Inc(i);
    end;



    CloseFile(F);
  except
    on E: Exception do
    begin
      CloseFile(F);
      WriteLn('Erreur lors du chargement CSV : ', E.Message);
    end;
  end;
  Fields.Free;
end;

end.

end.

