unit pixillacanvas;

{$mode objfpc}{$H+}

interface

uses
  Windows,
  Forms,
  Classes,
  SysUtils,
  zgl_main,
  zgl_window,
  zgl_screen,
  zgl_timers,
  zgl_primitives_2d,
  zgl_render_target,
  zgl_sprite_2d,
  zgl_textures,
  zgl_utils,
  zgl_types,
  symmetry;

type
  TFPSCallBack = procedure(Str : String);

type
  TPixillaLayer = record
    X : Integer;
    Y : Integer;
    Width : Integer;
    Height : Integer;
    Opacity : Byte;
    Data : zglPTexture;
  end;

procedure GLCanvasInit;
procedure GLCanvasDraw;
procedure GLCanvasUpdate;
procedure GLCanvasExit;
procedure CanvasInit(Handle : HWND; X, Y, Width, Height : Integer);
procedure ResizeCanvas(Width, Height : Integer);
procedure SetFPSCallBack(UserData : TFPSCallBack);
procedure SetVSync(Value : Boolean);

implementation

uses MainForm;

var
  zglInited    : Boolean;
  zglResized   : Boolean;
  CanvasRect   : TRect;
  sGen         : TSymmetry;
  FPSCallBack  : TFPSCallBack;
  layers       : TList;
  workingLayer : zglPRenderTarget;
  oldPoints    : TList;

{
 OpenGL Canvas Initializer
}
procedure GLCanvasInit;
begin
   wnd_SetPos(CanvasRect.Left, CanvasRect.Top );
   wnd_SetSize(CanvasRect.Right, CanvasRect.Bottom);
end;

{
 OpenGL Canvas Drawer
}
procedure GLCanvasDraw;
begin
    if zglResized Then
    begin
      zglResized := FALSE;
      wnd_SetPos(CanvasRect.Left, CanvasRect.Top );
      wnd_SetSize(CanvasRect.Right, CanvasRect.Bottom);
    end;

    pr2d_Rect( 10, 10, 800 - 30, 600 - 30, $FF0000, 255 );
    pr2d_Ellipse( 400, 300, Random(200), Random(200), $FFFFFF, 155, 32, PR2D_FILL );
end;

{
 OpenGL Canvas Updater
}
procedure GLCanvasUpdate;
begin
  FPSCallBack(u_IntToStr(zgl_Get(RENDER_FPS)));

  // Process application messages
  Application.ProcessMessages();
end;

{
  Low-Level Canvas Initializer
}
procedure CanvasInit(Handle : HWND; X, Y, Width, Height : Integer);
begin
    if not zglInited Then
    begin
      zglInited := TRUE;

      CanvasRect := Rect(X, Y, Width, Height);
      sGen := TSymmetry.Create(0, 0, 3);

      layers := TList.Create;
      oldPoints := TList.Create;

      zgl_Reg( SYS_LOAD, @GLCanvasInit);
      zgl_Reg( SYS_DRAW, @GLCanvasDraw);

      zgl_Reg( SYS_UPDATE, @GLCanvasUpdate);

      wnd_ShowCursor(TRUE);

      // Main Canvas Loop
      zgl_InitToHandle(Handle);

      // End application
      Application.Terminate();
    end;
end;

{
  Exits canvas
}
procedure GLCanvasExit;
begin
    if zglInited Then
    begin
      layers.Free;
      oldPoints.Free;
      zglInited := FALSE;
      zgl_Exit();
    end;
end;

{
  Set new size for canvas.
}
procedure ResizeCanvas(Width, Height : Integer);
begin
  CanvasRect.Right := Width;
  CanvasRect.Bottom := Height;
  zglResized := True;
end;

{
  Sets new callback function for FPS returning.
}
procedure SetFPSCallBack(UserData : TFPSCallBack);
begin
  FPSCallBack := UserData;
end;

{
  Vertical Sync decreases CPU load when ON,
  but might slow down things, so this was added as an option.
}
procedure SetVSync(Value: Boolean);
begin
  scr_SetVSync(Value);
end;

end.

