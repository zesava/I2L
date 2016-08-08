unit GrblSettings;

interface

uses
  SysUtils, Classes, Windows, Graphics, Forms, Types,
  StdCtrls, ExtCtrls, Grids, Global, Controls;

type
  TGrblSettings = class(TForm)
    pnl1: TPanel;
    btnSave: TButton;
    pnl2: TPanel;
    sgSet: TStringGrid;
    btnCancel: TButton;
    procedure sgSetSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgSetDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgSetKeyPress(Sender: TObject; var Key: Char);
    procedure sgSetSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
  private
    { Private declarations }
  public
    fsl: TCfgArr;
    constructor Create(AOwner: TComponent; sl: TCfgArr);
  end;

implementation

{$R *.dfm}

constructor TGrblSettings.Create;
var
  i, lastColWidth: Integer;
begin
  inherited Create(AOwner);
  fsl := sl;
  lastColWidth := sgSet.Width;
  sgSet.ColWidths[0] := 40;
  sgSet.ColWidths[1] := 70;
  for i := 0 to sgSet.ColCount - 2 do
  begin
    lastColWidth := lastColWidth - sgSet.ColWidths[i];
  end;
  sgSet.ColWidths[2] := lastColWidth - 20;
  sgSet.Cells[0, 0] := 'Par#';
  sgSet.Cells[1, 0] := 'Value';
  sgSet.Cells[2, 0] := 'Description';

  for i := 0 to Length(sl) - 1 do
  begin
    if Length(sgSet.Cells[0, 1]) > 0 then
      sgSet.RowCount := i + 2;
    sgSet.Cells[0, i + 1] := sl[i].Num;
    sgSet.Cells[1, i + 1] := sl[i].Val;
    sgSet.Cells[2, i + 1] := sl[i].Desc;
  end;
end;


procedure TGrblSettings.sgSetSelectCell(Sender: TObject; ACol, ARow:
  Integer;
  var CanSelect: Boolean);
begin
  if ACol = 1 then
    sgSet.Options := sgSet.Options + [goEditing]
  else
    sgSet.Options := sgSet.Options - [goEditing];
end;

procedure TGrblSettings.sgSetDrawCell(Sender: TObject; ACol, ARow:
  Integer;
  Rect: TRect; State: TGridDrawState);
var
  S: string;
  SavedAlign: word;
begin
  if ACol = 1 then
  begin // ACol is zero based
    S := sgSet.Cells[ACol, ARow]; // cell contents
    SavedAlign := SetTextAlign(sgSet.Canvas.Handle, TA_CENTER);
    sgSet.Canvas.TextRect(Rect,
      Rect.Left + (Rect.Right - Rect.Left) div 2, Rect.Top + 2, S);
    SetTextAlign(sgSet.Canvas.Handle, SavedAlign);

    //    sgSet.Canvas.Brush.Color := clGreen;
    //    sgSet.Canvas.FillRect(Rect);
  end;

end;

procedure TGrblSettings.sgSetKeyPress(Sender: TObject;
  var Key: Char);
var
  p: Integer;
  t: string;
begin
  t := sgSet.Cells[sgSet.Col, sgSet.Row];
  p := Pos(Key, t);

  if not (Key in [#8, '0'..'9', '-', DecimalSeparator]) then
    Key := #0
  else if (Key = DecimalSeparator) and
    (p > 0) then
    Key := #0
  else if (Key = '-') and
    (p <> 0) then
    Key := #0;
end;

procedure TGrblSettings.sgSetSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  fsl[ARow - 1].Val := Value;
  fsl[ARow - 1].isChanged := True;
end;

end.

