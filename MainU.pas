{*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <thesava@gmail.com> wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return. Savechka Andriy.
 * ----------------------------------------------------------------------------
 *}

{$SETPEFLAGS 1}
unit MainU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, ComCtrls, ExtCtrls, CommCtrl, Math,
  //****************************************************************************
  Global,
  ComPort,
  Printer,
  Config,
  FileParser,
  ColorButton, Grids;

type
  TfmMain = class(TForm)
    pnl1: TPanel;
    img1: TImage;
    pnl3: TPanel;
    pgcGCODE: TPageControl;
    ts1: TTabSheet;
    grpScan: TGroupBox;
    edtToolDiam: TEdit;
    tsConnection: TTabSheet;
    stat1: TStatusBar;
    grpConnection: TGroupBox;
    cbbBaudRate: TComboBox;
    btnPortRefresh: TButton;
    btnConnect: TButton;
    btnDisconnect: TButton;
    grpMotion: TGroupBox;
    btnXPlus: TButton;
    btnXMinus: TButton;
    btnYPlus: TButton;
    btnYMinus: TButton;
    edtStep: TEdit;
    btnZPlus: TButton;
    btnZMinus: TButton;
    btn001: TButton;
    btn01: TButton;
    btn1: TButton;
    btn5: TButton;
    btn10: TButton;
    btn100: TButton;
    grpReference: TGroupBox;
    btnHoming: TButton;
    btnZeroing: TButton;
    grpLaser: TGroupBox;
    edtLaserPower: TEdit;
    btnSetLaserPower: TButton;
    btnLaserOn: TButton;
    btnLaserOff: TButton;
    cbbPort: TComboBox;
    pnl2: TPanel;
    grpFeed: TGroupBox;
    edtFeedRate: TEdit;
    lblFeed: TLabel;
    grpLaserProfile: TGroupBox;
    edtPowerMax: TEdit;
    lblPowerMax: TLabel;
    lblPowerMin: TLabel;
    edtPowerMin: TEdit;
    lblDescr: TLabel;
    lblDistance: TLabel;
    chkAutoConnect: TCheckBox;
    grpPreset: TGroupBox;
    cbbPreset: TComboBox;
    btnAddPreset: TButton;
    btnPresetRemove: TButton;
    btnPresetSave: TButton;
    pbConverter: TProgressBar;
    lblProgress: TLabel;
    btnReset: TColorButton;
    grpControl: TGroupBox;
    btnPrint: TButton;
    btnShowDimensions: TButton;
    btnOpenPicture: TButton;
    lblXY: TLabel;
    tsInfo: TTabSheet;
    mmoInfo: TMemo;
    cbbScanMethod: TComboBox;
    lblMethod: TLabel;
    btnCycleStart: TColorButton;
    btnFeedHold: TColorButton;
    grpStartPoint: TGroupBox;
    edtStartX: TEdit;
    edtStartY: TEdit;
    lblStartX: TLabel;
    lblStartY: TLabel;
    strngrdLog: TStringGrid;
    btnUnlock: TColorButton;
    cbbHeadCommand: TComboBox;
    lblHeadCommand: TLabel;
    btnGrblSettings: TButton;
    tsFile: TTabSheet;
    grpFile: TGroupBox;
    edtFileName: TEdit;
    btnBrowse: TButton;
    btnSendFile: TButton;
    btnStopSending: TButton;
    btnCheck: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtToolDiamKeyPress(Sender: TObject; var Key: Char);
    procedure edtFeedRateKeyPress(Sender: TObject; var Key: Char);

    procedure btnOpenPictureClick(Sender: TObject);
    procedure btnPortRefreshClick(Sender: TObject);
    procedure cbbPortChange(Sender: TObject);
    procedure cbbBaudRateChange(Sender: TObject);

    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure edtStepKeyPress(Sender: TObject; var Key: Char);
    procedure btn001Click(Sender: TObject);
    procedure btn01Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn100Click(Sender: TObject);
    procedure btnYPlusClick(Sender: TObject);
    procedure btnYMinusClick(Sender: TObject);
    procedure btnXPlusClick(Sender: TObject);
    procedure btnXMinusClick(Sender: TObject);
    procedure btnZPlusClick(Sender: TObject);
    procedure btnZMinusClick(Sender: TObject);
    procedure btnHomingClick(Sender: TObject);
    procedure btnZeroingClick(Sender: TObject);
    procedure btnUnlockClick(Sender: TObject);
    procedure btnRESETClick(Sender: TObject);
    procedure btnSetLaserPowerClick(Sender: TObject);
    procedure btnLaserOnClick(Sender: TObject);
    procedure btnLaserOffClick(Sender: TObject);
    procedure edtLaserPowerKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrintClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnShowDimensionsClick(Sender: TObject);
    procedure chkAutoConnectClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddPresetClick(Sender: TObject);
    procedure cbbPresetChange(Sender: TObject);
    procedure btnPresetSaveClick(Sender: TObject);
    procedure btnPresetRemoveClick(Sender: TObject);
    procedure edtFeedRateChange(Sender: TObject);
    procedure edtPowerMinChange(Sender: TObject);
    procedure edtPowerMaxChange(Sender: TObject);
    procedure edtToolDiamChange(Sender: TObject);
    procedure edtPowerMinKeyPress(Sender: TObject; var Key: Char);
    procedure edtPowerMaxKeyPress(Sender: TObject; var Key: Char);
    procedure btnSendClick(Sender: TObject);
    procedure btnFeedHoldClick(Sender: TObject);
    procedure btnCycleStartClick(Sender: TObject);
    procedure edtManCmdChange(Sender: TObject);
    procedure cbbScanMethodChange(Sender: TObject);
    procedure edtStartXKeyPress(Sender: TObject; var Key: Char);
    procedure edtStartYKeyPress(Sender: TObject; var Key: Char);
    procedure edtStartXExit(Sender: TObject);
    procedure edtStartYExit(Sender: TObject);
    procedure cbbHeadCommandChange(Sender: TObject);
    procedure btnGrblSettingsClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnSendFileClick(Sender: TObject);
    procedure btnStopSendingClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);

  private
    FPicture: TBitmap;
    FSerial: TComPort;
    FPrinter: TPrinter;
    FFileParser: TFileParser;
    FRefreshTimer: TTimer;
    FCfg: TConfig;
    FStartTime: TDateTime;

    function updatePicRes(gap: Real): string;
    procedure GetState(sender: TObject);
    procedure UpdatePresetCbb;
    procedure OnThreadNotify(var Message: TMessage); message WM_POST_MSG;

    procedure OnProgress(PtcDone: Extended);
    procedure OnPresetLoad(Sender: TObject);
    procedure OnPrintFin(Sender: TObject);
    procedure OnMsg(MsgType: string; MsgText: string);
  public
    { Public declarations }

  end;

var
  fmMain: TfmMain;

implementation

uses
  GrblSettings;

{$R *.dfm}

//------------------------------------------------------------------------------
// GUI update code
//------------------------------------------------------------------------------

procedure TfmMain.UpdatePresetCbb;
var
  l: TStringList;
begin
  l := TStringList.Create;
  FCfg.PresetsEnumerate(l);
  cbbPreset.Clear;
  cbbPreset.Items := l;
  FreeAndNil(l);
  cbbPreset.ItemIndex := FCfg.PresetIndex;
end;

procedure TfmMain.OnMsg(MsgType: string; MsgText: string);
var
  LastRow: Integer;
begin
  if Length(strngrdLog.Cells[0, 1]) > 0 then
    strngrdLog.RowCount := strngrdLog.RowCount + 1;
  LastRow := strngrdLog.RowCount;
  strngrdLog.Cells[0, LastRow - 1] := TimeToStr(Now);
  strngrdLog.Cells[1, LastRow - 1] := MsgType;
  strngrdLog.Cells[2, LastRow - 1] := MsgText;
  strngrdLog.Row := LastRow - 1;
end;

procedure TfmMain.OnThreadNotify(var Message: TMessage);
begin
  stat1.Panels[0].Text := Trim(string(PChar(Pointer(Message.LParam))));
end;

function TfmMain.updatePicRes(gap: Real): string;
begin
  if gap <> 0 then
    Result :=
      FormatFloat('0.0mm', FPicture.Width * gap) +
      FormatFloat(' x 0.0mm', FPicture.Height * gap) +
      ' @ ' + FormatFloat('0dpi', 25.4 / gap)
  else
    Result := 'N/A';
end;

procedure TfmMain.OnPresetLoad;
begin
  edtFeedRate.Text := IntToStr(FCfg.Preset.FeedRate);
  edtToolDiam.Text := FloatToStr(FCfg.Preset.ToolDiam);
  edtPowerMin.Text := FloatToStr(FCfg.Preset.PowMin);
  edtPowerMax.Text := FloatToStr(FCfg.Preset.PowMax);
  cbbScanMethod.ItemIndex := FCfg.Preset.Method;
end;

procedure TfmMain.OnProgress;
begin
  pbConverter.Position := Round(PtcDone);
  lblProgress.Caption := FormatFloat('0.0%', PtcDone);
end;

procedure TfmMain.OnPrintFin;
begin
  OnMsg('Info', 'Printing Done! Working time ' + TimeToStr(Now - FStartTime));
  btnPrint.Enabled := True;
  btnSendFile.Enabled := True;
  EnDisControls(grpScan, True);
  EnDisControls(grpMotion, True);
  EnDisControls(grpReference, True);
  EnDisControls(grpLaser, True);
  EnDisControls(grpControl, True);
  EnDisControls(grpStartPoint, True);
end;

//*****************************************************************************

procedure TfmMain.FormCreate(Sender: TObject);
var
  ProgressBarStyle: integer;
begin
  //Override regional settings and use dot as decimal separator
  // this is important for generating valid G-Code
  DecimalSeparator := '.';
  //some visual hacks
  fmMain.Caption := 'Dot Magic' + GetAppVersion;
  //remove progress bar border
  ProgressBarStyle := GetWindowLong(pbConverter.Handle,
    GWL_EXSTYLE);
  ProgressBarStyle := ProgressBarStyle
    - WS_EX_STATICEDGE;
  SetWindowLong(pbConverter.Handle,
    GWL_EXSTYLE,
    ProgressBarStyle);
  // set progress bar color
  SendMessage(pbConverter.Handle, PBM_SETBARCOLOR, 0, clLime);

  lblProgress.Parent := pbConverter;
  lblProgress.Left := (pbConverter.Width - lblProgress.Width) div 2;
  lblProgress.Top := 1;
  lblProgress.Transparent := True;

  //Disable controls
  EnDisControls(grpMotion, False);
  EnDisControls(grpReference, False);
  EnDisControls(grpLaser, False);
  EnDisControls(grpControl, False);
  btnRESET.Enabled := False;

  //Creating objects
  FCfg := TConfig.Create(nil);
  FCfg.OnChangePreset := OnPresetLoad;

  FSerial := TComPort.Create;
  FSerial.PacketDelimiter := #13#10;
  FSerial.OnMsg := OnMsg;
  //  FSerial.OnGrblConf := GetGrblSettings;

  FPicture := TBitmap.Create;

  chkAutoConnect.Checked := FCfg.AutoConnect;
  btnPortRefresh.Click;
  if FCfg.AutoConnect then
    btnConnect.Click;

  UpdatePresetCbb;
  OnPresetLoad(Self); {It's because config created faster than GUI}
  //  edtManCmd.Text := cfg.ManCmd;
  edtStartX.Text := FloatToStr(FCfg.StartX);
  edtStartY.Text := FloatToStr(FCfg.StartY);

  cbbHeadCommand.ItemIndex := FCfg.HeadMode;

  strngrdLog.Cells[0, 0] := 'Time';
  strngrdLog.Cells[1, 0] := 'Event';
  strngrdLog.Cells[2, 0] := 'Text';
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FCfg);
  FreeAndNil(FPicture);
  FreeAndNil(FSerial);
end;

//procedure TfmMain.stat1DrawPanel(StatusBar: TStatusBar;
//  Panel: TStatusPanel; const Rect: TRect);
//begin
//  with StatusBar.Canvas do
//  begin
//    case Panel.Index of
//      0: //first panel
//        begin
//          if AnsiCompareText(Panel.Text, 'ALARM') = 0 then
//            Brush.Color := clRed;
//          if AnsiCompareText(Panel.Text, 'Idle') = 0 then
//            Brush.Color := clYellow;
//          if AnsiCompareText(Panel.Text, 'Run') = 0 then
//            Brush.Color := clLime;
//          FillRect(Rect);
//          TextOut(Rect.Left, Rect.Top, Panel.Text);
//        end;
//      1: TextOut(Rect.Left, Rect.Top, Panel.Text);
//      2: TextOut(Rect.Left, Rect.Top, Panel.Text);
//      3: TextOut(Rect.Left, Rect.Top, Panel.Text);
//    end;
//
//  end;
//end;

procedure TfmMain.edtToolDiamKeyPress(Sender: TObject; var Key: Char);
begin
  CheckFloat(Sender, Key);
end;

procedure TfmMain.edtFeedRateKeyPress(Sender: TObject; var Key: Char);
begin
  CheckInt(Sender, Key);
end;

procedure TfmMain.btnOpenPictureClick(Sender: TObject);
var
  openDlg: TOpenDialog;
begin
  openDlg := TOpenDialog.Create(self);
  with openDlg do
  begin
    Title := 'Open Image';
    Options := [ofPathMustExist, ofFileMustExist];
    Filter := '8bit bitmap|*.bmp';
    if Execute then
    begin
      FPicture.LoadFromFile(FileName);
      //validate image
      if FPicture.PixelFormat = pf8bit then
      begin
        img1.Picture.Bitmap := FPicture;
        btnPrint.Enabled := True;
        btnShowDimensions.Enabled := True;
        lblXY.Caption := updatePicRes(FCfg.Preset.ToolDiam);
      end
      else
        MessageDlg('Picture is not valid 8 bit bitmap', mtError, [mbOK], 0);
      FPicture.FreeImage;
    end;
  end;
  FreeAndNil(openDlg);
end;

procedure TfmMain.btnPortRefreshClick(Sender: TObject);
var
  Ports: TStringList;
  i: Integer;
begin
  Ports := TStringList.Create;
  FSerial.EnumPorts(Ports);
  cbbPort.Items.Clear;
  cbbPort.Items.AddStrings(Ports);
  FreeAndNil(Ports);

  //Set portname to last used.
  i := cbbPort.Items.IndexOf(FCfg.PortName);
  if i > -1 then
    cbbPort.ItemIndex := i;

  //  set baudrate to last used
  i := cbbBaudRate.Items.IndexOf(IntToStr(FCfg.BaudRateVal));
  if i > -1 then
    cbbBaudRate.ItemIndex := i;

end;

procedure TfmMain.cbbPortChange(Sender: TObject);
begin
  FCfg.PortName := cbbPort.Text;
end;

procedure TfmMain.cbbBaudRateChange(Sender: TObject);
begin
  FCfg.BaudRateVal := StrToInt(cbbBaudRate.Text);
end;

procedure TfmMain.btnConnectClick(Sender: TObject);
begin
  FSerial.Open(fmMain.Handle, FCfg.PortName, FCfg.BaudRateVal);

  if FSerial.IsConnected then
  begin
    btnConnect.Enabled := False;
    cbbPort.Enabled := False;
    cbbBaudRate.Enabled := False;
    btnPortRefresh.Enabled := False;
    btnDisconnect.Enabled := True;
    btnGrblSettings.Enabled := True;

    EnDisControls(grpMotion, True);
    EnDisControls(grpReference, True);
    EnDisControls(grpLaser, True);
    EnDisControls(grpControl, True);
    btnRESET.Enabled := True;

    //    FRefreshTimer := TTimer.Create(nil);
    //    FRefreshTimer.Interval := 350;
    //    FRefreshTimer.OnTimer := GetState;

    OnMsg('Info', 'Connected to machine @ ' + FCfg.PortName + ':' +
      IntToStr(FCfg.BaudRateVal) + ' bps');

  end;

end;

procedure TfmMain.btnDisconnectClick(Sender: TObject);
begin
  FSerial.Close;
  if not FSerial.IsConnected then
  begin
    btnConnect.Enabled := True;
    cbbPort.Enabled := True;
    cbbBaudRate.Enabled := True;
    btnPortRefresh.Enabled := True;
    btnDisconnect.Enabled := False;

    EnDisControls(grpMotion, False);
    EnDisControls(grpReference, False);
    EnDisControls(grpLaser, False);
    EnDisControls(grpControl, False);

    btnRESET.Enabled := False;
    FreeAndNil(FRefreshTimer);
    OnMsg('Info', 'Disconnected from machine');
  end;
end;

procedure TfmMain.edtStepKeyPress(Sender: TObject; var Key: Char);
begin
  CheckFloat(Sender, Key);
end;

procedure TfmMain.btn001Click(Sender: TObject);
begin
  edtStep.Text := '0.01';
end;

procedure TfmMain.btn01Click(Sender: TObject);
begin
  edtStep.Text := '0.1';
end;

procedure TfmMain.btn1Click(Sender: TObject);
begin
  edtStep.Text := '1';
end;

procedure TfmMain.btn5Click(Sender: TObject);
begin
  edtStep.Text := '5';
end;

procedure TfmMain.btn10Click(Sender: TObject);
begin
  edtStep.Text := '10';
end;

procedure TfmMain.btn100Click(Sender: TObject);
begin
  edtStep.Text := '100';
end;

procedure TfmMain.btnYPlusClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('G91G0Y' + edtStep.Text);
end;

procedure TfmMain.btnYMinusClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('G91G0Y-' + edtStep.Text);
end;

procedure TfmMain.btnXPlusClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('G91G0X' + edtStep.Text);
end;

procedure TfmMain.btnXMinusClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('G91G0X-' + edtStep.Text);
end;

procedure TfmMain.btnZPlusClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('G91G0Z' + edtStep.Text);
end;

procedure TfmMain.btnZMinusClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('G91G0Z-' + edtStep.Text);
end;

procedure TfmMain.btnHomingClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('$H');
end;

procedure TfmMain.btnZeroingClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('G92X0Y0Z0');
end;

procedure TfmMain.btnUnlockClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('$X');
end;

procedure TfmMain.btnRESETClick(Sender: TObject);
begin
  if Assigned(FPrinter) then
  begin
    TerminateThread(FPrinter.Handle, 0); {Force thread termination}
    FreeAndNil(FPrinter); {clear the pointer}
  end;
  if Assigned(FFileParser) then
  begin
    TerminateThread(FFileParser.Handle, 0);
      FreeAndNil(FFileParser);
  end;
  OnPrintFin(self);
  FSerial.WriteStr(HexToString('18'));
  FSerial.ResetTXBuf;
  OnMsg('Info', ' *** RESET WAS PRESSED ***');
end;

procedure TfmMain.btnSetLaserPowerClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('S' + edtLaserPower.Text);
end;

procedure TfmMain.btnLaserOnClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('M3');
end;

procedure TfmMain.btnLaserOffClick(Sender: TObject);
begin
  FSerial.WriteGRBLBuffer('M5');
end;

procedure TfmMain.edtLaserPowerKeyPress(Sender: TObject; var Key: Char);
begin
  CheckInt(Sender, Key);
end;

procedure TfmMain.btnPrintClick(Sender: TObject);
begin
  if img1.Picture.Bitmap.Empty then
  begin
    ShowMessage('Open picture first :)');
    Exit;
  end;
  FSerial.ResetTXBuf;
  FPrinter := TPrinter.Create(True); {Creating suspended thread}
  FPrinter.Picture := FPicture;
  FPrinter.Param := @FCfg.Preset;
  FPrinter.StartX := FCfg.StartX;
  FPrinter.StartY := FCfg.StartY;
  FPrinter.HeadMode := FCfg.HeadMode;
  FPrinter.OnSendData := FSerial.WriteGRBLBuffer; {Assign callback procedure}
  FPrinter.OnTerminate := OnPrintFin;
  FPrinter.OnProgress := OnProgress;
  FPrinter.Priority := tpHigher;
  FPrinter.Resume; {Let the show begin :) }

  btnPrint.Enabled := False;

  EnDisControls(grpScan, False);
  EnDisControls(grpMotion, False);
  EnDisControls(grpReference, False);
  EnDisControls(grpLaser, False);
  EnDisControls(grpControl, False);
  EnDisControls(grpStartPoint, False);

  OnMsg('Info', 'Printing started...');
  FStartTime := Now;
end;

{Workaround for center positioning label if form resized}

procedure TfmMain.FormResize(Sender: TObject);
var
  i, lastColWidth: Integer;
begin
  lblProgress.Left := (pbConverter.Width - lblProgress.Width) div 2;

  lastColWidth := strngrdLog.Width;
  for i := 0 to strngrdLog.ColCount - 2 do
  begin
    lastColWidth := lastColWidth - strngrdLog.ColWidths[i];
  end;
  strngrdLog.ColWidths[2] := lastColWidth;
end;

procedure TfmMain.btnShowDimensionsClick(Sender: TObject);
var
  StartPoint: string;
  Xmax, Ymax: Real;
begin
  OnMsg('Info', 'Show picture dimensions');

  Xmax := FPicture.Width * FCfg.Preset.ToolDiam + FCfg.StartX;
  Ymax := FPicture.Height * FCfg.Preset.ToolDiam + FCfg.StartY;
  StartPoint := 'X' + FloatToStr(FCfg.StartX) + 'Y' + FloatToStr(FCfg.StartY);
  FSerial.WriteGRBLBuffer('F' + IntToStr(FCfg.Preset.FeedRate));
  FSerial.WriteGRBLBuffer('G90');
  FSerial.WriteGRBLBuffer(StartPoint);
  FSerial.WriteGRBLBuffer('S0M3');
  FSerial.WriteGRBLBuffer('X' + FloatToStr(Xmax));
  FSerial.WriteGRBLBuffer('Y' + FloatToStr(Ymax));
  FSerial.WriteGRBLBuffer('X' + FloatToStr(FCfg.StartX));
  FSerial.WriteGRBLBuffer('Y' + FloatToStr(FCfg.StartY));
  FSerial.WriteGRBLBuffer('M5');
end;

procedure TfmMain.chkAutoConnectClick(Sender: TObject);
begin
  FCfg.AutoConnect := chkAutoConnect.Checked;
end;

procedure TfmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #32 then
    btnRESET.Click;
end;

procedure TfmMain.btnAddPresetClick(Sender: TObject);
var
  value: string;
begin
  if InputQuery('Add new preset', 'Name of preset', value) then
    if (Length(value) > 0) and (Length(value) < 20) then
    begin
      FCfg.PresetAdd(value);
      UpdatePresetCbb;
    end
    else
      ShowMessage('Name length must be between 1 and 20 characters');
end;

procedure TfmMain.cbbPresetChange(Sender: TObject);
begin
  FCfg.PresetIndex := cbbPreset.ItemIndex;
end;

procedure TfmMain.btnPresetSaveClick(Sender: TObject);
begin
  FCfg.PresetApply(
    StrToInt(edtFeedRate.Text),
    StrToFloat(edtToolDiam.Text),
    StrToFloat(edtPowerMin.Text),
    StrToFloat(edtPowerMax.Text)
    );
  FCfg.PresetSave;

  edtFeedRate.Color := clWindow;
  edtToolDiam.Color := clWindow;
  edtPowerMax.Color := clWindow;
  edtPowerMin.Color := clWindow;
  cbbScanMethod.Color := clWindow;
end;

procedure TfmMain.btnPresetRemoveClick(Sender: TObject);
begin
  FCfg.PresetDelete;
  UpdatePresetCbb;
end;

procedure TfmMain.edtFeedRateChange(Sender: TObject);
begin
  if StrToIntDef(edtFeedRate.Text, 0) <> FCfg.Preset.FeedRate then
    edtFeedRate.Color := HighLightColor
  else
    edtFeedRate.Color := clWindow;
end;

procedure TfmMain.edtPowerMinChange(Sender: TObject);
begin
  if CompareValue(StrToFloatDef(edtPowerMin.Text, 0), FCfg.Preset.PowMin, 0.01)
    <> 0 then
    edtPowerMin.Color := HighLightColor
  else
    edtPowerMin.Color := clWindow;
end;

procedure TfmMain.edtPowerMaxChange(Sender: TObject);
begin
  if CompareValue(StrToFloatDef(edtPowerMax.Text, 0), FCfg.Preset.PowMax, 0.01)
    <> 0 then
    edtPowerMax.Color := HighLightColor
  else
    edtPowerMax.Color := clWindow;
end;

procedure TfmMain.edtToolDiamChange(Sender: TObject);
begin
  if CompareValue(StrToFloatDef(edtToolDiam.Text, 0), FCfg.Preset.ToolDiam, 0.01)
    <> 0 then
    edtToolDiam.Color := HighLightColor
  else
    edtToolDiam.Color := clWindow;
  lblXY.Caption := updatePicRes(StrToFloatDef(edtToolDiam.Text, 0));
end;

procedure TfmMain.edtPowerMinKeyPress(Sender: TObject; var Key: Char);
begin
  CheckFloat(Sender, Key);
end;

procedure TfmMain.edtPowerMaxKeyPress(Sender: TObject; var Key: Char);
begin
  CheckFloat(Sender, Key);
end;

procedure TfmMain.btnSendClick(Sender: TObject);
begin
  //  FSerial.WriteStr(edtManCmd.Text);
end;

procedure TfmMain.btnFeedHoldClick(Sender: TObject);
begin
  FSerial.WriteStr('!' + #13);
  //  FSerial.WriteGRBLBuffer('M5');
end;

procedure TfmMain.btnCycleStartClick(Sender: TObject);
begin
  // FSerial.WriteGRBLBuffer('M3');
  FSerial.WriteStr('~' + #13);
end;

procedure TfmMain.edtManCmdChange(Sender: TObject);
begin
  //  cfg.ManCmd := edtManCmd.Text;
end;

procedure TfmMain.cbbScanMethodChange(Sender: TObject);
begin
  FCfg.SetScanType(cbbScanMethod.ItemIndex);
  cbbScanMethod.Color := clYellow;
end;

procedure TfmMain.GetState;
begin
  FSerial.WriteStr('?');
end;

procedure TfmMain.edtStartXKeyPress(Sender: TObject; var Key: Char);
begin
  CheckFloat(Sender, Key);
end;

procedure TfmMain.edtStartYKeyPress(Sender: TObject; var Key: Char);
begin
  CheckFloat(Sender, Key);
end;

procedure TfmMain.edtStartXExit(Sender: TObject);
begin
  FCfg.StartX := StrToFloat(edtStartX.Text);
end;

procedure TfmMain.edtStartYExit(Sender: TObject);
begin
  FCfg.StartY := StrToFloat(edtStartY.Text);
end;

procedure TfmMain.cbbHeadCommandChange(Sender: TObject);
begin
  FCfg.HeadMode := cbbHeadCommand.ItemIndex;
end;

procedure TfmMain.btnGrblSettingsClick(Sender: TObject);
var
  fmGrblSettings: TGrblSettings;
begin
  fmGrblSettings := TGrblSettings.Create(Self, FSerial.GrblCfg);
  if fmGrblSettings.ShowModal = mrok then
    FSerial.GrblCfg := fmGrblSettings.fsl;
  FreeAndNil(fmGrblSettings);
end;

procedure TfmMain.btnBrowseClick(Sender: TObject);
var
  openDlg: TOpenDialog;
begin
  openDlg := TOpenDialog.Create(self);
  with openDlg do
  begin
    Title := 'Open G-Code file';
    Options := [ofPathMustExist, ofFileMustExist];
    Filter := 'G-Code files|*.ncg;*.nc;*.gcode';
    if Execute then
    begin
      edtFileName.Text := FileName;
      edtFileName.SelStart := Length(FileName)
    end;
  end;
  FreeAndNil(openDlg);
end;

procedure TfmMain.btnSendFileClick(Sender: TObject);
begin
  FFileParser := TFileParser.Create(True);
  FFileParser.FreeOnTerminate := True;
  FFileParser.FilePath := edtFileName.Text;
  FFileParser.OnSendData := FSerial.WriteGRBLBuffer;
  FFileParser.OnTerminate := OnPrintFin;
  FFileParser.Resume;
  FStartTime := Now;
  btnSendFile.Enabled := False;
end;

procedure TfmMain.btnStopSendingClick(Sender: TObject);
begin
  FFileParser.Terminate;
end;

procedure TfmMain.btnCheckClick(Sender: TObject);
begin
  FSerial.WriteStr('$C' + #13);
end;

end.

