unit Utils.Result;

interface

uses
  Jsons, System.SysUtils, Utils.Consts, System.StrUtils, System.Math;

type

  TPaging = class
  private
    FJson     : TJsonObject;
    FRecords,
    FPage,
    FOffSet,
    FLimit,
    FMaxLimit : Integer;
  public
    function Limit(aValue : Integer) : TPaging; overload;
    function Limit : Integer; overload;
    function MaxLimit : Integer; overload;
    function OffSet : Integer; overload;
    function Page(aValue : Integer) : TPaging; overload;
    function Page : Integer; overload;
    function Records(aValue : Integer) : TPaging; overload;
    function Records : Integer; overload;

    function ToJsonObject: TJsonObject; reintroduce;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
    class function New : TPaging;
  end;


  TUtilsResult = class
  private
    FJson   : TJsonObject;
    FPaging : TPaging;
  public
    function AsJsonObject: TJsonObject;
    function Data(aValue: TJsonArray): TUtilsResult; overload;
    function Data(aValue: TJsonObject): TUtilsResult; overload;
    function Message(aValue: String): TUtilsResult;
    function Paging : TPaging; overload;
    function Paging(aPaging : TJsonObject): TUtilsResult; overload;
    function Put(aKey : String; aValue: TJsonArray): TUtilsResult; overload;
    function Put(aKey : String; aValue: TJsonObject): TUtilsResult; overload;
    function Put(aKey : String; aValue: String): TUtilsResult; overload;
    function StatusCode(aValue: Integer): TUtilsResult;
    function Token(aValue: String): TUtilsResult; overload;
    function ToString: String; reintroduce;

    constructor Create;
    destructor Destroy; override;
    class function New : TUtilsResult;
  end;

implementation

{ TUtilsResult }

function TUtilsResult.AsJsonObject: TJsonObject;
begin
  Result  := FJson;
end;

constructor TUtilsResult.Create;
begin
  FJson   := TJsonObject.Create();
  FPaging := TPaging.New;
end;

function TUtilsResult.Data(aValue: TJsonObject): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(Key_Data) > -1 then
    FJson.Delete(Key_Data);

  FJson.Put(Key_Data, aValue);
end;

function TUtilsResult.Data(aValue: TJsonArray): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(Key_Data) > -1 then
    FJson.Delete(Key_Data);

  FJson.Put(Key_Data, aValue);
end;

destructor TUtilsResult.Destroy;
begin
  FJson.Free;
  FPaging.Free;

  inherited;
end;

function TUtilsResult.Message(aValue: String): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(Key_Message) > -1 then
    FJson.Delete(Key_Message);

  FJson.Put(Key_Message, aValue);
end;

class function TUtilsResult.New: TUtilsResult;
begin
  Result  := Self.Create;
end;

function TUtilsResult.Paging(aPaging: TJsonObject): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(Key_Paging) > -1 then
    FJson.Delete(Key_Paging);

  FJson.Put(Key_Paging, aPaging);

end;

function TUtilsResult.Paging: TPaging;
begin
  Result  := FPaging;
end;

function TUtilsResult.Put(aKey: String; aValue: TJsonObject): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(LowerCase(aKey)) > -1 then
    FJson.Delete(LowerCase(aKey));

  FJson.Put(LowerCase(aKey), aValue);
end;

function TUtilsResult.Put(aKey: String; aValue: TJsonArray): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(LowerCase(aKey)) > -1 then
    FJson.Delete(LowerCase(aKey));

  FJson.Put(LowerCase(aKey), aValue);
end;

function TUtilsResult.Put(aKey, aValue: String): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(LowerCase(aKey)) > -1 then
    FJson.Delete(LowerCase(aKey));

  FJson.Put(LowerCase(aKey), aValue);
end;

function TUtilsResult.StatusCode(aValue: Integer): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(Key_StatusCode) > -1 then
    FJson.Delete(Key_StatusCode);

  FJson.Put(Key_StatusCode, aValue);
end;

function TUtilsResult.Token(aValue: String): TUtilsResult;
begin
  Result  := Self;

  if FJson.Find(Key_Token) > -1 then
    FJson.Delete(Key_Token);

  if Trim(aValue) <> '' then
    FJson.Put(Key_Token, aValue);
end;

function TUtilsResult.ToString: String;
begin
  Result := FJson.Stringify;
end;


{ TPaging }

procedure TPaging.Clear;
begin
  FRecords  := 0;
  FPage     := 0;
  FOffSet   := 0;
  FLimit    := 0;
  FMaxLimit := Key_MaxLimit;
end;

constructor TPaging.Create;
begin
  FJson := TJsonObject.Create();
  Self.Clear;
end;

destructor TPaging.Destroy;
begin
  FJson.Free;

  inherited;
end;

function TPaging.Limit(aValue: Integer): TPaging;
var lLimit : Integer;
begin
  Result  := Self;
  lLimit  := aValue;
  if ( aValue > Key_MaxLimit ) or ( aValue <= 0 ) then
    lLimit  := Key_MaxLimit;

  FLimit  := lLimit;
end;

function TPaging.Limit: Integer;
begin
  Result  := FLimit;
end;

function TPaging.MaxLimit: Integer;
begin
  Result  := Key_MaxLimit;
end;

class function TPaging.New: TPaging;
begin
  Result  := Self.Create;
end;

function TPaging.OffSet: Integer;
begin
  FOffSet := (FLimit * (FPage - 1));
  Result  := FOffSet;
end;

function TPaging.Page(aValue: Integer): TPaging;
begin
  Result  := Self;
  FPage   := System.Math.IfThen(aValue <= 0, 1, aValue);
end;

function TPaging.Page: Integer;
begin
  Result  := FPage;
end;

function TPaging.Records(aValue: Integer): TPaging;
begin
  Result  := Self;
  FRecords  := aValue;
end;

function TPaging.Records: Integer;
begin
  Result  := FRecords;
end;

function TPaging.ToJsonObject: TJsonObject;
begin
  FJson.Clear;
  FJson.Put('records',FRecords);
  FJson.Put('page',FPage);
  FJson.Put('offset',FOffSet);
  FJson.Put('limit',FLimit);
  FJson.Put('maxlimit',FMaxLimit);
  Result  := FJson;
end;

end.
