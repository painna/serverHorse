unit model.claims;

interface

uses
  JOSE.Core.JWT;

type

  TModelClaims = class
  private
    FEmail: string;
    FExpiration : TDateTime;
    FId: string;
    FIssuer: String;
    FName: string;
    FSubject: String;
  public
    function Email: string; overload;
    function Expiration : TDateTime; overload;
    function Id: string; overload;
    function Issuer: string; overload;
    function Name: string; overload;
    function Subject: string; overload;

    function Email(aValue : string) : TModelClaims; overload;
    function Expiration(aValue : TDateTime) : TModelClaims; overload;
    function Id(aValue : string) : TModelClaims; overload;
    function Issuer(aValue : string) : TModelClaims; overload;
    function Name(aValue : string) : TModelClaims; overload;
    function Subject(aValue : string) : TModelClaims; overload;

    constructor Create;
    Destructor Destroy; override;
    class function New : TModelClaims;
  end;

implementation

{ TModelClaims }

constructor TModelClaims.Create;
begin

end;

destructor TModelClaims.Destroy;
begin

  inherited;
end;

function TModelClaims.Email(aValue: string): TModelClaims;
begin
  Result  := Self;
  FEmail  := aValue;
end;

function TModelClaims.Expiration(aValue: TDateTime): TModelClaims;
begin
  Result  := Self;
  FExpiration := aValue;
end;

function TModelClaims.Expiration: TDateTime;
begin
  Result  := FExpiration;
end;

function TModelClaims.Email: string;
begin
  Result  := FEmail;
end;

function TModelClaims.Id(aValue: string): TModelClaims;
begin
  Result  := Self;
  FId     := aValue;
end;

function TModelClaims.Issuer(aValue: string): TModelClaims;
begin
  Result  := Self;
  FIssuer := aValue;
end;

function TModelClaims.Issuer: string;
begin
  Result  := FIssuer;
end;

function TModelClaims.Id: string;
begin
  Result  := FId;
end;

function TModelClaims.Name: string;
begin
  Result  := FName;
end;

function TModelClaims.Name(aValue: string): TModelClaims;
begin
  Result  := Self;
  FName   := aValue;
end;

class function TModelClaims.New: TModelClaims;
begin
  Result  := Self.Create;
end;

function TModelClaims.Subject(aValue: string): TModelClaims;
begin
  Result    := Self;
  FSubject  := aValue;
end;

function TModelClaims.Subject: string;
begin
  Result  := FSubject;
end;

end.
