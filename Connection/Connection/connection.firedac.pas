unit connection.firedac;

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL,
  System.Generics.Collections,
  Data.DB;

var
  FDriver: TFDPhysMySQLDriverLink;
  FDTransaction: TFDTransaction;
  FConnList: TObjectList<TFDConnection>;

function Connected: Integer;
procedure Disconnected(aIndex: Integer);

implementation

function Connected: Integer;
begin
  if not Assigned(FConnList) then
    FConnList := TObjectList<TFDConnection>.Create;

  FConnList.Add(TFDConnection.Create(nil));
  Result := Pred(FConnList.Count);

  FConnList.Items[Result].Params.Clear;
  FConnList.Items[Result].Params.DriverID := 'MySQL';
  FConnList.Items[Result].Params.Database := 'horse';
  FConnList.Items[Result].Params.UserName := 'root';
  FConnList.Items[Result].Params.Password := '1234';
  FConnList.Items[Result].Params.Add('Port=3306');
  FConnList.Items[Result].Params.Add('Server=localhost');
  FConnList.Items[Result].Connected := False;
end;

procedure Disconnected(aIndex: Integer);
begin
  FConnList.Items[aIndex].Connected := False;
  FConnList.Items[aIndex].Free;
  FConnList.TrimExcess;

end;

end.
