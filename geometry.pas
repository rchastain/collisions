unit geometry;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmapTypes;

function EllipseRectCollision(e, r: TRect): boolean;

implementation

function Tan(const x: single): single;
begin
  result := Sin(x) / Cos(x);
end;

function Hypot(const x, y: single): single;
begin
  result := Sqrt(x * x + y * y);
end;

function DegToRad(const ADeg: single): single;
begin
  result := ADeg * (PI / 180);
end;

function RadToDeg(const ARad: single): single;
begin
  result := ARad * (180 / PI);
end;

function Tangens(const ADeg: single): single;
begin
  result := Tan(DegToRad(ADeg));
end;

function Sinus(const ADeg: single): single;
begin
  result := Sin(DegToRad(ADeg));
end;

function Cosinus(const ADeg: single): single;
begin
  result := Cos(DegToRad(ADeg));
end;

procedure Swap(var i, j: integer);
var
  k: integer;
begin
  k := i;
  i := j;
  j := k;
end;

function ArcTangens(const x, y: single): single;
begin
  if x = 0 then
  begin
    if y >= 0 then
      result := 90
    else
      result := 270;
  end else
  begin
    result := RadToDeg(ArcTan(y / x));
    if x < 0 then
      result := 180 + result
    else
      if y < 0 then
        result := 360 + result;
  end;
end;

function EllipseRectCollision(e, r: TRect): boolean;
var
  sn1, sn2, x, alpha: single;
  p1, p2: TPoint;
  n1, n2: TPointF;
  radius1, radius2: integer;
begin
  result := FALSE;

  if e.Left > e.Right  then Swap(e.Left, e.Right);
  if e.Top  > e.Bottom then Swap(e.Top,  e.Bottom);
  if r.Left > r.Right  then Swap(r.Left, r.Right);
  if r.Top  > r.Bottom then Swap(r.Top,  r.Bottom);

  p1.x := e.Left + (e.Right  - e.Left) div 2;
  p1.y := e.Top  + (e.Bottom - e.Top ) div 2;
  p2.x := r.Left + (r.Right  - r.Left) div 2;
  p2.y := r.Top  + (r.Bottom - r.Top ) div 2;

  alpha := ArcTangens(p1.x - p2.x, p1.y - p2.y);

  x := Hypot(p1.x - p2.x, p1.y - p2.y);

  radius1 := p1.x - e.Left;
  radius2 := p1.y - e.Top;

  n1.x := Cosinus(alpha) * radius1 + P1.x;
  n1.Y :=   Sinus(alpha) * radius2 + P1.Y;

  sn1 := Hypot(p1.x - n1.x, p1.y - n1.y);

  case Round(alpha) of
    0..45:
      begin
        n2.x := r.Right;
        n2.y := Round(Tangens(alpha) * ((r.Bottom - p2.y) / 2)) + p2.y;
      end;
    46..90:
      begin
        n2.y := r.Top;
        n2.x := Round(Tangens(alpha - 45) * ((r.Right - p2.x) / 2)) + p2.x;
      end;
    91..135:
      begin
        n2.y := r.Top;
        n2.x := Round(Tangens(alpha - 90) * ((r.Right - p2.x) / 2)) + p2.x;
      end;
    136..225:
      begin
        n2.x := r.Left;
        n2.y := Round(Tangens(alpha) * ((r.Bottom - p2.y) / 2)) + p2.y;
      end;
    226..270:
      begin
        n2.y := r.Bottom;
        n2.x := Round(Tangens(alpha - 225) * ((r.Right - p2.x) / 2)) + p2.x;
      end;
    271..315:
      begin
        n2.y := r.Bottom;
        n2.x := Round(Tangens(alpha - 270) * ((r.Right - p2.x) / 2)) + p2.x;
      end;
    316..360:
      begin
        n2.x := r.Right;
        n2.y := Round(Tangens(alpha) * ((r.Bottom - p2.y) / 2)) + p2.y;
      end;
  end;
  sn2 := Hypot(p2.x - n2.x, p2.y - n2.y);
  if x <= (sn1 + sn2) then
    result := TRUE;
end;

end.

