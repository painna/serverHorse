unit model.cliente;

interface

uses
  Jsons, System.SysUtils, dao.familiares;

type

  TModelCliente = class
  private
    FJson     : TJsonObject;
    FArray    : TJsonArray;
    FFamily   : TDAOFamiliares;

    FCPFCNPJ  : String;
    FID       : Integer;
    FName     : String;
  public
    function CPFCNPJ : String; overload;
    function ID : Integer; overload;
    function Name : String; overload;

    function CPFCNPJ(aValue : String) : TModelCliente; overload;
    function ID(aValue : Integer) : TModelCliente; overload;
    function Name(aValue : String) : TModelCliente; overload;

    function Family : TDAOFamiliares;

    function ToJsonArray : TJsonArray;
    function ToJsonObject : TJsonObject;
    function ToJsonString : String;
    function ToObject(aJson : String) : TModelCliente;

    procedure Add(aJson : TJsonObject);
    procedure Clear;

    constructor Create;
    destructor Destroy; override;
    class function New : TModelCliente;
  end;

implementation

{ TModelCliente }

function TModelCliente.CPFCNPJ: String;
begin
  Result  := FCPFCNPJ;
end;

procedure TModelCliente.Add(aJson: TJsonObject);
begin
  FArray.Put(aJson);
end;

procedure TModelCliente.Clear;
begin
  FArray.Clear;
end;

function TModelCliente.CPFCNPJ(aValue: String): TModelCliente;
begin
  Result  := Self;
  if aValue.Trim.IsEmpty then
    raise Exception.Create('CPF/CNPJ invalid !');
  FCPFCNPJ:= aValue;
end;

constructor TModelCliente.Create;
begin
  FArray  := TJsonArray.Create();
  FFamily := TDAOFamiliares.New;
  FJson   := TJsonObject.Create();
  FFamily := TDAOFamiliares.New;
end;

destructor TModelCliente.Destroy;
begin
  FJson.Free;
  FArray.Free;
  FFamily.Free;

  inherited;
end;

function TModelCliente.Family: TDAOFamiliares;
begin
  if not Assigned(FFamily) then
    FFamily := TDAOFamiliares.New;

  Result  := FFamily;
end;

function TModelCliente.ID: Integer;
begin
  Result  := FID;
end;

function TModelCliente.ID(aValue: Integer): TModelCliente;
begin
  Result  := Self;
  FID     := aValue;
end;

function TModelCliente.Name: String;
begin
  Result  := FName;
end;

function TModelCliente.Name(aValue: String): TModelCliente;
begin
  Result  := Self;
  if aValue.Trim.IsEmpty then
    raise Exception.Create('Nome do cliente não informado !');
  FName   := aValue;
end;

class function TModelCliente.New: TModelCliente;
begin
  Result  := Self.Create;
end;

function TModelCliente.ToJsonArray: TJsonArray;
begin
  Result  := FArray;
end;

function TModelCliente.ToJsonObject: TJsonObject;
begin
  FJson.Clear;
  FJson.Put('id',FID);
  FJson.Put('name',FName);
  FJson.Put('cpfcnpj',FCPFCNPJ);
  FJson.Put('familiares',FFamily.This.ToJsonArray);

  Result  := FJson;
end;

function TModelCliente.ToJsonString: String;
begin
  Result  := Self.ToJsonObject.Stringify;
end;

function TModelCliente.ToObject(aJson: String): TModelCliente;
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
          .CPFCNPJ(lJson.Values['cpfcnpj'].AsString)
          .ID(lJson.Values['id'].AsInteger)
          .Name(lJson.Values['name'].AsString)
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
