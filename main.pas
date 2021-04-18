
(*
  http://corpsman.de/index.php?doc=beispiele/pingpong
*)

unit main;

{$MODE OBJFPC}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  BGRABitmap, BGRABitmapTypes,
  Ball;

type
  { TForm1 }
  TForm1 = class(TForm)
    AppPro: TApplicationProperties;
    procedure AppProIdle(Sender: TObject; var Done: Boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Balls: array of TBall;
  Initialized: Boolean = FALSE;
  FormBitmap: TBGRABitmap;

implementation

{$R *.lfm}

procedure Render;
var
  i, j: Integer;
begin
  if not Initialized then
    Exit;

  FormBitmap.Fill(BGRABlack);
  
  for i := 0 to High(Balls) do
    Balls[i].Render(FormBitmap);
  
  FormBitmap.Draw(Form1.Canvas, 0, 0, True);
  
  for i := 0 to High(Balls) do
    Balls[i].Move;
  
  for i := 0 to High(Balls) do
    for j := i + 1 to High(Balls) do
      begin
        Balls[i].Collide(Balls[j]);
      end;
  
  for i := 0 to High(Balls) do
    Balls[i].BorderCollision(Form1.ClientRect);
end;

{ TForm1 }

procedure TForm1.AppProIdle(Sender: TObject; var Done: Boolean);
begin
  Render;
  Done := FALSE;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  i: Integer;
begin
  Initialized := FALSE;
  for i := 0 to High(Balls) do
    Balls[i].Free;
  FormBitmap.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, w, h: Integer;
begin
  BorderStyle := bsNone;

  Top := 0;
  Left := 0;
  Width := Screen.Width;
  Height := Screen.Height;

  FormBitmap := TBGRABitmap.Create(ClientWidth, ClientHeight);

  SetLength(Balls, 10);
  for i := 0 to High(Balls) do
  begin
    Balls[i] := TBall.Create(PointF(0, 0), PointF(0, 0), 20 + Random(20) + 1, 0);
    Balls[i].CalculateMass;
  end;

  w := Width div 5;
  h := Height div 4;

  Balls[0].position := PointF(w * 1, h * 2);
  Balls[1].Position := PointF(w * 2, h * 1);
  Balls[2].Position := PointF(w * 3, h * 1);
  Balls[3].Position := PointF(w * 4, h * 1);
  Balls[4].Position := PointF(w * 2, h * 2);
  Balls[5].Position := PointF(w * 3, h * 2);
  Balls[6].Position := PointF(w * 4, h * 2);
  Balls[7].Position := PointF(w * 2, h * 3);
  Balls[8].Position := PointF(w * 3, h * 3);
  Balls[9].Position := PointF(w * 4, h * 3);

  Balls[0].Speed := PointF(Cos((-45) * PI / 180) * 4, Sin(-45 * PI / 180) * 4);

  Initialized := TRUE;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Close;
end;

end.
