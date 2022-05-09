unit query.firedac;

interface

uses
  FireDAC.Comp.Client;

type

  TQueryFiredac = class
  private
    FQry : TFDQuery;
  public
    function Qry : TFDQuery;
    constructor Create(aConnection : TFDConnection);
    destructor Destroy; override;
    class function New(aConnection : TFDConnection) : TQueryFiredac;
  end;

implementation

{ TQueryFiredac }

constructor TQueryFiredac.Create(aConnection: TFDConnection);
begin
  FQry  := TFDQuery.Create(nil);
  FQry.Connection := aConnection;
end;

destructor TQueryFiredac.Destroy;
begin
  FQry.Free;

  inherited;
end;

class function TQueryFiredac.New(aConnection: TFDConnection): TQueryFiredac;
begin
  Result  := Self.Create(aConnection);
end;

function TQueryFiredac.Qry: TFDQuery;
begin
  Result  := FQry;
end;

end.
