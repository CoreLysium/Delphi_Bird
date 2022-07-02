program frmDelphiBird_p;

uses
  Forms,
  frmMain_u in 'frmMain_u.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
