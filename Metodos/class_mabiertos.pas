unit class_mabiertos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;

type
  TMAbiertos = class
      Error,
      x: real;
      fx: string;
      dfx: string;
      MetodoType : Integer;
      function Execute: Boolean;

    private
      ParseF: TParseMath;
      ParseDf: TParseMath;
      function f( xx: real): Real;
      function Df( xx: real): Real;
      procedure Newton();
      procedure Secante();
    public
      xn,
      en: TStringList;
      constructor create;
      destructor Destroy; override;

  end;

const
   IdNewton = 2;
   IdSecante = 3;
   Top = 100000;

implementation

function TMAbiertos.f( xx: real): Real;
begin
   //Result:= xx*xx - 4;
   ParseF.NewValue( 'x', xx);
   Result:= ParseF.Evaluate();
end;

function TMAbiertos.Df( xx: real): Real;
begin
   //Result:= xx*xx - 4;
   ParseDf.NewValue( 'x', xx);
   Result:= ParseDf.Evaluate();
end;

function TMAbiertos.Execute: Boolean;
begin
   ParseF.Expression:= fx;
   xn.Clear;
   en.clear;
   xn.add('');
   en.add('');
   if(MetodoType = IdNewton) then
   begin
        ParseDf.Expression:= dfx;
        Newton;
   end
   else
        Secante;
   Result := True;

   Result := True;
end;

procedure TMAbiertos.Newton();
var NewError: Real;
    xnn: Real;
begin
   xn.Add( FloatToStr(x) );
   en.Add( '' );

   repeat
     xnn:= x;
     x:= xnn-f(xnn)/Df(xnn);

     NewError:= abs(  x - xnn) ;
     xn.Add( FloatToStr(x) );
     en.Add( FloatToStr( NewError ) );
   until (NewError <= Error );
end;

procedure TMAbiertos.Secante();
var NewError: Real;
    xnn: Real;
    h: Real;
begin
   xn.Add( FloatToStr(x) );
   en.Add( '' );
   h:= Error/10;

   repeat
     xnn:= x;
     x:= xnn-2*h*f(xnn)/(f(xnn+h)-f(xnn-h));

     NewError:= abs(  x - xnn) ;
     xn.Add( FloatToStr(x) );
     en.Add( FloatToStr( NewError ) );
   until (NewError <= Error );
end;

constructor TMAbiertos.create;
begin
  xn:= TStringList.Create;
  en:= TStringList.Create;

  ParseF:= TParseMath.create();
  ParseF.AddVariable( 'x', 0);
  ParseF.Expression:= 'x';
  ParseDf:= TParseMath.create();
  ParseDf.AddVariable( 'x', 0);
  ParseDf.Expression:= 'x';
end;

destructor TMAbiertos.Destroy;
begin
  xn.Destroy;
  en.Destroy;
  ParseF.destroy;
  ParseDf.destroy;
end;

end.

