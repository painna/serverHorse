unit routers.usuario;

interface

uses
  Horse,
  System.SysUtils, dao.usuario;

type

  TRoutersUsuario = class
    class procedure Routers;
  end;

implementation

{ TRoutersCliente }

procedure onAuth(aReq : THorseRequest; aRes : THorseResponse; aNext : TNextProc);
begin
  aRes.ContentType('application/json')
      .Send(TDAOUsuario.New.Token(aReq.Body));
end;

class procedure TRoutersUsuario.Routers;
begin
  THorse
    .Post('/auth',onAuth)
end;

end.
