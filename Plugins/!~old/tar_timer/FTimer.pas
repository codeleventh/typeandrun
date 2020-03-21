unit FTimer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFormTimer = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   protected
    procedure WMPaint(var M:TMessage);message WM_Paint;
    procedure HitTest(var M:TWMNCHitTest);message WM_NCHitTest; // передвижение формы за любое место
   private
    TimerType:byte; // 1 - аналоговый, 2 - цифровой
   public
    Time:integer;   // конечное время
    Procedure SelectType(X:byte);
  end;

implementation

Uses Common;

{$R *.DFM}
Const XHeight=50;
      XWidth=50;

Procedure TFormTimer.SelectType(X:byte);
var hsWindowRegion:Integer;
begin
 TimerType:=X;
 case TimerType of
  Analog:begin
   Width:=XWidth+2*GetSystemMetrics(SM_CXFIXEDFRAME);
   Height:=XHeight+GetSystemMetrics(SM_CYSMCAPTION)+3*GetSystemMetrics(SM_CYFIXEDFRAME);
   hsWindowRegion:=CreateEllipticRgn(GetSystemMetrics(SM_CXFIXEDFRAME),GetSystemMetrics(SM_CYSMCAPTION)+GetSystemMetrics(SM_CYFIXEDFRAME),Width-GetSystemMetrics(SM_CXFIXEDFRAME)+1,Height-2*GetSystemMetrics(SM_CYFIXEDFRAME)+1);
   SetWindowRgn(Handle,hsWindowRegion,true); // сделать окошко круглым
  end;
  Digital:begin
   Width:=130;
   Height:=23+GetSystemMetrics(SM_CYSMCAPTION); // учтем рамку
   hsWindowRegion:=CreateRectRgn(GetSystemMetrics(SM_CXFIXEDFRAME),GetSystemMetrics(SM_CYSMCAPTION)+GetSystemMetrics(SM_CYFIXEDFRAME),Width-GetSystemMetrics(SM_CXFIXEDFRAME)+1,Height-2*GetSystemMetrics(SM_CYFIXEDFRAME)+1);
   SetWindowRgn(Handle,hsWindowRegion,true); // сделать окошко прямоугольным
  end;
 end;
 Left:=GetSystemMetrics(SM_CXSCREEN)-Width; // поместить в правый верхний угол
 Top:=0;
 Show;
end;

Procedure TFormTimer.HitTest(var M:TWMNCHitTest);
begin
 inherited;
 if M.Result=htClient then M.Result:=htCaption;
end;

Procedure TFormTimer.WMPaint(var M:TMessage);
Function X(Old:single):integer;                   // перевод координат
begin Result:=trunc(XWidth/2+XWidth*Old/2);end;
Function Y(Old:single):integer;
begin Result:=trunc(XHeight/2-XHeight*Old/2);end;
var I:integer;
    S:string[20];
begin
 inherited;   // передать Windows, что форма прорисована
 case TimerType of
  Analog:begin // рисуем круглые часики
   Canvas.Pen.Width:=2;
   Canvas.Ellipse(0,0,XWidth,XHeight);   // нарисовать контуры
   I:=(Time-GetTickCount)div 1000;   // вывести часовую стрелку на экран
   Canvas.Pen.Width:=3;
   Canvas.MoveTo(X(0),Y(0));
   Canvas.LineTo(X(0.5*sin(I*pi/21600)),Y(0.5*cos(I*pi/21600)));
   I:=I mod 3600;                    // вывести минутную стрелку
   Canvas.Pen.Width:=2;
   Canvas.MoveTo(X(0),Y(0));
   Canvas.LineTo(X(0.7*sin(I*pi/1800)),Y(0.7*cos(I*pi/1800)));
   I:=I mod 60;                      // вывести секундную стрелку
   Canvas.Pen.Width:=1;
   Canvas.MoveTo(X(0),Y(0));
   Canvas.LineTo(X(0.8*sin(I*pi/30)),Y(0.8*cos(I*pi/30)));
  end;
  Digital:begin // рисуем цифровые часики
   I:=(Time-GetTickCount)div 1000;
   if I<0 then I:=0;
   Canvas.Pen.Width:=2;
   Canvas.Rectangle(0,0,131-2*GetSystemMetrics(SM_CXFIXEDFRAME),19-GetSystemMetrics(SM_CXFIXEDFRAME));
   S:=Time2Str2(I);
   Canvas.Pen.Width:=1;
   Canvas.TextOut((Width-Canvas.TextHeight(S))div 2,1,S);
  end;
 end;
end;

procedure TFormTimer.FormClose(Sender: TObject; var Action: TCloseAction);
begin Action:=caHide;Time:=0;end;

end.
