unit model.familiares;

interface

uses
  Jsons, System.SysUtils, System.Classes;

type

  TModelFamiliares = class
  private
    FJson     : TJsonObject;
    FArray    : TJsonArray;

    FId : Integer;
    FIdCliente : Integer;
    FNome : String;
    FParentesco : String;
  public
    function Id : Integer; overload;
    function IdCliente : Integer; overload;
    function Nome : String; overload;
    function Parentesco : String; overload;

    function Id(aValue : Integer) : TModelFamiliares; overload;
    function IdCliente(aValue : Integer) : TModelFamiliares; overload;
    function Nome(aValue : String) : TModelFamiliares; overload;
    function Parentesco(aValue : String) : TModelFamiliares; overload;

    procedure Add(aJson : TJsonObject);

    function ToJsonArray : TJsonArray;
    function ToJsonObject : TJsonObject;
    function ToObject(aJson : String) : TModelFamiliares;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
    class function New : TModelFamiliares;
  end;

implementation

{ TModelFamiliares }

procedure TModelFamiliares.Add(aJson: TJsonObject);
begin
  FArray.Put(aJson);
end;

procedure TModelFamiliares.Clear;
begin
  FArray.Clear;
end;

constructor TModelFamiliares.Create;
begin
  FArray  := TJsonArray.Create();
  FJson   := TJsonObject.Create();
end;

destructor TModelFamiliares.Destroy;
begin
  FJson.Free;
  FArray.Free;

  inherited;
end;

function TModelFamiliares.Id: Integer;
begin
  Result  := FId;
end;

function TModelFamiliares.Id(aValue: Integer): TModelFamiliares;
begin
  Result  := Self;
  FId     := aValue;
end;

function TModelFamiliares.IdCliente: Integer;
begin
  Result  := FIdCliente;
end;

function TModelFamiliares.IdCliente(aValue: Integer): TModelFamiliares;
begin
  Result  := Self;
  FIdCliente  := aValue;
end;

class function TModelFamiliares.New : TModelFamiliares;
begin
  Result  := Self.Create;
end;

function TModelFamiliares.Nome: String;
begin
  Result  := FNome;
end;

function TModelFamiliares.Nome(aValue: String): TModelFamiliares;
begin
  Result  := Self;
  FNome   := aValue;
end;

function TModelFamiliares.Parentesco(aValue: String): TModelFamiliares;
begin
  Result  := Self;
  FParentesco := aValue;
end;

function TModelFamiliares.Parentesco: String;
begin
  Result  := FParentesco;
end;

function TModelFamiliares.ToJsonArray: TJsonArray;
begin
  Result  := FArray;
end;

function TModelFamiliares.ToJsonObject: TJsonObject;
begin
  FJson.Clear;
  FJson.Put('id',FID);
  FJson.Put('idcliente',FIdCliente);
  FJson.Put('name',FNome);
  FJson.Put('parentesco',FParentesco);

  Result  := FJson;
end;

function TModelFamiliares.ToObject(aJson: String): TModelFamiliares;
var lJson : TJsonObject;
begin
  Result  := Self;
  lJson := TJsonObject.Create();
  try
    if not lJson.IsJsonObject(aJson) then
      raise Exception.Create('JSON mal formatado')
    else
    begin
      try
        lJson.Parse(aJson);
        Self
          .Id(lJson.Values['id'].AsInteger)
          .IdCliente(lJson.Values['idcliente'].AsInteger)
          .Nome(lJson.Values['name'].AsString)
          .Parentesco(lJson.Values['name'].AsString);
      except
        on e : exception do
        begin
          raise Exception.Create(e.Message);
        end;
      end;
    end;
  finally
    lJson.Free;
  end;
end;

end.
