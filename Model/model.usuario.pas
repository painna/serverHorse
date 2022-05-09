unit model.usuario;

interface

uses JOSE.CORE.Builder, JOSE.CORE.JWT, System.DateUtils, System.SysUtils, 
  Jsons, Utils.Token;

type

  TModelUsuario = class
  private
    FUtils : TUtilsToken;
    FAccessKey : String;
    FEmail : String;
    FId    : String;
    FIssuer: String;
    FName  : String;
    FSenha : String;
    FSubject : String;
    FToken : String;
    FExpirationToken : TDateTime;
  public
    function Email : String; overload;
    function ExpirationToken : TDateTime; overload;
    function Id : String; overload;
    function Issuer : String; overload;
    function Name : String; overload;
    function Senha : String; overload;
    function Subject : String; overload;

    function Email(aValue : String) : TModelUsuario; overload;
    function ExpirationToken(aMinute : Integer) : TModelUsuario; overload;
    function Id(aValue : String) : TModelUsuario; overload;
    function Issuer(aValue : String) : TModelUsuario; overload;
    function Name(aValue : String) : TModelUsuario; overload;
    function Senha(aValue : String) : TModelUsuario; overload;
    function Subject(aValue : String) : TModelUsuario; overload;

    function Token : String;

    constructor Create;
    destructor Destroy; override;
    class function New : TModelUsuario;
  end;

implementation

uses
  Utils.Consts, model.claims;

{ TModelUsuario }

constructor TModelUsuario.Create;
begin
  FUtils := TUtilsToken.New;
end;

destructor TModelUsuario.Destroy;
begin
  FUtils.Free;

  inherited;
end;

function TModelUsuario.Email: String;
begin
  Result  := FEmail;
end;

function TModelUsuario.Email(aValue: String): TModelUsuario;
begin
  Result  := Self;
  FEmail  := aValue;
end;

function TModelUsuario.ExpirationToken: TDateTime;
begin
  Result  := FExpirationToken;
end;

function TModelUsuario.ExpirationToken(aMinute: Integer): TModelUsuario;
begin
  Result  :=  Self;
  FExpirationToken  := IncMinute(Now, aMinute);
end;

function TModelUsuario.Id: String;
begin
  Result  := FId;
end;

function TModelUsuario.Id(aValue: String): TModelUsuario;
begin
  Result  := Self;
  FId     := aValue;
end;

function TModelUsuario.Issuer: String;
begin
  Result  := FIssuer;
end;

function TModelUsuario.Issuer(aValue: String): TModelUsuario;
begin
  Result  := Self;
  FIssuer := aValue;
end;

function TModelUsuario.Name(aValue: String): TModelUsuario;
begin
  Result  := Self;
  FName   := aValue;
end;

function TModelUsuario.Name: String;
begin
  Result  := FName;
end;

class function TModelUsuario.New: TModelUsuario;
begin
  Result  := Self.Create;
end;

function TModelUsuario.Senha: String;
begin
  Result  := FSenha;
end;

function TModelUsuario.Senha(aValue: String): TModelUsuario;
begin
  Result  := Self;
  FSenha  := aValue;
end;

function TModelUsuario.Subject(aValue: String): TModelUsuario;
begin
  Result  := Self;
  FSubject  := aValue;
end;

function TModelUsuario.Subject: String;
begin
  Result  := FSubject;
end;

function TModelUsuario.Token: String;
var lClaims : TModelClaims;
begin
  lClaims := TModelClaims.New;
  try
    lClaims.Email(FEmail);
    lClaims.Id(FId);
    lClaims.Issuer(FIssuer);
    lClaims.Name(FName);
    lClaims.Subject(FSubject);
    Result  := FUtils.NewToken(lClaims).Token;
  finally
    lClaims.Free;
  end;
end;

end.
