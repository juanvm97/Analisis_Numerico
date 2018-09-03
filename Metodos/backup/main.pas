unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Grids,
  ParseMath, class_mcerrados, class_mabiertos;

type

  { TForm1 }

  TForm1 = class(TForm)
    cboFunctions: TComboBox;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    Chart1LineSeries1: TLineSeries;
    ediA: TEdit;
    ediB: TEdit;
    ediError: TEdit;
    ediF: TEdit;
    ediD: TEdit;
    ediX_0: TEdit;
    Execute: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblIteracionse: TLabel;
    lblRoot: TLabel;
    lblError: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;

    FunctionList: TstringList;
    StringGrid1: TStringGrid;

    procedure Button1Click(Sender: TObject);
    procedure Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure ExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);


  private
    Parse: TParseMath;
    MCerrado: TMCerrados;
    MAbierto: TMAbiertos;
    MetodoType : Integer;
    function f( x: Real): Real;
    procedure Plot(x: Real);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


function TForm1.f( x: Real): Real;
begin
   Parse.NewValue('x', x );
   Result:= Parse.Evaluate();
end;

procedure TForm1.Plot( x: Real );
begin
   Chart1LineSeries1.Clear;
   Chart1FuncSeries1.Active:= True;
   Chart1LineSeries1.ShowLines:= False;
   Chart1LineSeries1.ShowPoints:= True;
   Chart1LineSeries1.AddXY( x, f(x) );
   Chart1LineSeries1.Active:= True;
end;

procedure TForm1.ExecuteClick(Sender: TObject);
var
    i: Integer;
begin
  Parse.Expression:= ediF.Text;

  MetodoType := PtrUint ( cboFunctions.Items.Objects [cboFunctions.ItemIndex] );


  if ( ( MetodoType = IdBiseccion ) or (MEtodoType = IdFalsaPosicion) ) then
  begin
       MCerrado.MetodoType := MetodoType;
       MCerrado.a:= StrToFloat( ediA.Text );
       MCerrado.b:= StrToFloat( ediB.Text );
       MCerrado.fx:= ediF.Text;
       MCerrado.Error:= StrToFloat( ediError.Text );

       if (MCerrado.Execute()) then
       begin
            StringGrid1.RowCount:= MCerrado.xn.Count;
            StringGrid1.Cols[1].Assign( MCerrado.xn );
            StringGrid1.Cols[2].Assign( MCerrado.en );
            Plot(MCerrado.x);
            lblRoot.Caption:= FloatToStr( round( MCerrado.x / MCerrado.Error ) * MCerrado.Error );
            lblIteracionse.Caption:= IntToStr( MCerrado.xn.Count );
       end;
  end

  else
  begin
       MAbierto.MetodoType:= MetodoType;
       MAbierto.fx:= ediF.Text;
       MAbierto.x:= StrToFloat( ediX_0.Text );
       MAbierto.Error:= StrToFloat( ediError.Text );

       if (MetodoType = IdNewton) then
       begin
            MAbierto.dfx:= ediD.Text;
       end;

       if (MAbierto.Execute()) then
       begin
            StringGrid1.RowCount:= MAbierto.xn.Count;
            StringGrid1.Cols[1].Assign( MAbierto.xn );
            StringGrid1.Cols[2].Assign( MAbierto.en );
            Plot(MAbierto.x);
            lblRoot.Caption:= FloatToStr( round( MAbierto.x / MAbierto.Error ) * MAbierto.Error );
            lblIteracionse.Caption:= IntToStr( MAbierto.xn.Count );
       end;
  end;

  for i:= 1 to StringGrid1.RowCount -1 do
     StringGrid1.Cells[ 0, i ]:= IntToStr( i+1 );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parse:= TParseMath.create();
  Parse.AddVariable( 'x', 0);

  MCerrado := TMCerrados.create();
  MAbierto := TMAbiertos.create();

  FunctionList := TstringList.Create;
  FunctionList.AddObject( 'Biseccion', TObject( IdBiseccion) );
  FunctionList.AddObject( 'Falsa Posicion', TObject( IdFalsaPosicion ) );
  FunctionList.AddObject( 'Newton', TObject( IdNewton ) );
  FunctionList.AddObject( 'Secante', TObject( IdSecante ) );

  cboFunctions.Items.Assign( FunctionList );
  cboFunctions.ItemIndex:= 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
  MCerrado.destroy;
  MAbierto.destroy;
end;

procedure TForm1.Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Chart1FuncSeries1.Active:= False;
  Chart1LineSeries1.Active:= False;
end;

end.

