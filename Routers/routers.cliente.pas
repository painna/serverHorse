unit routers.cliente;

interface

uses
  Horse,
  dao.cliente,
  System.SysUtils;

type

  TRoutersCliente = class
    class procedure Routers;
  end;

implementation

uses
  Utils.Result;

{ TRoutersCliente }

procedure onFind(aReq : THorseRequest; aRes : THorseResponse; aNext : TNextProc);
begin
  aRes.ContentType('application/json')
      .Send(TDAOCliente.New
                .Find(aReq.Params.Field('id').AsInteger));
end;

procedure onFindAll(aReq : THorseRequest; aRes : THorseResponse; aNext : TNextProc);
var lResult : TUtilsResult;
  lPage : Integer;
  lLimit: Integer;
begin
  lPage   := 0;
  lLimit  := 0;

  if aReq.Query.ContainsKey('page') then
  begin
    lPage   := aReq.Query.Field('page').AsInteger;

    if aReq.Query.ContainsKey('limit') then
      lLimit  := aReq.Query.Field('limit').AsInteger;
  end;

  lResult := TUtilsResult.New;
  try
    lResult.Paging
      .Limit(lLimit)
      .Page(lPage);
    aRes
      .ContentType('application/json')
      .Send(TDAOCliente.New.FindAll(lResult));
  finally
    lResult.Free;
  end;
end;

procedure onPost(aReq : THorseRequest; aRes : THorseResponse; aNext : TNextProc);
begin
  try
    aRes.ContentType('application/json')
        .Send(TDAOCliente.New.Post(aReq.Body));
  except

  end;
end;

procedure onPut(aReq : THorseRequest; aRes : THorseResponse; aNext : TNextProc);
begin
  aRes.ContentType('application/json')
      .Send(TDAOCliente.New.Put(aReq.Params.Field('id').AsInteger, aReq.Body));
end;

procedure onDelete(aReq : THorseRequest; aRes : THorseResponse; aNext : TNextProc);
begin
  aRes.ContentType('application/json')
      .Send(TDAOCliente.New.Delete(aReq.Params.Field('id').AsInteger));
end;

class procedure TRoutersCliente.Routers;
begin
  THorse
    .Group
      .Prefix('clientes')
        .Get('', onFindAll)
        .Get(':id',onFind)
        .Post('', onPost)
        .Put(':id',onPut)
        .Delete(':id',onDelete);
end;

end.
