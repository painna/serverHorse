unit dao.cliente;

interface

uses Utils.Result,
     Jsons,
     model.cliente,
     System.SysUtils,
     Dm_Principal,
     FireDAC.Comp.Client;

type

  TDAOCliente = class
  private
    FQry      : TFDQuery;
    FCliente  : TModelCliente;
    FDM       : TDm1;
    FResult   : TUtilsResult;

  public
    function Delete(aID : Integer) : String;
    function Find(aID : Integer) : String;
    function FindAll(aPaging : TUtilsResult) : String;
    function Post(aJson : String) : String;
    function Put(aID : Integer; aJson : String) : String;

    function This : TModelCliente;

    constructor Create;
    destructor Destroy; override;
    class function New : TDAOCliente;
  end;

implementation

const cTable = 'cliente';
      cKey   = 'id';

{ TDAOCliente }

constructor TDAOCliente.Create;
begin
  FDm       := TDm1.Create(nil);
  FQry      := TFDQuery.Create(nil);
  FQry.Connection := FDM.Conexao;

  FCliente  := TModelCliente.New;
  FCliente.Clear;
  FResult   := TUtilsResult.New;
end;

function TDAOCliente.Delete(aID: Integer): String;
begin
  if not FDM.IsExist(cKey, aID.ToString, cTable) then
  begin
    Result  := FResult
                .Message('Cliente não localizado.')
                .StatusCode(404)
                .ToString;
    Exit;
  end;

  FDM.Conexao.StartTransaction;
  try
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add(Format('delete from %s',[cTable]));
    FQry.SQL.Add(Format(' where %s =:%s',[cKey, cKey]));
    FQry.Params[0].AsInteger  := aID;
    FQry.ExecSQL;

    FDM.Conexao.Commit;

    Result := FResult
                .Message('Deleted')
                .Put('id',aID.ToString)
                .StatusCode(200)
                .ToString;
  except
    on e : exception do
    begin
      FDM.Conexao.Rollback;

      Result  := FResult
                  .Message(e.Message)
                  .StatusCode(500)
                  .ToString;
    end;
  end;
end;

destructor TDAOCliente.Destroy;
begin
  FCliente.Free;
  FResult.Free;
  FDm.Free;
  FQry.Free;

  inherited;
end;

function TDAOCliente.Find(aID: Integer): String;
begin
  if aID <= 0 then
    Result := FResult
                .Message('Cliente não cadastrado.')
                .StatusCode(404)
                .ToString
  else
  begin
    try
      try
        FCliente.Clear;
        FQry.Close;
        FQry.SQL.Clear;
        FQry.SQL.Add(format('select id, nome, cpfcnpj from %s',[cTable]));
        FQry.SQL.Add(format(' where %s = :%s',[cKey, cKey]));
        FQry.Params[0].AsInteger  := aID;
        FQry.Open;
        if not FQry.IsEmpty then
        begin
          FCliente
            .ID(FQry.FieldByName('id').AsInteger)
            .Name(FQry.FieldByName('nome').AsString)
            .CPFCNPJ(FQry.FieldByName('cpfcnpj').AsString)
            .Family
              .FindAll(FQry.FieldByName('id').AsInteger);

          Result := FResult
                      .Put('cliente',FCliente.ToJsonObject)
                      .ToString
        end;
      except
        on e : exception do
          Result  := FResult
                  .Message(e.Message)
                  .StatusCode(500)
                  .ToString;
      end;
    finally
      FQry.Close;
    end;
  end;
end;

function TDAOCliente.FindAll(aPaging : TUtilsResult): String;
var lRecords,
    lLimit,
    lOffSet  : Integer;
begin
  try
    FCliente.Clear;
    lLimit  := aPaging.Paging.Limit;
    lOffSet := aPaging.Paging.OffSet;

    lRecords  := FDM.getRecords(cTable);

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add(format('select id, nome, cpfcnpj from %s',[cTable]));
    FQry.SQL.Add(format('limit %d offset %d',[lLimit, lOffSet]));
    FQry.Open;

    if not FQry.IsEmpty then
    begin
      FQry.First;
      while not FQry.Eof do
      begin
        FCliente
          .ID(FQry.FieldByName('id').AsInteger)
          .Name(FQry.FieldByName('nome').AsString)
          .CPFCNPJ(FQry.FieldByName('cpfcnpj').AsString)
          .Family
            .FindAll(FQry.FieldByName('id').AsInteger);

        FCliente.Add( FCliente.ToJsonObject );
        FQry.Next;
      end;

      Result := FResult
                  .Paging(aPaging
                            .Paging
                              .Records(lRecords)
                            .ToJsonObject
                         )
                  .Put('clientes',FCliente.ToJsonArray)
                  .ToString;

    end
    else
      Result := FResult
                  .Message('Cliente não cadastrado.')
                  .StatusCode(404)
                  .ToString
  finally
    FQry.Close;
  end;
end;

class function TDAOCliente.New: TDAOCliente;
begin
  Result  := Self.Create;
end;

function TDAOCliente.Post(aJson: String): String;
var lId : Integer;
begin
  FCliente.ToObject(aJson);
  FDM.Conexao.StartTransaction;
  try
    lId := FDM.getID(cKey, cTable);

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add(format('insert into %s',[cTable]));
    FQry.SQL.Add('(id, nome, cpfcnpj)');
    FQry.SQL.Add('values(:id, :nome, :cpfcnpj)');
    FQry.Params[0].AsInteger  := lId;
    FQry.Params[1].AsString   := FCliente.Name;
    FQry.Params[2].AsString   := FCliente.CPFCNPJ;
    FQry.ExecSQL;

    FDM.Conexao.Commit;

    Result := FResult
                .Message('Created')
                .Put('id',lId.ToString)
                .StatusCode(201)
                .ToString;
  except
    on e : exception do
    begin
      FDM.Conexao.Rollback;

      Result  := FResult
                  .Message(e.Message)
                  .StatusCode(500)
                  .ToString;
    end;
  end;
end;

function TDAOCliente.Put(aID: Integer; aJson: String): String;
begin
  if not FDM.IsExist(cKey, aID.ToString, cTable) then
  begin
    Result  := FResult
                .Message('Cliente não localizado.')
                .StatusCode(404)
                .ToString;
    Exit;
  end;

  FCliente.ToObject(aJson);
  FDM.Conexao.StartTransaction;
  try
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add(format('update %s set',[cTable]));
    FQry.SQL.Add(' nome=:nome, cpfcnpj=:cpfcnpj');
    FQry.SQL.Add(' where id=:id');
    FQry.Params[0].AsString   := FCliente.Name;
    FQry.Params[1].AsString   := FCliente.CPFCNPJ;
    FQry.Params[2].AsInteger  := aID;
    FQry.ExecSQL;

    FDM.Conexao.Commit;

    Result := FResult
                .Message('Saved')
                .Put('id',aID.ToString)
                .StatusCode(200)
                .ToString;
  except
    on e : exception do
    begin
      FDM.Conexao.Rollback;

      Result  := FResult
                  .Message(e.Message)
                  .StatusCode(500)
                  .ToString;
    end;
  end;
end;

function TDAOCliente.This: TModelCliente;
begin
  Result  := FCliente;
end;

end.
