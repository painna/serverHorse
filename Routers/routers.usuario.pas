unit routers.usuario;

interface

uses
  Horse,
  System.SysUtils,
  dao.usuario,
  connection.firedac;

type

  TRoutersUsuario = class
    class procedure Routers;
  end;

implementation

{ TRoutersCliente }

procedure onAuth(aReq : THorseRequest; aRes : THorseResponse; aNext : TNextProc);
var lCon : Integer;
begin
  try
    lCon  := connection.firedac.Connected;

    aRes.ContentType('application/json')
        .Send(TDAOUsuario.New(lCon).Token(aReq.Body));
  finally
    connection.firedac.Disconnected(lCon);
  end;
end;

class procedure TRoutersUsuario.Routers;
begin
  THorse
    .Post('/auth',onAuth)
end;

end.
