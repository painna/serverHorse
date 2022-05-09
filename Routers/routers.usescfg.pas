unit routers.usescfg;

interface

uses
  Horse,
  Horse.BasicAuthentication,
  Horse.JWT,
  System.SysUtils, Utils.Consts, dao.usuario;

type

  TRoutersUsesCFG = class
    class procedure UsesCFG;
  end;

implementation

{ TRoutersCliente }

function Validation(const AUsername, APassword: string): Boolean;
begin
  Result := TDAOUsuario.New.Login(AUsername, APassword);
end;

class procedure TRoutersUsesCFG.UsesCFG;
begin
  THorse
//  .Use(HorseBasicAuthentication(Validation))
  .Use(HorseJWT(Key_Secret, THorseJWTConfig.New.SkipRoutes(['auth'])));
end;

end.
