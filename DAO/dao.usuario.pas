unit dao.usuario;

interface

uses
  model.usuario,
  Utils.Result,
  System.SysUtils,
  FireDAC.Comp.Client,
  Dm_Principal;

type

  TDAOUsuario = class
  private
    FDM       : TDm1;
    FQry      : TFDQuery;
    FResult   : TUtilsResult;
    FUsuario  : TModelUsuario;
  public
    function Login(aUser, aPassWord : String) : Boolean;
    function Token(aJson : String) : String;

    constructor Create;
    destructor Destroy; override;
    class function New : TDAOUsuario;
  end;

implementation

uses
  Jsons;

const cTable    = 'usuario';
      cUser     = 'user';
      cPassWord = 'password';

{ TDAOUsuario }

constructor TDAOUsuario.Create;
begin
  FDm       := TDm1.Create(nil);
  FQry      := TFDQuery.Create(nil);
  FQry.Connection := FDM.Conexao;

  FResult   := TUtilsResult.New;
  FUsuario  := TModelUsuario.New;
end;

destructor TDAOUsuario.Destroy;
begin
  FUsuario.Free;
  FResult.Free;
  FQry.Free;
  FDm.Free;

  inherited;
end;

function TDAOUsuario.Login(aUser, aPassWord: String): Boolean;
begin
  Result  := False;
  try
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add(format('select id from %s',[cTable]));
    FQry.SQL.Add(format(' where %s = :%s',[cUser, cUser]));
    FQry.SQL.Add(format(' and %s = :%s',[cPassWord, cPassWord]));
    FQry.Params[0].AsString := aUser;
    FQry.Params[1].AsString := aPassWord;
    FQry.Open;
    Result  := FQry.IsEmpty;
  finally
    FQry.Close;
  end;
end;

class function TDAOUsuario.New: TDAOUsuario;
begin
  Result  := Self.Create;
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
        FQry.Close;
        FQry.SQL.Clear;
        FQry.SQL.Add(format('select id, user, email, password, issuer, name, subject from %s',[cTable]));
        FQry.SQL.Add(format(' where %s = :%s',[cUser, cUser]));
        FQry.SQL.Add(format(' and %s = :%s',[cPassWord, cPassWord]));
        FQry.Params[0].AsString := lJson.Values['email'].AsString;
        FQry.Params[1].AsString := lJson.Values['password'].AsString;
        FQry.Open;
        if not FQry.IsEmpty then
          Result  := FUsuario
                      .Email(FQry.FieldByName('email').AsString)
                      .Id(FQry.FieldByName('id').AsString)
                      .Issuer(FQry.FieldByName('issuer').AsString)
                      .Name(FQry.FieldByName('name').AsString)
                      .Subject(FQry.FieldByName('subject').AsString)
                      .Token
        else
          Result  := FResult
                      .Message('Usuario não cadastrado !')
                      .StatusCode(404)
                      .ToString;
      finally
        FQry.Close;
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
