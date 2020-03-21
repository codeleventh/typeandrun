unit Media;

interface

Uses IniFiles;

Const Language='Language';
      Commands:array[1..12] of string=('~Exe2Swf','~Renumber','~Patch',
      '~PCopy','~M3ufresh','~BookGen','~Id3Copy','~BookGen2','~Txt2htm',
      '~ListGen','~ListGen2','~FileCut');

var Ini:TIniFile;

implementation

Uses Windows,Messages,SysUtils;

function GetNext(var X:string):string;
var I:integer;
begin
 I:=pos(' ',X);
 if I=0 then I:=succ(Length(X));
 Result:=trim(system.copy(X,1,I-1));
 Delete(X,1,I);
end;

end.
