{*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <thesava@gmail.com> wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return. Savechka Andriy.
 * ----------------------------------------------------------------------------
 *}

unit ComPort;

interface

uses
  SysUtils, Windows, Variants, StrUtils, Classes, Registry, Messages, Queue,
  Global;

const
  WM_POST_MSG = WM_USER + 1;

  EMsg: array[1..12] of string =
    ('Error creating read event',
    'Opps. There no one lives behind the port',
    'Error clearing port',
    'Error reading port',
    'Error opening port',
    'Error setting port state',
    'Error purging port',
    'Error setting port mask',
    'Error creating write event',
    'Error setting port timeouts',
    'Error writing port bytes',
    'Error writing text to port');

type
  EComPortError = class(Exception);

type
  TMsg = procedure(MsgType: string; MsgText: string) of object;

  TComPort = class;

  {Reading thread}
  TReadThread = class(TThread)
  private
    FComPort: TComPort;
    FOverRead: TOverlapped;
    FRead: DWORD;
    FBuf: array[0..1023] of Byte;
    procedure ParsePacket(pkt: string);
  protected
    procedure Execute; override;
  public
    constructor Create(ComPort: TComPort);
    destructor Destroy; override;

  end;

  {Com port class}
  TComPort = class
  private
    FOverWrite: TOverlapped;
    FPacketDelimiter: string;
    FGrblCfg: TCfgArr;
    FMsgType: string;
    FSettingsFlag: Boolean;
    FIsConnected: Boolean;

    FOnMsg: TMsg;
    FReadThread: TReadThread;
    FPort: THandle;
    FwndForNotify: THandle;
    FPacket: string;
    FTXBuf: TQueue;
    procedure DoMsgUpdate;
    function GetConfig: TCfgArr;
    procedure SetConfig(val: TCfgArr);
  public
    {Public procedures}
    destructor Destroy; override;
    procedure EnumPorts(Ports: TStringList); //returns available COM ports
    procedure Open(wnd: THandle; PortName: string; Baudrate: DWORD);
    procedure Close; //Close COM port
    procedure WriteBytesArr(WriteBytes: array of Byte);
    procedure WriteStr(s: string);
    procedure WriteGRBLBuffer(s: string);
    procedure ResetTXBuf;
    {Public properties}
    property OnMsg: TMsg read FOnMsg write FOnMsg;
    property GrblCfg: TCfgArr read GetConfig write SetConfig;
    property PacketDelimiter: string read FPacketDelimiter write
      FPacketDelimiter;
    property IsConnected: Boolean read FIsConnected;
  end;

implementation

constructor TReadThread.Create(ComPort: TComPort);
begin
  FComPort := ComPort;
  ZeroMemory(@FOverRead, SizeOf(FOverRead));

  {Event}
  FOverRead.hEvent := CreateEvent(nil, True, False, nil);

  if FOverRead.hEvent = Null then
    raise EComPortError.Create(EMsg[1]);

  inherited Create(False);
end;

destructor TReadThread.Destroy;
begin
  CloseHandle(FOverRead.hEvent);

  inherited Destroy;
end;

procedure TReadThread.Execute;
var
  ComStat: TComStat;
  dwMask, dwError: DWORD;
  i: Integer;
begin
  FreeOnTerminate := True;

  while not Terminated do
  begin
    if not WaitCommEvent(FComPort.FPort, dwMask, @FOverRead) then
    begin
      if GetLastError = ERROR_IO_PENDING then
        WaitForSingleObject(FOverRead.hEvent, INFINITE)
      else
        raise EComPortError.Create(EMsg[2]);
    end;
    if not Terminated then
      if not ClearCommError(FComPort.FPort, dwError, @ComStat) then
        raise EComPortError.Create(EMsg[3]);

    FRead := ComStat.cbInQue;

    if FRead > 0 then
    begin
      ZeroMemory(@FBuf, SizeOf(FBuf));
      if not ReadFile(FComPort.FPort, FBuf, FRead, FRead, @FOverRead) then
        raise EComPortError.Create(EMsg[4]);
      //========================================================================
       // Wait for full packet.
       //=======================================================================
      i := 0;
      while FBuf[i] <> $0 do
      begin
        FComPort.FPacket := FComPort.FPacket + Chr(FBuf[i]);
        if AnsiEndsStr(FComPort.FPacketDelimiter, FComPort.FPacket) then
        begin
          ParsePacket(FComPort.FPacket);
          FComPort.FPacket := '';
        end;
        Inc(i);
      end;
    end;
  end;
end;

procedure TReadThread.ParsePacket;
var
  a, b, i: Integer;
begin
  if AnsiStartsStr('ok', pkt) then
  begin
    FComPort.FTXBuf.Dequeue;
    if FComPort.FSettingsFlag then
      FComPort.FSettingsFlag := False;
    Exit;
  end

  else if AnsiStartsStr('<', pkt) then
  begin
    PostMessage(FComPort.FWndForNotify, WM_POST_MSG, 0,
      Integer(Pointer(pkt)));
    Exit;
  end

  else if AnsiStartsStr('[', pkt) then
    FComPort.FMsgType := 'Feedback'

  else if AnsiStartsStr('ALARM', pkt) then
    FComPort.FMsgType := 'ALARM'

  else if AnsiStartsStr('error', pkt) then
    FComPort.FMsgType := 'ERROR'

  else if AnsiStartsStr('Grbl', pkt) then
    FComPort.FMsgType := 'Info'

  else if AnsiStartsStr('$', pkt) then
  begin
    {Array of GRBL config}
    i := Length(FComPort.FGrblCfg);
    SetLength(FComPort.FGrblCfg, i + 1);
    {our little helpers :) }
    a := AnsiPos('(', pkt);
    b := AnsiPos('=', pkt);

    FComPort.FGrblCfg[i].Num := AnsiReplaceStr(Copy(pkt, 1, b - 1), '$', '');
    FComPort.FGrblCfg[i].Val := Trim(Copy(pkt, b + 1, a - b - 1));
    FComPort.FGrblCfg[i].Desc := Trim(Copy(pkt, a + 1, Length(pkt) - a - 3));
    Exit;
  end
  else
    Exit;

  Synchronize(FComPort.DoMsgUpdate);
end;

procedure TComPort.DoMsgUpdate;
begin
  if Assigned(FOnMsg) then
    FOnMsg(FMsgType, Trim(FPacket));
end;

destructor TComPort.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TComPort.Open(wnd: THandle; PortName: string; Baudrate: DWORD);
var
  Dcb: TDcb;
  CT: TCommTimeouts;
begin
  FwndForNotify := wnd;

  {GRBL Buffer counter}
  FTXBuf := TQueue.Create;
  FTXBuf.MaxSize := RX_BUFFER_SIZE;

  ZeroMemory(@FOverWrite, SizeOf(FOverWrite));
  {Open port}
  FPort := CreateFile(PChar(PortName),
    GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);

  if FPort = INVALID_HANDLE_VALUE then
    raise EComPortError.Create(PortName + ':' + EMsg[5]);

  try
    {Set port state}
    if not GetCommState(FPort, Dcb) then
      raise EComPortError.Create(PortName + ':' + EMsg[6]);

    Dcb.BaudRate := Baudrate;
    Dcb.Parity := NOPARITY;
    Dcb.ByteSize := 8;
    Dcb.StopBits := ONESTOPBIT;

    if not SetCommState(FPort, Dcb) then
      raise EComPortError.Create(PortName + ':' + EMsg[6]);

    {Purge port}
    if not PurgeComm(FPort, PURGE_TXCLEAR or PURGE_RXCLEAR) then
      raise EComPortError.Create(PortName + ':' + EMsg[7]);

    {Set mask}
    if not SetCommMask(FPort, EV_RXCHAR) then
      raise EComPortError.Create(PortName + ':' + EMsg[8]);

    FOverWrite.hEvent := CreateEvent(nil, True, False, nil);

    if FOverWrite.hEvent = Null then
      raise EComPortError.Create(PortName + ':' + EMsg[9]);

    {Set timeouts}
    CT.ReadTotalTimeoutConstant := 50;
    CT.ReadIntervalTimeout := 50;
    CT.ReadTotalTimeoutMultiplier := 1;
    CT.WriteTotalTimeoutMultiplier := 10;
    CT.WriteTotalTimeoutConstant := 10;

    if not SetCommTimeouts(FPort, CT) then
      raise EComPortError.Create(PortName + ':' + EMsg[10]);

    {Reading thread}
    FReadThread := TReadThread.Create(Self);
    FIsConnected := True;
  except
    CloseHandle(FOverWrite.hEvent);
    CloseHandle(FPort);
    FIsConnected := False;
    raise;
  end;
end;

procedure TComPort.Close;
begin
  try
    if Assigned(FReadThread) then
      FReadThread.Terminate;
    CloseHandle(FOverWrite.hEvent);
    CloseHandle(FPort);
    FreeAndNil(FTXBuf);
    FIsConnected := False;
  except
    raise;
  end;
end;

procedure TComPort.WriteBytesArr(WriteBytes: array of Byte);
var
  dwWrite: DWORD;
begin
  if (not WriteFile(FPort, WriteBytes, SizeOf(WriteBytes), dwWrite, @FOverWrite))
    and (GetLastError <> ERROR_IO_PENDING) then
    raise EComPortError.Create(EMsg[11]);
end;

procedure TComPort.WriteStr(s: string);
var
  dwWrite: DWORD;
begin
  if not WriteFile(FPort, s[1], Length(s), dwWrite, @FOverWrite)
    and (GetLastError <> ERROR_IO_PENDING) then
    raise EComPortError.Create(EMsg[12]);
end;

function TComPort.GetConfig;
begin
  SetLength(FGrblCfg, 0); //Reset config var
  FSettingsFlag := True; //Set flag
  WriteStr('$$' + #13); // Send request to Grbl
  Sleep(SETTINGS_TIMEOUT); // Waiting response
  Result := FGrblCfg; // Returning result
end;

procedure TComPort.SetConfig(val: TCfgArr);
var
  i: Integer;
begin
  for i := 0 to Length(val) - 1 do
  begin
    if val[i].isChanged then
      WriteStr('$' + val[i].Num + '=' + val[i].Val + #13);
      Sleep(100);
  end;
end;

procedure TComPort.WriteGRBLBuffer(s: string);
var
  tmp: string;
begin
  tmp := s + #13;
  {IMPORTANT! Save call sequence in this order.
  First we have to decide that we can send line, and only after, send it.
  In other case we can overflow GRBL receive buffer}
  FTXBuf.Enqueue(Length(tmp));
  WriteStr(tmp);
end;

procedure TComPort.ResetTXBuf;
begin
  FTXBuf.Reset;
end;

procedure TComPort.EnumPorts(Ports: TStringList);
var
  i: Byte;
begin
  with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('hardware\devicemap\serialcomm', False) then
        try
          Ports.BeginUpdate;
          try
            GetValueNames(Ports);
            for i := Ports.Count - 1 downto 0 do
              Ports.Strings[i] := ReadString(Ports.Strings[i]);
            Ports.Sort
          finally
            Ports.EndUpdate
          end
        finally
          CloseKey
        end
      else
        Ports.Clear
    finally
      Free
    end
end;

end.

