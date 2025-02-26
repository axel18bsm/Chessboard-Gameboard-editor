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
    A1:Boolean;
    Caselected:Integer;
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
    toggleSliderActive: integer =1 ;
    statustext:pchar ='Info';
    ButtonExit,colorPickerBounds,case1, case2, clearbg,alphaSliderBounds,ligneBounds,colonneBounds,hautCasebounds,largCasebounds :TRectangle;
    colorSelected: TColor;
    mousePos: TVector2;
   colorText: string;
   alphaValue:Single;
   NColonne:integer=8;
   Nligne : Integer=8;
   valueBoxEditcolonne:boolean =false;
   valueBoxEditligne:boolean =false;
   spinnerEditlarg:boolean=false;
   spinnerEditHaut:boolean=false;

  procedure initBoard();
  procedure DrawBoardalterne();
  procedure DrawBoarduni();
  procedure DrawCoordinates();
  procedure gui();
  implementation

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
         if GuiValueBox(colonneBounds, 'colonne(s)', @leboard.nbrecolonne, 0, 100, valueBoxEditcolonne) <> 0          // nombre de colonnes
        then valueBoxEditcolonne := not valueBoxEditcolonne;

        ligneBounds:=RectangleCreate(1500,305,30,20);
         if GuiValueBox(ligneBounds, 'ligne(s)', @leboard.nbreligne, 0, 100, valueBoxEditligne) <> 0                 // nombre de lignes
        then valueBoxEditligne := not valueBoxEditligne;

         hautCasebounds:=RectangleCreate(1500,330,100,20);
         if GuiSpinner(hautCasebounds, 'Hauteur Case', @leboard.HautCase, 0, 100, spinnerEditHaut) <> 0              // hauteur de la case
        then spinnerEditHaut := not spinnerEditHaut;

          largCasebounds:=RectangleCreate(1500,355,100,20);
         if GuiSpinner(largCasebounds, 'largeur Case', @leboard.LargCase, 0, 100, spinnerEditlarg) <> 0              //largeur de la case.
        then spinnerEditlarg := not spinnerEditlarg;


    //       // panel couleur

        GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);                  //status
         GuiStatusBar(RectangleCreate( 0, GetScreenHeight() - 20, GetScreenWidth(), 20) , statustext);
         GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);
end;
  procedure initBoard();
  begin
   with Leboard do
   begin
      id:=1;
      lenom:='Plateau';
    NbreLigne:=8;
    NbreColonne:=8 ;
    hautCase:=SQUARE_SIZE_heigth;
    largCase:=SQUARE_SIZE_width;
    Couleur1Case:=WHITE;
    Couleur2Case:=black;
    ClearBackground:=GRAY;
    PlateauUni:=False;
    A1:=false;
    Caselected:=0;
   end;
      colorSelected:=red;
      colorSelected.a:=255;
  end;


  procedure DrawBoardalterne();
  var
    i, j: integer;
    color: TColor;
  begin
    // Dessiner l'échiquier
    for i := 1 to leboard.NbreColonne do
    begin
      for j := 1 to leboard.Nbreligne do
      begin
        // Alternance des couleurs des cases
        if (i + j) mod 2 = 0 then
          color := Leboard.Couleur1Case
        else
          color := Leboard.Couleur2Case;

       with leboard do
       begin
       DrawRectangle(i * largCase+DECAL_Largeur, j * hautCase+DECAL_Hauteur, largCase, hautCase, color);    // Dessiner la case

       end;

      end;
    end;
  end;

    procedure DrawBoarduni();
  var
    i, j: integer;
    color: TColor;
  begin
    // Dessiner l'échiquier
    for i := 1 to leboard.NbreColonne do
    begin
      for j := 1 to leboard.Nbreligne do
      begin
      color := Leboard.Couleur1Case;


       with leboard do
       begin
       DrawRectangle(i * largCase+DECAL_Largeur, j * hautCase+DECAL_Hauteur, largCase, hautCase, color);    // Dessiner la case
       color := Leboard.Couleur2Case;
       DrawRectangleLines(i * largCase+DECAL_Largeur, j * hautCase+DECAL_Hauteur, largCase, hautCase, color);
       end;

      end;
    end;

    // Dessiner un cadre noir autour de l'échiquier
    DrawRectangleLines(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, BLACK);
  end;

  procedure DrawCoordinates();
  var
    i: integer;
    NumText, LetterText: ansistring;
  begin
   with Leboard do
    begin
     for i := 1 to leboard.NbreLigne do
     begin
      // Convertir le texte en AnsiString pour éviter des erreurs avec PChar
      LetterText := Chr(Ord('a') + i);
      NumText := IntToStr(leboard.NbreLigne - i+1);

      //// Lettres (bas)
      //DrawText(PChar(LetterText),
      //  i * SQUARE_SIZE+DECAL_Largeur + SQUARE_SIZE div 3,
      //  SCREEN_HEIGHT - 20-DECAL_hauteur,
      //  20,
      //  LIGHTGRAY);

      //// Lettres (haut)
      //DrawText(PChar(LetterText),
      //  i * largCase+DECAL_Largeur + largCase div 3,
      //  5+DECAL_hauteur,
      //  20,
      //  LIGHTGRAY);

      // Nombres (gauche)
      DrawText(PChar(NumText),
        5+DECAL_largeur,
        i * hautcase+DECAL_hauteur + hautcase div 3,
        20,
        LIGHTGRAY);

      // Nombres (droite)
      //DrawText(PChar(NumText),
      //  SCREEN_WIDTH - 20,
      //  i * SQUARE_SIZE +DECAL_Largeur+ SQUARE_SIZE div 3,
      //  20,
      //  LIGHTGRAY);
    end;
  end;
end;

end.

