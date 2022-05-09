program Servidor;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  System.SysUtils,
  System.Classes,
  Utils.Functions in 'Utils\Utils.Functions.pas',
  Dm_Principal in 'Connection\Connection\Dm_Principal.pas' {Dm1: TDataModule},
  model.cliente in 'Model\model.cliente.pas',
  routers.cliente in 'Routers\routers.cliente.pas',
  dao.cliente in 'DAO\dao.cliente.pas',
  Utils.Result in 'Utils\Utils.Result.pas',
  Utils.Consts in 'Utils\Utils.Consts.pas',
  model.usuario in 'Model\model.usuario.pas',
  dao.usuario in 'DAO\dao.usuario.pas',
  routers.usuario in 'Routers\routers.usuario.pas',
  routers.usescfg in 'Routers\routers.usescfg.pas',
  Utils.Token in 'Utils\Utils.Token.pas',
  model.claims in 'Model\model.claims.pas',
  model.familiares in 'Model\model.familiares.pas',
  dao.familiares in 'DAO\dao.familiares.pas',
  connection.firedac in 'Connection\Connection\connection.firedac.pas',
  query.firedac in 'Connection\Query\query.firedac.pas';

procedure onListen(aHorse : THorse);
begin
  WriteLn(Format('Servidor Horse ativo porta : %d  Versao : %s',[aHorse.Port, aHorse.Version]));
  Readln;
end;

begin
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;

  TRoutersUsesCFG.UsesCFG;
  TRoutersUsuario.Routers;
  TRoutersCliente.Routers;

  {$ifdef horse_cgi}
    THorse.Listen;
  {$else}
    THorse.Listen(9095, onListen);
  {$endif}
end.

