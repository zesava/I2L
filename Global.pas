{*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <thesava@gmail.com> wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return. Savechka Andriy.
 * ----------------------------------------------------------------------------
 *}
unit Global;

interface

uses Windows, StdCtrls, SysUtils, Graphics;

{Structure for storing printer parameters}
type
  TPreset = packed record
    Name: string[30];
    FeedRate: Integer;
    ToolDiam: Real;
    PowMin: Real;
    PowMax: Real;
    Method: Byte;
  end;

type
  TGrblSet = packed record
    Num: string[4];
    Val: string;
    Desc: string;
    isChanged:Boolean;
  end;

type
  TCfgArr = array of TGrblSet;  

function GetAppVersion: string;
function HexToString(H: string): string;
procedure CheckFloat(Sender: TObject; var Key: Char);
procedure CheckInt(Sender: TObject; var Key: Char);
procedure EnDisControls(grpBox: TGroupBox; State: Boolean);

const
  HighLightColor = clYellow;
  RX_BUFFER_SIZE = 128;

  PRESETS_FILE = 'Presets.dat';
  CONFIG_FILE = 'Config.dat';
  SETTINGS_TIMEOUT = 1000;{time(msec) which is required for receiving settings}

implementation

function GetAppVersion: string;
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
begin
  Size := GetFileVersionInfoSize(PChar(ParamStr(0)), Size2);
  if Size > 0 then
  begin
    GetMem(Pt, Size);
    try
      GetFileVersionInfo(PChar(ParamStr(0)), 0, Size, Pt);
      VerQueryValue(Pt, '\', Pt2, Size2);
      with TVSFixedFileInfo(Pt2^) do
      begin
        Result := ' v' +
          IntToStr(HiWord(dwFileVersionMS)) + '.' +
          IntToStr(LoWord(dwFileVersionMS)) + '.' +
          IntToStr(HiWord(dwFileVersionLS)); // + '.' +
        //         IntToStr(LoWord(dwFileVersionLS));
      end;
    finally
      FreeMem(Pt);
    end;
  end;
end;

function HexToString(H: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to length(H) div 2 do
    Result := Result + Char(StrToInt('$' + Copy(H, (I - 1) * 2 + 1, 2)));
end;

procedure CheckFloat(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', '-', DecimalSeparator]) then
    Key := #0
  else if ((Key = DecimalSeparator) or (Key = '-')) and
    (Pos(Key, (Sender as TEdit).Text) > 0) then
    Key := #0
  else if (Key = '-') and
    ((Sender as TEdit).SelStart <> 0) then
    Key := #0;
end;

procedure CheckInt(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then
    Key := #0;
end;

procedure EnDisControls(grpBox: TGroupBox; State: Boolean);
var
  i: Integer;
begin
  for i := 0 to grpBox.ControlCount - 1 do
    grpBox.Controls[i].Enabled := State;
end;

//initialization

//finalization

end.

