unit dao.usuario;

interface

uses
  model.usuario,
  Utils.Result,
  System.SysUtils,
  query.firedac,
  connection.firedac;

type

  TDAOUsuario = class
  private
    FQry      : TQueryFiredac;
    FResult   : TUtilsResult;
    FUsuario  : TModelUsuario;
  public
    function Login(aUser, aPassWord : String) : Boolean;
    function Token(aJson : String) : String;

    constructor Create(aCon : Integer);
    destructor Destroy; override;
    class function New(aCon : Integer) : TDAOUsuario;
  end;

implementation

uses
  Jsons;

const cTable    = 'usuario';
      cUser     = 'user';
      cEmail    = 'email';
      cPassWord = 'password';

{ TDAOUsuario }

constructor TDAOUsuario.Create(aCon : Integer);
begin
  FQry      := TQueryFiredac.New(connection.firedac.FConnList.Items[aCon]);
  FResult   := TUtilsResult.New;
  FUsuario  := TModelUsuario.New;
end;

destructor TDAOUsuario.Destroy;
begin
  FUsuario.Free;
  FResult.Free;
  FQry.Free;

  inherited;
end;

function TDAOUsuario.Login(aUser, aPassWord: String): Boolean;
begin
  Result  := False;
  try
    FQry.Qry.Close;
    FQry.Qry.SQL.Clear;
    FQry.Qry.SQL.Add(format('select id from %s',[cTable]));
    FQry.Qry.SQL.Add(format(' where %s = :%s',[cUser, cUser]));
    FQry.Qry.SQL.Add(format(' and %s = :%s',[cPassWord, cPassWord]));
    FQry.Qry.Params[0].AsString := aUser;
    FQry.Qry.Params[1].AsString := aPassWord;
    FQry.Qry.Open;
    Result  := FQry.Qry.IsEmpty;
  finally
    FQry.Qry.Close;
  end;
end;

class function TDAOUsuario.New(aCon : Integer): TDAOUsuario;
begin
  Result  := Self.Create(aCon);
end;

function TDAOUsuario.Token(aJson: String): String;
var lJson : TJsonObject;
begin
  lJson   := TJsonObject.Create();
  try
    if lJson.IsJsonObject(aJson) then
    begin
      lJson.Parse(aJson);

      try
        FQry.Qry.Close;
        FQry.Qry.SQL.Clear;
        FQry.Qry.SQL.Add(format('select id, user, email, password, issuer, name, subject from %s',[cTable]));
        FQry.Qry.SQL.Add(format(' where %s = :%s',[cEmail, cEmail]));
        FQry.Qry.SQL.Add(format(' and %s = :%s',[cPassWord, cPassWord]));
        FQry.Qry.Params[0].AsString := lJson.Values['email'].AsString;
        FQry.Qry.Params[1].AsString := lJson.Values['password'].AsString;
        FQry.Qry.Open;
        if not FQry.Qry.IsEmpty then
          Result  := FUsuario
                      .Email(FQry.Qry.FieldByName('email').AsString)
                      .Id(FQry.Qry.FieldByName('id').AsString)
                      .Issuer(FQry.Qry.FieldByName('issuer').AsString)
                      .Name(FQry.Qry.FieldByName('name').AsString)
                      .Subject(FQry.Qry.FieldByName('subject').AsString)
                      .Token
        else
          Result  := FResult
                      .Message('Usuario não cadastrado !')
                      .StatusCode(404)
                      .ToString;
      finally
        FQry.Qry.Close;
      end;

    end
    else
      Result  := FResult
                  .Message('JSON Invalid!')
                  .StatusCode(500)
                  .ToString;
  finally
    lJson.Free;
  end;
end;

end.
