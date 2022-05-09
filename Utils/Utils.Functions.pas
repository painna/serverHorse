unit Utils.Functions;

interface

uses
  System.SysUtils, System.Classes, System.Zip, Winapi.ShellAPI;

function DirectoryDownUp(aDirectory : String) : String;
Function GetFiles(Const List : TStrings; Dir : String) : Boolean;
function LoadFileToStr(const FileName: TFileName): AnsiString;
function Zip(Files: TStringList; ArquivoZip: String): boolean;

implementation

function DirectoryDownUp(aDirectory : String) : String;
begin
  Result  := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
             IncludeTrailingPathDelimiter(aDirectory);
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

function LoadFileToStr(const FileName: TFileName): AnsiString;
var
  FileStream : TFileStream;
begin
  FileStream:= TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
   if FileStream.Size>0 then
   begin
    SetLength(Result, FileStream.Size);
    FileStream.Read(Pointer(Result)^, FileStream.Size);
   end;
  finally
   FileStream.Free;
  end;
end;

function DeleteFolder(FolderName: String; LeaveFolder: Boolean): Boolean;
var
r: TshFileOpStruct;
begin
  Result := False;
  if not DirectoryExists(FolderName) then
    Exit;
  if LeaveFolder then
    FolderName := FolderName + '*.*'
  else
    if FolderName[Length(FolderName)] = '\' then
      Delete(FolderName,Length(FolderName), 1);

  FillChar(r, SizeOf(r), 0);
  r.wFunc := FO_DELETE;
  r.pFrom := PChar(FolderName);
  r.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  Result := ((ShFileOperation(r) = 0) and (not r.fAnyOperationsAborted));
end;

Function GetFiles(Const List : TStrings; Dir : String) : Boolean;
  procedure ScanFolder(const Path: String; List: TStrings);
  var
    sPath: string;
    rec : TSearchRec;
  begin
    sPath := IncludeTrailingPathDelimiter(Path);
    if FindFirst(sPath + '*.*', faAnyFile, rec) = 0 then
    begin
      repeat
        if (rec.Attr and faDirectory) <> 0 then
        begin
          if (rec.Name <> '.') and (rec.Name <> '..') then
            ScanFolder(IncludeTrailingPathDelimiter(sPath + rec.Name), List);
        end
        else
        begin
          if pos(Dir, Path) > 0 then
            List.Add(copy(Path, length(Dir) + 1, length(path)) + rec.Name)
          else
            List.Add(Path + rec.Name);
        end;
      until FindNext(rec) <> 0;
      FindClose(rec);
    end;
  end;
Begin
 If Not Assigned(List) Then
  Begin
    Result := False;
    Exit;
  end;
  ScanFolder(Dir, List);
  Result := (List.Count > 0);
End;

function UnZip(ZipName: string; Destino: string): boolean;
var
  lUnZip: TZipFile;
begin
  lUnZip := TZipFile.Create();
  try
    lUnZip.Open(ZipName, zmRead);
    lUnZip.ExtractAll(Destino);
    lUnZip.Close;
  finally
    FreeAndNil(lUnZip);
  end;
  Result := True;
end;

function Zip(Files: TStringList; ArquivoZip: String): boolean;
var
  lZip: TZipFile;
  i: Integer;
  s : String;
begin
  lZip := TZipFile.Create;
  try
//    if FileExists(BancoZipado) then
//      lZip.Open(BancoZipado, zmReadWrite)
//    else
      lZip.Open(ArquivoZip, zmWrite);

    for i := 0 to Files.Count - 1 do
      lZip.Add('C:\Desenvolvimento\Horse\Servidor\Win32\Debug\download\'+Files[i]);

    lZip.Close;
  finally
    lZip.Free;
  end;
end;


end.
