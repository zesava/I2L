unit FileParser;

interface
uses SysUtils, Classes;

type
  EFileParserError = class(Exception);

type
  TSendData = procedure(line: string) of object;

type
  TFileParser = class(TThread)
  private
    myFile: TextFile;
    cg_line: string;
    FOnSendData: TSendData;
    FFilePath: string;

    function Clean(inp: string): string;

  protected
    procedure Execute; override;
    procedure DoSendData(ln: string);

  public
    destructor Destroy; override;
    property OnSendData: TSendData read FOnSendData write FOnSendData;
    property FilePath: string read FFilePath write FFilePath;

  end;

implementation

destructor TFileParser.Destroy;
begin
  CloseFile(myFile);
  inherited Destroy;
end;

function TFileParser.Clean;
var
  tmp: string;
begin
  // Remove all spaces
  tmp := StringReplace(inp, ' ', '', [rfReplaceAll]);
  //Capitalize all letters
  tmp := AnsiUpperCase(tmp);

  tmp := Trim(tmp);

  //Remove comments if exist
  while AnsiPos(')', tmp) > 0 do
    Delete(tmp, AnsiPos('(', tmp), (AnsiPos(')', tmp) - AnsiPos('(', tmp) + 1));

  Result := tmp;
end;

procedure TFileParser.Execute;
var
  s: string;
begin
  AssignFile(myFile, FilePath);
  Reset(myFile);
  while not (Eof(myFile) or Terminated) do
  begin
    ReadLn(myFile, cg_line);
    s := Clean(cg_line);
    if Length(s) > 1 then
      DoSendData(s);
  end;
end;

procedure TFileParser.DoSendData;
begin
  if Assigned(FOnSendData) then
    FOnSendData(ln);
end;

end.

