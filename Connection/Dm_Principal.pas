unit Dm_Principal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI, FireDAC.ConsoleUI.Wait;

type
  TDm1 = class(TDataModule)
    Conexao: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function getID(aKey, aTable : String) : Integer;
    function getRecords(aTable : String) : Integer;
    function IsExist(aKey, aField, aTable : String) : Boolean;
  end;

var
  Dm1: TDm1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDm1 }

procedure TDm1.DataModuleCreate(Sender: TObject);
begin
  Conexao.Params.Clear;
  Conexao.Params.DriverID := 'MySQL';
  Conexao.Params.Database := 'horse';
  Conexao.Params.UserName := 'root';
  Conexao.Params.Password := '1234';
  Conexao.Params.Add('Port=3306');
  Conexao.Params.Add('Server=localhost');
end;

function TDm1.getID(aKey, aTable: String): Integer;
  var lQry : TFDQuery;
begin
  Result := 0;
  lQry            := TFDQuery.Create(nil);
  lQry.Connection := Conexao;
  try
    try
      lQry.SQL.Clear;
      lQry.SQL.Add(Format('select coalesce(max( %s ),0) as id from %s',[aKey, aTable]));
      lQry.SQL.Add(' for update');
      lQry.Open;
      Result  := lQry.Fields[0].AsInteger + 1;
    except
      Result := 0;
      raise Exception.Create('Falha ao gerar Codigo identificador !');
    end;
  finally
    lQry.Close;
    lQry.Free;
    if Result <= 0 then
      raise Exception.Create('Falha ao gerar Codigo identificador !');
  end;
end;

function TDm1.getRecords(aTable: String): Integer;
  var lQry : TFDQuery;
begin
  Result := 0;
  lQry            := TFDQuery.Create(nil);
  lQry.Connection := Conexao;
  try
    try
      lQry.SQL.Clear;
      lQry.SQL.Add(Format('select coalesce(count( 1 ),0) as id from %s',[aTable]));
      lQry.Open;
      Result  := lQry.Fields[0].AsInteger;
    except
      Result := 0;
      raise Exception.Create('Falha ao verificar Records !');
    end;
  finally
    lQry.Close;
    lQry.Free;
    if Result <= 0 then
      raise Exception.Create('Falha ao verificar Records !');
  end;
end;

function TDm1.IsExist(aKey, aField, aTable: String): Boolean;
var lQry : TFDQuery;
begin
  Result  := False;
  lQry := TFDQuery.Create(nil);
  lQry.Connection := conexao;
  try
    try
      lQry.Close;
      lQry.SQL.Clear;
      lQry.SQL.Add( Format('select %s from %s', [aKey, aTable]) );
      lQry.SQL.Add( Format(' where %s = :%s ', [aKey, aKey]) );
      lQry.Params[0].AsString := aField;
      lQry.Open;
      Result  := not lQry.IsEmpty;
    except
      Result  := False;
    end;
  finally
    lQry.Active := False;
    lQry.Free;
  end;
end;

end.
