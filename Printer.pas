{*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <thesava@gmail.com> wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return. Savechka Andriy.
 * ----------------------------------------------------------------------------
 *}
unit Printer;

interface
uses Classes, SysUtils, Graphics, Math, Global;

type
  TSendData = procedure(line: string) of object;

type
  TProgress = procedure(val: Extended) of object;

type
  TPrinter = class(TThread)
  private
    oldFeedrate: Real;
    FStartX, FStartY: Real;
    FHeadMode: Byte;
    FOnSendData: TSendData;
    FOnProgress: TProgress;
    FProgress: Extended;
    function GetDiagLine(x: Integer; y: Integer): string;
    function Intrplt(GrayVal: Byte): Real;

  protected
    procedure Execute; override;
    procedure PrintHorizontal;
    procedure PrintHorizontalZ;
    procedure PrintDiagonal;
    procedure DoSendData(ln: string);
    procedure DoProgress;

  public
    Param: ^TPreset;
    Picture: TBitmap;
    property StartX: Real read FStartX write FStartX;
    property StartY: Real read FStartY write FStartY;
    property HeadMode: Byte read FHeadMode write FHeadMode;
    property OnSendData: TSendData read FOnSendData write FOnSendData;
    property OnProgress: TProgress read FOnProgress write FOnProgress;

  end;

implementation

procedure TPrinter.Execute;
begin
  case FHeadMode of
    0:
      begin
        case Param.Method of
          0: PrintHorizontal;
          1: PrintDiagonal;
        end;
      end;
    {at the moment only horizontal image scanning implemented for etching mode}
    1: PrintHorizontalZ;
  end;
end;

{Interpolate a 8 bit grayscale value (0-255) between min,max}

function TPrinter.Intrplt(GrayVal: Byte): Real;
begin
  Result := Param.PowMin + (GrayVal * (Param.PowMax - Param.PowMin) / 255);
end;

procedure TPrinter.DoSendData;
begin
  if Assigned(FOnSendData) then
    FOnSendData(ln);
end;

procedure TPrinter.PrintHorizontal;
var
  X, XCalc, Y, oldY: integer;
  XOut, YOut: string;
  Row: pByteArray;
  OldGrayVal: Byte;
  GCLine: string;

begin
  DoSendData('F' + IntToStr(Param.FeedRate));
  oldFeedrate := Param.FeedRate;
  DoSendData('G90');
  DoSendData('G21');
  DoSendData('G1S0M3');

  //Loop thru picture from TOP to BOTTOM
  for Y := 0 to Picture.Height - 1 do
  begin
    // Max laser power(255) corresponds to black color, so we must invert grey value
    Row := pByteArray(Picture.Scanline[Y]);
    //Loop thru picture from LEFT to RIGHT
    for X := 0 to Picture.Width - 1 do
    begin
      GCLine := '';

      //ZizZag Logic
      if Odd(Y) then
        XCalc := Picture.Width - 1 - X
      else
        XCalc := X;

      {Calculating final X/Y coord}
      XOut :=FormatFloat('0.###', XCalc * Param.ToolDiam + StartX);
      YOut := FormatFloat('0.###',(Picture.Height - Y) * Param.ToolDiam + FStartY);

      if Y <> oldY then // Add Y if it changed
      begin
        GCLine := 'X' + XOut + 'Y' + YOut;
        oldY := Y
      end
      else // Add only X
        GCLine := 'X' + XOut;

      {Getting pixel gray value}
      if OldGrayVal <> 255 - Row[XCalc] then
        // Add laser power value if color changed
        GCLine := GCLine + 'S' + FormatFloat('0.##', Intrplt(255 - Row[XCalc]));
      OldGrayVal := 255 - Row[XCalc];

      if Length(GCLine) > 1 then
      begin
        // Set Feedrate value if changed
        if oldFeedrate <> Param.FeedRate then
        begin
          DoSendData('F' + IntToStr(Param.FeedRate));
          oldFeedrate := Param.FeedRate;
        end;
        DoSendData(GCLine);
      end;
     // Exit loop on terminate request
      if Terminated then
        exit;
    end;
    // each line refresh progress
    FProgress := Y * 100 / (Picture.Height - 1);
    Synchronize(DoProgress);
  end;
  // Send end of G-Code program operator
  DoSendData('M5M30');
end;

function TPrinter.GetDiagLine(x: Integer; y: Integer):
  string;
var
  Row: pByteArray;
begin
  Row := pByteArray(Picture.Scanline[y]);
  // INFO: Max laser power(255) corresponds to black color, so we must invert grey value

  Result := 'X' + FormatFloat('0.###',(x * Param.ToolDiam + FStartX)) + 'Y' +
    FormatFloat('0.###',(Picture.Height - y) * Param.ToolDiam + FStartY) + 'S' +
    FormatFloat('0.##', Intrplt(255 - Row[x]));
end;

procedure TPrinter.PrintDiagonal;
var
  i, m, n, y, x: Integer;
begin
  DoSendData('F' + IntToStr(Param.FeedRate));
  oldFeedrate := Param.FeedRate;
  DoSendData('G90');
  DoSendData('G21');
  DoSendData('G1S0M3');

  n := Picture.Height - 1;
  m := Picture.Width - 1;

  //Mind blow logic :)
  for i := 0 to m + n do
  begin
    if i mod 2 = 1 then
      for y := Min(i, n - 1) downto Max(0, i - m + 1) do
        DoSendData(GetDiagLine(i - y, y))
    else
      for x := Min(i, m - 1) downto Max(0, i - n + 1) do
        DoSendData(GetDiagLine(x, i - x));

    // Set Feedrate value if changed
    if oldFeedrate <> Param.FeedRate then
    begin
      DoSendData('F' + IntToStr(Param.FeedRate));
      oldFeedrate := Param.FeedRate;
    end;

    // Refresh progress
    FProgress := i * 100 / (m + n);
    Synchronize(DoProgress);

    // Exit loop on terminate request
    if Terminated then
      exit;
  end;
  // Send end of G-Code program operator
  DoSendData('M5M30');
end;

procedure TPrinter.PrintHorizontalZ;
var
  X, XCalc, Y, oldY: integer;
  Row: pByteArray;
  OldGrayVal: Byte;
  XOut, YOut: string;
  GCLine: string;

begin
  DoSendData('F' + IntToStr(Param.FeedRate));
  oldFeedrate := Param.FeedRate;
  DoSendData('G90');
  DoSendData('G21');
  DoSendData('G1S0M3');

  //Loop thru picture from TOP to BOTTOM
  for Y := 0 to Picture.Height - 1 do
  begin
    Row := pByteArray(Picture.Scanline[Y]);
    //Loop thru picture from LEFT to RIGHT
    for X := 0 to Picture.Width - 1 do
    begin
      GCLine := '';

      //ZizZag Logic
      if Odd(Y) then
        XCalc := Picture.Width - 1 - X
      else
        XCalc := X;

      XOut := FormatFloat('0.###',XCalc * Param.ToolDiam + FStartX);
      YOut := FormatFloat('0.###',Y * Param.ToolDiam + FStartY);

      if Row[XCalc] > 0 then // if color not black then we can engrave
      begin
        if Y <> oldY then // Add Y if it changed
        begin
          GCLine := 'X' + XOut + 'Y' + YOut +
            'Z' + FormatFloat('0.##', Intrplt(Row[XCalc]));
          oldY := Y
        end
        else //Add only X
          GCLine := 'X' + XOut + 'Z' + FormatFloat('0.##',
            Intrplt(Row[XCalc]));
      end;

      if Length(GCLine) > 1 then
      begin
        // Set Feedrate value if changed
        if oldFeedrate <> Param.FeedRate then
        begin
          DoSendData('F' + IntToStr(Param.FeedRate));
          oldFeedrate := Param.FeedRate;
        end;
        DoSendData(GCLine);
        DoSendData('Z0');
      end;
      // Exit loop on terminate request
      if Terminated then
        exit;
    end;
    FProgress := Y * 100 / (Picture.Height - 1);
    Synchronize(DoProgress);
  end;
  // Send end of G-Code program operator
  DoSendData('M5M30');
end;

procedure TPrinter.DoProgress;
begin
  if Assigned(FOnProgress) then
    FOnProgress(FProgress);
end;

end.

