 
(*
  http://corpsman.de/index.php?doc=beispiele/pingpong
*)
 
unit ball;
 
interface
 
uses
  Classes, Graphics, BGRABitmap, BGRABitmapTypes;
 
type
  TBall = class
  private
    FX, FY, FSX, FSY, FRadius, FMass: single;
    FImage: TBGRABitmap;
    function GetPos: TPointF;
    procedure SetPos(const AValue: TPointF);
    function GetSpeed: TPointF;
    procedure SetSpeed(const AValue: TPointF);
    procedure MakeBitmap;
  public
    property Radius: single read FRadius;
    property Position: TPointF read GetPos write SetPos;
    property Speed: TPointF read GetSpeed write SetSpeed;
    property Mass: single read FMass write FMass;
    constructor Create(const APos, ASpeed: TPointF; const ARadius, AMass: single);
    destructor Destroy; override;
    procedure Render(const ABitmap: TBGRABitmap);
    procedure CalculateMass;
    procedure BorderCollision(const ARect: TRect; const AInside: boolean = TRUE);
    procedure Collide(const ABall: TBall);
    procedure Move;
  end;

implementation
 
uses
  BGRAGradients, Geometry;

constructor TBall.Create(const APos, ASpeed: TPointF; const ARadius, AMass: single);
begin
  inherited Create;
  FX := APos.x;
  FY := APos.y;
  FRadius := ARadius;
  FMass := AMass;
  FSX := ASpeed.x;
  FSY := ASpeed.y;
  MakeBitmap;
end;
 
destructor TBall.Destroy;
begin
  FImage.Free;
  inherited Destroy;
end;
 
function TBall.GetPos: TPointF;
begin
  result.x := FX;
  result.y := FY;
end;
 
procedure TBall.SetPos(const AValue: TPointF);
begin
  FX := AValue.x;
  FY := AValue.y;
end;
 
function TBall.GetSpeed: TPointF;
begin
  result.x := FSX;
  result.y := FSY;
end;
 
procedure TBall.SetSpeed(const AValue: TPointF);
begin
  FSX := AValue.x;
  FSY := AValue.y;
end;
 
procedure TBall.MakeBitmap;
var
  LMap: TBGRABitmap;
  LPhong: TPhongShading;
begin
  LMap := CreateSpherePreciseMap(Round(FRadius * 2), Round(FRadius * 2));
  FImage := TBGRABitmap.Create(Round(FRadius * 2), Round(FRadius * 2));
  LPhong := TPhongShading.Create;
  LPhong.Draw(FImage, LMap, Round(FRadius), 0, 0, BGRA(0, 0, 255, 255));
  LPhong.Free;
  LMap.Free;
end;
 
procedure TBall.Move;
begin
  FX := FX + FSX;
  FY := FY + FSY;
end;
 
procedure TBall.BorderCollision(const ARect: TRect; const AInside: boolean = TRUE);
begin
  if AInside then
  begin
    if ((FX - FRadius < ARect.Left  ) and (FSX < 0))
    or ((FX + FRadius > ARect.Right ) and (FSX > 0)) then
      FSX := -1 * FSX;
    if ((FY - FRadius < ARect.Top   ) and (FSY < 0))
    or ((FY + FRadius > ARect.Bottom) and (FSY > 0)) then
      FSY := -1 * FSY;
  end else
    if EllipseRectCollision(Rect(Round(FX - FRadius), Round(FY - FRadius), Round(FX + FRadius), Round(FY + FRadius)), ARect) then
    begin
      if ((FY < ARect.Top   ) and (FSY > 0))
      or ((FY > ARect.Bottom) and (FSY < 0)) then
        FSY := -1 * FSY;
      if ((FX < ARect.Left  ) and (FSX > 0))
      or ((FX > ARect.Right ) and (FSX < 0)) then
        FSX := -1 * FSX;
    end;
end;
 
procedure TBall.Collide(const ABall: TBall);
var
  a, b, c, d, e, f, g, h, i, j, k, l, m: single;
begin
  a := ABall.Position.x - FX;
  b := ABall.Position.y - FY;
  c := a * a + b * b;
  d := FRadius + ABall.Radius;
 
  if c <= d * d then
  begin
    d := Sqrt(c);
    e := a / d;
    f := b / d;
    g := FSX * e + FSY * f;
    h := ABall.Speed.x * e + ABall.Speed.y * f;
 
    if g - h < 0 then
      Exit;
 
    i := FSY * e - FSX * f;
    j := ABall.Speed.y * e - ABall.Speed.x * f;
    k := FMass + ABall.Mass;
    l := (FMass - ABall.Mass) / k * g + 2 * ABall.Mass / k * h;
    m := (ABall.Mass - FMass) / k * h + 2 * FMass / k * g;
 
    FSX := l * e - i * f;
    FSY := l * f + i * e;
 
    ABall.Speed := PointF(m * e - j * f, m * f + j * e);
  end;
end;
 
procedure TBall.CalculateMass;
begin
  FMass := 4 / 3 * FRadius * FRadius * FRadius * PI;
end;
 
procedure TBall.Render(const ABitmap: TBGRABitmap);
begin
  ABitmap.PutImage(Round(FX - (FImage.Width - 1) / 2), Round(FY - (FImage.Height - 1) / 2), FImage, dmDrawWithTransparency);
end;
 
end.
