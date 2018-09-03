unit class_mcerrados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;

type
  TMCerrados = class
      a,
      b,
      Error,
      x: real;
      fx: string;
      MetodoType : Integer;
      function Execute: Boolean;

    private
      Parse: TParseMath;
      function f( xx: real): Real;
      procedure Biseccion();
      procedure FPosicion();
    public
      xn,
      en: TStringList;
      constructor create;
      destructor Destroy; override;

  end;

const
   IdBiseccion = 0;
   IdFalsaPosicion = 1;

implementation

function TMCerrados.f( xx: real): Real;
begin
   //Result:= xx*xx - 4;
   Parse.NewValue( 'x', xx);
   Result:= Parse.Evaluate();
end;

function TMCerrados.Execute: Boolean;
begin
   Parse.Expression:= fx;
   xn.Clear;
   en.clear;
   xn.add('');
   en.add('');
   if (f(a)*f(b)>0) then
   begin
      ShowMessage('No cumple bolsano '+floattostr(f(a))+' '+floattostr(f(b)));
      Result := False;
      Exit();
   end

   else if (f(a)*f(b) = 0) then
   begin
        if (f(a) = 0) then
           x := a
        else
           x := b;
        exit();
   end;

   if(MetodoType = IdBiseccion) then
        Biseccion
   else
        FPosicion;
   Result := True;
end;

procedure TMCerrados.Biseccion();
var NewError: Real;
    xnn: Real;
begin
   x:= Infinity;
   repeat
     xnn:= x;
     x:= (a + b) / 2;
     if f(x) * f(a) < 0 then
        b:= x
     else
        a:=x;
     NewError:= abs(  x - xnn) ;
     xn.Add( FloatToStr(x) );
     en.Add( FloatToStr( NewError ) );
   until (NewError <= Error );
   en.Delete( 0 );
   en.Insert(0, '');

end;

procedure TMCerrados.FPosicion();
var NewError: Real;
    xnn: Real;
begin
   x:= Infinity;
   repeat
     xnn:= x;
     x:= a-f(a)*(b-a)/(f(b)-f(a));
     if f(x) * f(a) < 0 then
        b:= x
     else
        a:=x;
     NewError:= abs(  x - xnn) ;
     xn.Add( FloatToStr(x) );
     en.Add( FloatToStr( NewError ) );
   until (NewError <= Error );
   en.Delete( 0 );
   en.Insert(0, '');
end;

constructor TMCerrados.create;
begin
  xn:= TStringList.Create;
  en:= TStringList.Create;

  Parse:= TParseMath.create();
  Parse.AddVariable( 'x', 0);
  Parse.Expression:= 'x';
end;

destructor TMCerrados.Destroy;
begin
  xn.Destroy;
  en.Destroy;
  Parse.destroy;
end;

end.

