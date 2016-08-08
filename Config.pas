unit Config;

interface

uses Classes, SysUtils, Global;

type

  TConfig = class(TComponent)

  private
    Path: string;

    FPortName: string;
    FBaudRateVal: Integer;
    FAutoConnect: Boolean;
    FIndex: Byte;
    FManCmd: string;
    FHeadMode:Byte;
    FStartX: Real;
    FStartY: Real;

    FActualPreset: TPreset;
    Repository: array of TPreset;
    FPresetChanged: TNotifyEvent;

    procedure ConfigLoad;
    procedure ConfigSave;
    procedure RepositoryLoad;
    procedure RepositorySave;
    procedure ChangePreset(index: Byte);

  public

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    procedure PresetsEnumerate(PL: TStringList);
    procedure PresetAdd(Name: string);
    procedure PresetDelete;
    procedure PresetApply(FeedRate: Integer; ToolDiam: Real; PowMin: Real;
      PowMax: Real);
    procedure PresetSave;
    procedure SetScanType(sc: byte);
    property Preset: TPreset read FActualPreset;
    property OnChangePreset: TNotifyEvent read FPresetChanged write
      FPresetChanged;

    // IMPORTANT. All props that needs to be stored must be defined as Published not Public
  published
    property PortName: string read FPortName write FPortName;
    property BaudRateVal: Integer read FBaudRateVal write FBaudRateVal;
    property AutoConnect: Boolean read FAutoConnect write FAutoConnect;
    property PresetIndex: Byte read FIndex write ChangePreset;
    property ManCmd: string read FManCmd write FManCmd;
    property HeadMode:Byte  read FHeadMode write FHeadMode;
    property StartX: Real read FStartX write FStartX;
    property StartY: Real read FStartY write FStartY;

  end;

  //var {Global, to use it from anywhere }
  //  cfg: TConfig;

implementation

constructor TConfig.Create(aOwner: TComponent);
begin
  inherited Create(AOWner);
  Path := ExtractFilePath(ParamStr(0));
  RepositoryLoad;
  ConfigLoad;
end;

destructor TConfig.Destroy;
begin
  inherited Destroy;
  RepositorySave;
  ConfigSave;
end;

procedure TConfig.ChangePreset(index: Byte);
begin
  FActualPreset := Repository[index];
  FIndex := index;
  if Assigned(FPresetChanged) then
    FPresetChanged(Self);
end;

procedure TConfig.PresetsEnumerate;
var
  i: byte;
begin
  PL.Clear;
  for i := Low(Repository) to High(Repository) do
    PL.Add(Repository[i].Name);
end;

procedure TConfig.ConfigSave;
begin
  WriteComponentResFile(Path + CONFIG_FILE, Self);
end;

procedure TConfig.ConfigLoad;
begin
  if FileExists(Path + CONFIG_FILE) then
    Self := TConfig(ReadComponentResFile(Path + CONFIG_FILE, Self))
  else
  begin
    FPortName := 'COM1';
    FBaudRateVal := 115200;
    FAutoConnect := False;
    PresetIndex := 0;
  end;
end;

procedure TConfig.RepositoryLoad;
var
  i: Byte;
  F: file of TPreset;
begin
  if FileExists(Path + PRESETS_FILE) then
  begin
    AssignFile(F, Path + PRESETS_FILE);
    Reset(F);
    i := 0;
    while not (EoF(F)) do
    begin
      SetLength(Repository, Length(Repository) + 1);
      Read(F, Repository[i]);
      Inc(i);
    end;
    CloseFile(F);
  end
  else
  begin
    SetLength(Repository, Length(Repository) + 1);
    Repository[0].Name := 'Default';
    Repository[0].FeedRate := 2600;
    Repository[0].ToolDiam := 0.1;
    Repository[0].PowMin := 0;
    Repository[0].PowMax := 8;
    Repository[0].Method := 0;
  end;
end;

procedure TConfig.RepositorySave;
var
  i: byte;
  F: file of TPreset;
begin
  AssignFile(F, Path + PRESETS_FILE);
  Rewrite(F);
  for i := Low(Repository) to High(Repository) do
    Write(F, Repository[i]);
  CloseFile(F);
end;

procedure TConfig.PresetAdd;
begin
  SetLength(Repository, Length(Repository) + 1);
  Repository[High(Repository)].Name := Name;
  PresetIndex := High(Repository);
end;

procedure TConfig.PresetDelete;
begin
  if Length(Repository) < 2 then
    Exit;

  if FIndex = High(Repository) then
  begin
    SetLength(Repository, Length(Repository) - 1);
    PresetIndex := High(Repository);
    Exit;
  end;

  Finalize(Repository[FIndex]);
  System.Move(Repository[FIndex + 1], Repository[FIndex],
    (Length(Repository) - FIndex - 1) * SizeOf(string) + 1);
  SetLength(Repository, Length(Repository) - 1);

  PresetIndex := High(Repository);
end;

procedure TConfig.PresetApply(FeedRate: Integer; ToolDiam: Real; PowMin:
  Real; PowMax: Real);
begin
  FActualPreset.FeedRate := FeedRate;
  FActualPreset.ToolDiam := ToolDiam;
  FActualPreset.PowMin := PowMin;
  FActualPreset.PowMax := PowMax;
end;

procedure TConfig.PresetSave;
begin
  Repository[FIndex] := FActualPreset;
end;  

procedure TConfig.SetScanType;
begin
  FActualPreset.Method := sc;
end;


//initialization
//  {-----------------------------------------------------------------------------
//   Creating the object in this section allow us using it
//      from anywhere and anytime.
//      Even from .DPR file and before forms creation.
//     Object Opciones is available from the beginning of the application
//  -----------------------------------------------------------------------------}
//  cfg := TConfig.Create(nil);
//  cfg.Load;
//
//finalization
//  //If we create it in Initialization, we destroy it here
//  cfg.Free;

end.

