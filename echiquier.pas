unit echiquier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,raylib;

implementation
const
  SCREEN_WIDTH = 1680;
  SCREEN_HEIGHT = 1050;
  SQUARE_SIZE = 100;
  DECAL_Hauteur=50;
  DECAL_Largeur =100;

type
  echiquier = class
  public
    procedure DrawBoard();
    procedure DrawCoordinates();
  end;


  procedure echiquier.DrawBoard();
  var
    i, j: integer;
    color: TColor;
  begin
    // Dessiner l'échiquier
    for i := 0 to 7 do
    begin
      for j := 0 to 7 do
      begin
        // Alternance des couleurs des cases
        if (i + j) mod 2 = 0 then
          color := RAYWHITE
        else
          color := darkbrown;

        // Dessiner la case
        DrawRectangle(i * SQUARE_SIZE+DECAL_Largeur, j * SQUARE_SIZE+DECAL_Hauteur, SQUARE_SIZE, SQUARE_SIZE, color);
      end;
    end;

    // Dessiner un cadre noir autour de l'échiquier
    DrawRectangleLines(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, BLACK);
  end;

  procedure echiquier.DrawCoordinates();
  var
    i: integer;
    NumText, LetterText: ansistring;
  begin
    for i := 0 to 7 do
    begin
      // Convertir le texte en AnsiString pour éviter des erreurs avec PChar
      LetterText := Chr(Ord('a') + i);
      NumText := IntToStr(8 - i);

      //// Lettres (bas)
      //DrawText(PChar(LetterText),
      //  i * SQUARE_SIZE+DECAL_Largeur + SQUARE_SIZE div 3,
      //  SCREEN_HEIGHT - 20-DECAL_hauteur,
      //  20,
      //  LIGHTGRAY);

      // Lettres (haut)
      DrawText(PChar(LetterText),
        i * SQUARE_SIZE+DECAL_Largeur + SQUARE_SIZE div 3,
        5+DECAL_hauteur,
        20,
        LIGHTGRAY);

      // Nombres (gauche)
      DrawText(PChar(NumText),
        5+DECAL_largeur,
        i * SQUARE_SIZE++DECAL_hauteur + SQUARE_SIZE div 3,
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
end.

