unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, pixillacanvas;

type

  { TCanvasForm }

  TCanvasForm = class(TForm)
    cmbScale: TComboBox;
    pnlCanvas: TPanel;
    sBar: TStatusBar;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure pnlCanvasResize(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  CanvasForm: TCanvasForm;

implementation

{$R *.lfm}

{ TCanvasForm }

procedure UpdateFPSL(Str : String);
begin
   CanvasForm.sBar.Panels.Items[1].Text := 'Speed: ' + Str + ' fps';
end;

procedure TCanvasForm.FormCreate(Sender: TObject);
begin
   SetFPSCallBack(@UpdateFPSL);
end;

procedure TCanvasForm.pnlCanvasResize(Sender: TObject);
begin
  ResizeCanvas(pnlCanvas.ClientWidth, pnlCanvas.ClientHeight);
end;

procedure TCanvasForm.FormActivate(Sender: TObject);
begin
  CanvasInit(pnlCanvas.Handle, 0, 0, pnlCanvas.ClientWidth, pnlCanvas.ClientHeight);

  BringToFront;
end;

procedure TCanvasForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction = caFree then
  // Executing this - application terminates
  GLCanvasExit;
end;

end.

