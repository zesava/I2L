{*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <thesava@gmail.com> wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return. Savechka Andriy.
 * ----------------------------------------------------------------------------
 *}

unit Queue;

interface

uses Windows, SyncObjs;

type
  TElement = Integer;
  TNodePointer = ^TNode;
  TNode = record
    value: TElement;
    next: TNodePointer;
  end;

  TQueue = class(TObject)
  private
    FHead: TNodePointer;
    FTail: TNodePointer;
    FMaxSize: Integer;
    FActualSize: Integer;
    FLastItem: TElement;
    FEBufWindow: THandle;
    FCriticalSection: TCriticalSection;
  protected

  public
    constructor Create;
    destructor Destroy; override;
    procedure Enqueue(NewItem: TElement);
    procedure Reset;
    function Dequeue: TElement;
    function isEmpty: boolean;
    property MaxSize: Integer read FMaxSize write FMaxSize default 128;
    property ActualSize: Integer read FActualSize;
  end;

implementation

uses SysUtils;

constructor TQueue.Create;
begin
  FHead := nil;
  FTail := nil;
  FCriticalSection := TCriticalSection.Create;
  FEBufWindow := CreateEvent(nil, True, True, nil);
end;

destructor TQueue.Destroy;
begin
  Reset;
  CloseHandle(FEBufWindow);
  FreeAndNil(FCriticalSection);
end;

procedure TQueue.Reset;
begin
  while not isEmpty do
    Dequeue;
  FHead := nil;
  FTail := nil;
  FActualSize := 0;
  SetEvent(FEBufWindow);
end;

procedure TQueue.Enqueue(NewItem: TElement);
var
  temp: TNodePointer;
begin
  FLastItem := NewItem;

  if FActualSize + NewItem >= FMaxSize - 1 then
    ResetEvent(FEBufWindow);

  {This will lock producer thread if buffer is full}
  WaitForSingleObject(FEBufWindow, INFINITE);

  FCriticalSection.Enter;
  FActualSize := FActualSize + NewItem;
  New(temp);
  temp^.value := NewItem;
  temp^.next := nil;
  if (isEmpty) then
  begin
    FHead := temp;
    FTail := temp;
  end
  else
  begin
    FTail^.next := temp;
    FTail := temp;
  end;
  FCriticalSection.Leave;
end;

function TQueue.Dequeue: TElement;
var
  temp: TNodePointer;
begin

  FCriticalSection.Enter;
  if not isEmpty then
  begin
    temp := FHead;
    FHead := FHead^.next;
    result := temp^.value;
    FActualSize := FActualSize - Result;
    Dispose(temp);

    if FActualSize + FLastItem <= FMaxSize - 1 then
      SetEvent(FEBufWindow);
  end
  else
    result := 0;
  FCriticalSection.Leave;
end;

function TQueue.isEmpty: boolean;
begin
  result := FHead = nil;
end;

end.

