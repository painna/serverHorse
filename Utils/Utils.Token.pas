unit Utils.Token;

interface

uses
  JOSE.CORE.Builder,
  JOSE.CORE.JWT,
  System.DateUtils,
  System.SysUtils,
  model.claims,
  Utils.Result;

type

  TUtilsToken = class
  private
    FDateActivated : TDateTime;
    FToken : String;
    FResult   : TUtilsResult;
    FRefresh : String;
    FExpiration : TDateTime;
    FExpirationRefresh : TDateTime;

    procedure NewRefresh(aClaims : TModelClaims);
  public
    function Token : String;
    function NewToken(aClaims : TModelClaims) : TUtilsToken;

    constructor Create;
    destructor Destroy; override;
    class function New : TUtilsToken;
  end;

implementation

uses
  Utils.Consts;

{ TUtilsToken }

constructor TUtilsToken.Create;
begin
  FResult   := TUtilsResult.New;
end;

destructor TUtilsToken.Destroy;
begin
  FResult.Free;

  inherited;
end;

class function TUtilsToken.New: TUtilsToken;
begin
  Result  := Self.Create;
end;

procedure TUtilsToken.NewRefresh(aClaims: TModelClaims);
var lToken : TJWT;
begin
  FExpirationRefresh  := IncMinute(FExpiration, Key_ExpirationRefresh);
  lToken              := TJWT.Create;
  try
    lToken.Claims.Issuer      := aClaims.Issuer;
    lToken.Claims.Subject     := aClaims.Subject;
    lToken.Claims.Expiration  := FExpiration;

    FRefresh  := TJOSE.SHA256CompactToken(Key_Secret, lToken);
  finally
    lToken.Free;
  end;
end;

function TUtilsToken.NewToken(aClaims: TModelClaims) : TUtilsToken;
var lToken : TJWT;
begin
  Result  := Self;
  FDateActivated  := Now;
  FExpiration     := IncMinute(FDateActivated, Key_Expiration);
  lToken          := TJWT.Create;
  try
    lToken.Claims.Issuer      := aClaims.Issuer;
    lToken.Claims.Subject     := aClaims.Subject;
    lToken.Claims.Expiration  := FExpiration;
    lToken.Claims.SetClaimOfType('id', aClaims.Id);
    lToken.Claims.SetClaimOfType('email', aClaims.Email);
    lToken.Claims.SetClaimOfType('name', aClaims.Name);

    FToken  := TJOSE.SHA256CompactToken(Key_Secret, lToken);
  finally
    lToken.Free;
    NewRefresh(aClaims);
  end;
end;

function TUtilsToken.Token: String;
begin
  Result  := FResult
              .Message('Created tokens')
              .StatusCode(200)
              .Token( FToken )
              .Put('refresh_token', FRefresh)
              .Put('date_expiration_token', DateTimeToStr(FExpiration))
              .Put('date_expiration_refresh', DateTimeToStr(FExpirationRefresh))
              .Put('date_activated', DateTimeToStr(FDateActivated))
              .Put('api_host','https://url.com.br/web_api')
              .ToString;
end;

end.
