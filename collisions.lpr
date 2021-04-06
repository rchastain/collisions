program collisions;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, main, geometry;

{$R *.res}

begin
  Application.Title:='collisions';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

