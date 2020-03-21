unit Id3Obj;

interface

Type TFId3=record   // структура, расположенная в начале файла
      Tag:array[1..3]of char; // must be TAG - symbol, that ID3 present in file
      Title:array[1..30]of char;
      Artist:array[1..30]of char;
      Album:array[1..30]of char;
      Year:array[1..4]of char;
      Comment:array[1..30]of char;
      Genre:byte;
     end;

Type TId3=record // virtual ID3 tag - this is an image of ID3 in memory, not more
      Present:boolean;
      Title,Artist,Album,Year,
      Comment,Genre,FileName:string;
     end;

Procedure Clear(Id3:TId3); // fills up ID3 with zeroes
procedure ReadID3(Name:string;var Id3:TId3); // gets ID3 from file Name
procedure WriteID3(Name:string;const Id3:TId3); // puts ID3 to file Name
procedure RemoveID3(Name:string); // removes ID3 form file Name

implementation

Function Min(I1,I2:integer):integer;
begin if I1<I2 then Result:=I1 else Result:=I2;end;

Procedure Clear(Id3:TId3);
begin
 with Id3 do begin
  Title:='';Artist:='';Album:='';
  Year:='';Comment:='';Genre:='255';
  Present:=false;
 end;
end;

procedure ReadID3(Name:string;var Id3:TId3);
var Id:TFId3;
    I:integer;
    F:file;
begin
 FillChar(Id,sizeof(Id),0);Id3.Present:=false;
 AssignFile(F,Name);{$I-}Reset(F,1);{$I+}
 if IOResult=0 then begin
  Seek(F,FileSize(F)-sizeof(Id));
  BlockRead(F,Id,sizeof(Id),I);
  Id3.Present:=(I=sizeof(Id))and(Id.Tag='TAG');
  CloseFile(F);
 end;
 if Id3.Present then begin
  SetLength(Id3.Title,30);
  For I:=1 to 30 do begin Id3.Title[I]:=Id.Title[I];
   if Id3.Title[I]=#0 then begin SetLength(Id3.Title,I-1);break;end;end;
  SetLength(Id3.Album,30);
  For I:=1 to 30 do begin Id3.Album[I]:=Id.Album[I];
   if Id3.Album[I]=#0 then begin SetLength(Id3.Album,I-1);break;end;end;
  SetLength(Id3.Artist,30);
  For I:=1 to 30 do begin Id3.Artist[I]:=Id.Artist[I];
   if Id3.Artist[I]=#0 then begin SetLength(Id3.Artist,I-1);break;end;end;
  SetLength(Id3.Year,30);
  For I:=1 to 30 do begin Id3.Year[I]:=Id.Year[I];
   if Id3.Year[I]=#0 then begin SetLength(Id3.Year,I-1);break;end;end;
  SetLength(Id3.Comment,30);
  For I:=1 to 30 do begin Id3.Comment[I]:=Id.Comment[I];
   if Id3.Comment[I]=#0 then begin SetLength(Id3.Comment,I-1);break;end;end;
  Str(Id.Genre,Id3.Genre);
  Id3.FileName:=Name;
 end else Clear(Id3);
end;

procedure WriteID3(Name:string;const Id3:TId3);
var Id:TFId3;
    I,E:integer;
    F:file;
begin
 AssignFile(F,Name);{$I-}Reset(F,1);{$I+}
 if IOResult=0 then begin
  Seek(F,FileSize(F)-sizeof(Id));
  BlockRead(F,Id,sizeof(Id),E);
  if E<>sizeof(Id) then Seek(F,FileSize(F)) else // файл не прочитался
  if Id.Tag='TAG' then Seek(F,FileSize(F)-sizeof(Id)) else // перезаписать ID3 тег
  Seek(F,Filesize(F));
  FillChar(Id,sizeof(TFId3),0);
  Id.Tag:='TAG';
  For I:=1 to Length(Id3.Title) do Id.Title[I]:=Id3.Title[I];
  For I:=1 to Length(Id3.Artist) do Id.Artist[I]:=Id3.Artist[I];
  For I:=1 to Length(Id3.Album) do Id.Album[I]:=Id3.Album[I];
  For I:=1 to Min(4,Length(Id3.Year)) do Id.Year[I]:=Id3.Year[I];
  For I:=1 to Length(Id3.Comment) do Id.Comment[I]:=Id3.Comment[I];
  Val(Id3.Genre,I,E);if E<>0 then I:=255;
  Id.Genre:=I;
  BlockWrite(F,Id,sizeof(Id),E);
  CloseFile(F);
 end;
end;

procedure RemoveID3(Name:string);
var Id:TFId3;
    I:integer;
    F:file;
begin
 FillChar(Id,sizeof(Id),0);
 AssignFile(F,Name);{$I-}Reset(F,1);{$I+}
 if IOResult=0 then begin
  Seek(F,FileSize(F)-sizeof(Id));
  BlockRead(F,Id,sizeof(Id),I);
  if(I=sizeof(Id))and(Id.Tag='TAG')then begin
   Seek(F,FileSize(F)-sizeof(Id));
   Truncate(F);
  end;
  CloseFile(F);
 end;
end;

end.
