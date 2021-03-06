unit frmMain_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pngimage, StdCtrls;

type
  TPipe = class
    private
      Top: TImage;
      Bottom: TImage;

      procedure Reset;
    public
      procedure Move;
      Constructor Create(iPipe_Num: Integer);
      Destructor Discard;
  end;

  TfrmMain = class(TForm)
    imgPlayer: TImage;
    trmPhys: TTimer;
    lblScore: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure trmPhysTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    iYVelocity: Integer;
    Pipe1, Pipe2, Pipe3: TPipe;

    procedure Start_Game;
    procedure Game_Over;
    procedure Check_Collision(pipe: TPipe);
  public
    iScore: Integer;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Check_Collision(pipe: TPipe);
begin
  with pipe do
    begin
      if (Top.Left < imgPlayer.Left + imgPlayer.Width) and (Top.Left + Top.Width > imgPlayer.Left) and (Top.Top < imgPlayer.Top + imgPlayer.Height) and (Top.Top + Top.Height > imgPlayer.Top) then
        begin
          Game_Over;
        end;

      if (Bottom.Left < imgPlayer.Left + imgPlayer.Width) and (Bottom.Left + Bottom.Width > imgPlayer.Left) and (Bottom.Top < imgPlayer.Top + imgPlayer.Height) and (Bottom.Top + Bottom.Height > imgPlayer.Top) then
        begin
          Game_Over;
        end;
      end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = 'w') or (Key = 'W') or (Key = ' ') then
    iYVelocity := 7;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Start_Game;
end;

procedure TfrmMain.Game_Over;
begin
   trmPhys.Enabled := False;
   Showmessage('Game Over' + #10 + 'Score: ' + IntToStr(iScore));
   Pipe1.Discard;
   Pipe2.Discard;
   Pipe3.Discard;
   Start_Game;
end;

procedure TfrmMain.Start_Game;
begin
  trmPhys.Enabled := True;
  imgPlayer.Top := 160;
  iYVelocity := -5;
  Pipe1 := TPipe.Create(1);
  Pipe2 := TPipe.Create(2);
  Pipe3 := TPipe.Create(3);
  iScore := 0;
  lblScore.Caption := '0';
end;

procedure TfrmMain.trmPhysTimer(Sender: TObject);
begin
  imgPlayer.Top := imgPlayer.Top + -iYVelocity;
  Pipe1.Move;
  Check_Collision(Pipe1);
  Pipe2.Move;
  Check_Collision(Pipe2);
  Pipe3.Move;
  Check_Collision(Pipe3);

  if (imgPlayer.Top > 500) or (imgPlayer.Top + imgPlayer.Width < 0) then
    begin
      Game_Over;
    end;


  if iYVelocity > -5 then
    iYVelocity := iYVelocity - 1;
end;

{ TPipe }

constructor TPipe.Create(iPipe_Num: Integer);
begin
  Top := TImage.Create(frmMain);
  Top.Parent := frmMain;
  Top.Picture.LoadFromFile('pipe_top.png');
  Top.Stretch := True;
  Top.Width := 50;
  Top.Left := 500 + (iPipe_Num * 200);
  Top.Height := Random(300);
  Top.Top := 0;

  Bottom := TImage.Create(frmMain);
  Bottom.Parent := frmMain;
  Bottom.Picture.LoadFromFile('pipe_bot.png');
  Bottom.Stretch := True;
  Bottom.Width := 50;
  Bottom.Left := 500 + (iPipe_Num * 200);
  Bottom.Top := Top.Height + 100;
  Bottom.Height := 500 - Bottom.Top;
end;

destructor TPipe.Discard;
begin
  Top.Free;
  Bottom.Free;
end;

procedure TPipe.Move;
begin
  Top.Left := Top.Left - 2;
  Bottom.Left := Bottom.Left - 2;

  if Top.Left + Top.Width < 0 then
    Reset;

  if Top.Left + Top.Width = frmMain.imgPlayer.Left then
    begin
      inc(frmMain.iScore);
      frmMain.lblScore.Caption := IntToStr(frmMain.iScore);
    end;

end;

procedure TPipe.Reset;
begin
  Top.Left := 550;
  Top.Height := Random(300) + 50;
  Top.Top := 0;
  Bottom.Left := 550;
  Bottom.Top := Top.Height + 100;
  Bottom.Height := 500 - Bottom.Top;
end;

end.
