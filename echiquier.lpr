program echiquier;
{$mode objfpc}{$H+}

uses
  cmem,
  raylib,
  SysUtils, plateaumle,raygui;




begin



  // Initialisation de la fenêtre
  InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Editeur Echiquier Raylib Raygui Free Pascal');
  SetTargetFPS(60);
  GuiLoadStyle(PChar(GetApplicationDirectory + 'gui_styles/style_amber.rgs'));


  initBoard();

  // Boucle principale
  while not WindowShouldClose() do
  begin
    BeginDrawing();
    ClearBackground(Leboard.ClearBackground);

    // Dessiner l'échiquier et les coordonnées
    If Leboard.PlateauUni=false then                                     //test type plateau
    DrawBoardalterne()
    else
    DrawBoarduni();

    DrawCoordinates();
    Gui();
    EndDrawing();
    if GuiButton(RectangleCreate( 1500, 480, 140, 30 ), 'Quitter')>0 then Break;
  end;

  // Libération de la mémoire et fermeture propre

  CloseWindow();
end.
