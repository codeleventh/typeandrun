unit PicList;

interface

Uses Classes,IniFiles;

Const MainGroup='Changer';

Type TMyList=class(TStringList) // модифицированный список, хранящий еще дополнительную информацию
       Constructor Create;
      public
       FileName:string;
       Pos:integer;   // номер следующей выборки
       IsWall:boolean; // указывает, что нужно сменить обои рабочего стола
       IsJpeg2Bmp:boolean; // указывает, что при копировании требуется произвести преобразование JPG в BMP (только для обоев)
     end;

var Ini:TIniFile;

Procedure CopyPic(const Name1,Name2:string;Jpg:boolean);

implementation

Uses Windows,SysUtils,Jpeg,Graphics;

Constructor TMyList.Create;
begin
 inherited Create;
 FileName:='';Pos:=-1;
 IsWall:=false;IsJpeg2Bmp:=false;
end;

Procedure CopyPic(const Name1,Name2:string;Jpg:boolean);
var MyJpeg:TJpegImage;
    Bmp:TBitmap;
    X,Y:PChar;
begin
 if Jpg then begin        // алгоритм преобразования JPEG в BMP
  MyJpeg:=TJpegImage.Create;Bmp:=TBitmap.Create;
  MyJpeg.LoadFromFile(Name1);  // Чтение изображения из файла JPEG
  Bmp.Width:=MyJpeg.Width;Bmp.Height:=MyJpeg.Height;
  case MyJpeg.PixelFormat of
   jf24Bit:Bmp.PixelFormat:=pf24bit;
   else Bmp.PixelFormat:=pf8bit;
  end;
  Bmp.Canvas.Draw(0,0,MyJpeg);
  Bmp.SaveToFile(Name2);  // Сохранение на диске изображения в формате BMP
  MyJpeg.Free;
  Bmp.Free;
 end else begin
  GetMem(X,256);GetMem(Y,256);
  CopyFile(StrPCopy(X,Name1),StrPCopy(Y,Name2),false); // в противном случае, простое копирование
  FreeMem(Y,256);FreeMem(X,256);
 end;
end;

end.
