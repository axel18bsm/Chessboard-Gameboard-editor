program echiquier;
{$mode objfpc}{$H+}

uses
  cmem,
  raylib,
  SysUtils, plateaumle,raygui;
var
csvFile: string;
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
    If Leboard.PlateauUni=false then
       begin//test type plateau
        majcouleur(false);                                                       // on remet à jour les couleurs
        DrawBoardalterne();
       end

    else
       begin
        //majcouleur(true);
        DrawBoarduni();                                                         //on remet à jour les couleurs
       end;

    if leboard.DrawCoord= true then DrawCoordinates();
    Gui();
    EndDrawing();
    if GuiButton(RectangleCreate(1500, 460, 140, 30), 'Sauvegarder') > 0 then
      SaveBoardAndScreenshot;

    if GuiButton(RectangleCreate(1500, 530, 140, 30), 'Charger') > 0 then
      begin
       if leboard.Largsauv>1 then
         begin
       csvFile := Format('echiquier_%d.csv', [leboard.Largsauv]);
      LoadBoardFromFile(csvfile);  // charge le numero de fichier
      majechiquier();
          end;
       End;


    if GuiButton(RectangleCreate(1500, 580, 140, 30), 'Quitter') > 0 then
      Break;
  end;

  // Libération de la mémoire et fermeture propre

  CloseWindow();
end.
