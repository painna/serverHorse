unit dao.familiares;

interface

uses Utils.Result,
     Jsons,
     model.familiares,
     System.SysUtils,
     Dm_Principal, FireDAC.Comp.Client;

type

  TDAOFamiliares = class
  private
    FDM       : TDm1;
    FQry      : TFDQuery;
    FFamily   : TModelFamiliares;
    FResult   : TUtilsResult;

  public
    function Delete(aID : Integer) : String;
    function Find(aID : Integer) : String;
    function FindAll(aMasterKey : Integer) : TDAOFamiliares;
    function Post(aJson : String) : String;
    function Put(aID : Integer; aJson : String) : String;

    function This : TModelFamiliares;

    constructor Create;
    destructor Destroy; override;
    class function New : TDAOFamiliares;
  end;

implementation

const cTable     = 'familiares';
      cKey       = 'id';
      cMasterKey = 'idcliente';

{ TDAOFamiliares }

constructor TDAOFamiliares.Create;
begin
  FDm       := TDm1.Create(nil);
  FQry      := TFDQuery.Create(nil);
  FQry.Connection := FDM.Conexao;

  FFamily  := TModelFamiliares.New;
  FResult   := TUtilsResult.New;
  FFamily.Clear;
end;

function TDAOFamiliares.Delete(aID: Integer): String;
begin
  if not FDM.IsExist(cKey, aID.ToString, cTable) then
    Result  := FResult
                .Message('Familiar não cadastrado. Exclusão não permitida')
                .StatusCode(406)
                .ToString
  else
  begin
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
end;

destructor TDAOFamiliares.Destroy;
begin
  FFamily.Free;
  FResult.Free;
  FQry.Free;
  FDm.Free;

  inherited;
end;

function TDAOFamiliares.Find(aID: Integer): String;
begin
  try
    FFamily.Clear;
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add(format('select id, idcliente, nome, parentesco from %s',[cTable]));
    FQry.SQL.Add(format(' where %s = :%s',[cKey, cKey]));
    FQry.Params[0].AsInteger  := aID;
    FQry.Open;
    if not FQry.IsEmpty then
      Result := FResult
                  .Data(FFamily
                          .ID(FQry.FieldByName('id').AsInteger)
                          .IdCliente(FQry.FieldByName('idcliente').AsInteger)
                          .Nome(FQry.FieldByName('nome').AsString)
                          .Parentesco(FQry.FieldByName('parentesco').AsString)
                          .ToJsonObject)
                  .ToString
    else
      Result := FResult
                  .Message('Familiar não cadastrado.')
                  .StatusCode(500)
                  .ToString
  finally
    FQry.Close;
  end;
end;

function TDAOFamiliares.FindAll(aMasterKey : Integer): TDAOFamiliares;
begin
  Result  := Self;
  try
    FFamily.Clear;

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add(format('select id, idcliente, nome, parentesco from %s',[cTable]));
    FQry.SQL.Add(format(' where %s = :%s',[cMasterKey, cMasterKey]));
    FQry.Params[0].AsInteger  := aMasterKey;
    FQry.Open;

    if not FQry.IsEmpty then
    begin
      FQry.First;
      while not FQry.Eof do
      begin
        FFamily.Add(FFamily
                      .ID(FQry.FieldByName('id').AsInteger)
                      .IdCliente(FQry.FieldByName('idcliente').AsInteger)
                      .Nome(FQry.FieldByName('nome').AsString)
                      .Parentesco(FQry.FieldByName('parentesco').AsString)
                      .ToJsonObject
                    );
        FQry.Next;
      end;
    end;
  finally
    FQry.Close;
  end;
end;

class function TDAOFamiliares.New: TDAOFamiliares;
begin
  Result  := Self.Create;
end;

function TDAOFamiliares.Post(aJson: String): String;
var lId : Integer;
begin
  FFamily.ToObject(aJson);
  FDM.Conexao.StartTransaction;
  try
    lId := FDM.getID(cKey, cTable);

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add(format('insert into %s',[cTable]));
    FQry.SQL.Add('(id, idcliente, nome, parentesco)');
    FQry.SQL.Add('values(:id, :idcliente, :nome, :cpfcnpj)');
    FQry.Params[0].AsInteger  := lId;
    FQry.Params[1].AsInteger  := FFamily.IdCliente;
    FQry.Params[2].AsString   := FFamily.Nome;
    FQry.Params[3].AsString   := FFamily.Parentesco;
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

function TDAOFamiliares.Put(aID: Integer; aJson: String): String;
begin
  FFamily.ToObject(aJson);

  if not FDM.IsExist(cKey, aID.ToString, cTable) then
    Result  := FResult
                .Message('Familiar não cadastrado. Alteração não permitida')
                .StatusCode(406)
                .ToString
  else
  begin
    FDM.Conexao.StartTransaction;
    try
      FQry.Close;
      FQry.SQL.Clear;
      FQry.SQL.Add(format('update %s set',[cTable]));
      FQry.SQL.Add(' idcliente=:idcliente, nome=:nome, cpfcnpj=:cpfcnpj');
      FQry.SQL.Add(' where id=:id');
      FQry.Params[0].AsInteger  := FFamily.IdCliente;
      FQry.Params[1].AsString   := FFamily.Nome;
      FQry.Params[2].AsString   := FFamily.Parentesco;
      FQry.Params[3].AsInteger  := aID;
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
end;

function TDAOFamiliares.This: TModelFamiliares;
begin
  Result  := FFamily;
end;

end.
