program I2LEG;

uses
  Forms,
  MainU in 'MainU.pas' {fmMain},
  Config in 'Config.pas',
  ColorButton in 'ColorButton.pas',
  ComPort in 'ComPort.pas',
  Queue in 'Queue.pas',
  Printer in 'Printer.pas',
  Global in 'Global.pas',
  GrblSettings in 'GrblSettings.pas' {GrblSettings},
  FileParser in 'FileParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  {Prevent application change decimal separator on runtime.
  This bug was seen while launching photoshop during engraving}
  Application.UpdateFormatSettings := False;
  Application.Run;
end.
