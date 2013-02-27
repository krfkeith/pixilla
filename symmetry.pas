{
*   This file is part of the Source code for
*
*   Pixeller
*
*   Copyright (C) 2013  Aleksandar Panic (arekusanda1 [at] gmail.com)
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program.  If not, see <http://www.gnu.org/licenses/>.
}
unit Symmetry;

{$mode objfpc}{$H+}
{$M+}

interface

uses
  Classes, math;

type
  TSymmetry = class(TObject)
  private
    _StepAngle      : Double;
    _MaxAngle       : Double;
    _OneMirrorAngle : Double;
    _Axes           : Integer;
    _StartX         : Integer;
    _StartY         : Integer;
    procedure SetOneMirrorAngle(Value : Double);
    function GetOneMirrorAngle : Double;
    function GetMirrorPointsOneAngle(X, Y : Integer) : TList;
    procedure SetAxes(Value : Integer);
  public
    constructor Create(StartX, StartY, Axes : Integer);
    function GetSymmetryPoints(X, Y : Integer) : TList;
    function GetMirrorPoints(X, Y : Integer; Opposite : Boolean = False) : TList;
    procedure SetCenterPoint(NewStartX, NewStartY : Integer);
    property CenterX : Integer read _StartX;
    property CenterY : Integer read _StartY;
    property Axes : Integer read _Axes write SetAxes;
    property OneMirrorAngle : Double read GetOneMirrorAngle write SetOneMirrorAngle;
  end;

implementation

constructor TSymmetry.Create(StartX, StartY, Axes : Integer);
begin
  _Axes := Axes;
  _StartX := StartX;
  _StartY := StartY;
  _OneMirrorAngle := pi;
  _MaxAngle := 2 * pi;
  _StepAngle := _MaxAngle / Axes;
end;

function TSymmetry.GetSymmetryPoints(X, Y : Integer) : TList;
var
  lst : TList;
  point : PLongint;
  r, o, currentAngle, radianAngle  : Double;
  sX, sY : Integer;
begin

  lst := TList.Create;
  currentAngle := _StepAngle;
  r := sqrt(X * X + Y * Y);
  o := arctan2(Y, X);
  while currentAngle <= _MaxAngle + 1 do
  begin
     radianAngle := o + currentAngle;
     sX := ceil(r * cos(radianAngle)) + _StartX;
     sY := ceil(r * sin(radianAngle)) + _StartY;
     point := AllocMem(SizeOf(Integer) * 2);
     (point)^ := sX;
     (point + 1)^ := sY;
     lst.Add(point);
     currentAngle := currentAngle + _StepAngle;
  end;
  Result := lst;
end;

function TSymmetry.GetMirrorPoints(X, Y : Integer; Opposite : Boolean = False) : TList;
var
   lst : TList;
   point : PLongint;
   r, o, currentAngle, radianAngle  : Double;
   sX, sY : Integer;
begin
  lst := TList.Create;

  if _Axes = 1 then
  begin
    Result := GetMirrorPointsOneAngle(X, Y);
    Exit;
  end;

  currentAngle := _StepAngle;
  r := sqrt(X * X + Y * Y);
  o := arctan2(Y, X);

  while currentAngle <= _MaxAngle + 1 do
  begin
     radianAngle := o + currentAngle;


     if not opposite then
     begin
          sX := ceil(r * cos(radianAngle)) + _StartX;
          sY := ceil(r * sin(radianAngle)) + _StartY;
          point := AllocMem(SizeOf(Integer) * 2);
          (point)^ := sX;
          (point + 1)^ := sY;
          lst.Add(point);
     end;

     sX := ceil(r * cos(2 * currentAngle - radianAngle)) + _StartX;
     sY := ceil(r * sin(2 * currentAngle - radianAngle)) + _StartY;
     point := AllocMem(SizeOf(Integer) * 2);
     (point)^ := sX;
     (point + 1)^ := sY;
     lst.Add(point);

     currentAngle := currentAngle + _StepAngle;
  end;
  Result := lst;
end;

function TSymmetry.GetMirrorPointsOneAngle(X, Y : Integer) : TList;
var
   lst : TList;
   r, o : Double;
   point : PLongint;
   sX, sY : Integer;
begin
     lst := TList.Create;
     point := AllocMem(SizeOf(Integer) * 2);
     (point)^ := X + _StartX;
     (point + 1)^ := Y + _StartY;
     lst.Add(point);

     r := sqrt(X * X + Y * Y);
     o := arctan2(Y, X);

     sX := ceil(r * cos(-o - _OneMirrorAngle)) + _StartX;
     sY := ceil(r * sin(-o - _OneMirrorAngle)) + _StartY;
     point := AllocMem(SizeOf(Integer) * 2);
     (point)^ := sX;
     (point + 1)^ := sY;
      lst.Add(point);

      Result := lst;
end;

procedure TSymmetry.SetAxes(Value : Integer);
begin
   if (Value > 0) and (Value <= 360) then _Axes := Value;
   _StepAngle := _MaxAngle / _Axes;
end;

procedure TSymmetry.SetOneMirrorAngle(Value : Double);
begin
  _OneMirrorAngle := Value * pi / 180;
end;

function TSymmetry.GetOneMirrorAngle : Double;
begin
  Result := _OneMirrorAngle * 180 / pi;
end;

procedure TSymmetry.SetCenterPoint(NewStartX, NewStartY : Integer);
begin
  _StartX := NewStartX;
  _StartY := NewStartY;
end;

end.

