unit TextProc;

interface
Const MaxS=25;
      MaxId=20;
      MaxBuf=2048;

Procedure IDDetect(S1:string);       // разбивает данную строку на лексемы и записывает результат в глобальный IDs
Procedure ContDetect(var F:file);    // читает следующую запись в соответствии с результатом чтения IDDetect
Procedure FormatDetect(var F,F2:file);   // дописывает файл F в файл F2, используя подстановку идентификаторов
Function ValidID:boolean;

var ID:word;                         // количество идентификаторов
    UseClearID:boolean;              // если установлен, то при отсутствии разделителя устанавливает значение пустым, иначе - в полбуфера
    IDs:array[1..MaxId]of record     // полный список идентификаторов со значениями
     Name:string;                    // имя идентификатора
     Cont:string;                    // содержимое идентификатора (длинное!)
     Star:boolean;                   // признак игнорирования
     NonClear:boolean;               // если идентификатор пуст, а флаг установлен, то запись не учитывается
     Trimmer:boolean;
     CaseUp,CaseDown:boolean;        // изменять регист значения идентификатора. Действует CaseDown, если указаны оба
     Wid:integer;                    // ширина неделимого поля (0 для полей произвольной ширины)
     K:word;                         // счетчик числа делителей
     Divs:array[1..Maxs]of string;   // делители
    end;

implementation

Uses SysUtils,Windows;

Procedure IDDetect(S1:string);
var Temp:string[40];                 // текущая читаемая строка (в зависимости от параметров затем будет передана в постоянные переменные)
    I,C:integer;                     // позиция в строке и читаемый символ, заданный кодом
    Mask,Start:boolean;              // признаки маски и зоны служебных символов
    Mode:(SeekID,ReadID,ReadFree,ReadNum,ReadQ);// режим автомата
begin
 FillChar(Ids,sizeof(Ids),0);
 Mode:=SeekID;I:=1;S1:=S1+',';ID:=1; // имитировать последний разделитель - для упрощения процедуры
 while(I<=Length(S1))do begin        // обработать конечным автоматом всю строку
  case Mode of
   SeekID:if S1[I]='%' then begin    // поиск признака начала идентификатора - символа % (процента)
    Mode:=ReadID;Temp:=''; // подготовка к чтению идентификатора
    Start:=true;Mask:=false;
    //FillChar(Ids[Id],sizeof(Ids[Id]),0);
   end;
   ReadID:case upcase(S1[I]) of      // чтение найденного идентификатора
    '%':begin Ids[Id].Name:=Temp;Mode:=ReadFree;Temp:='';end; // найден конец идентификатора
    'A'..'Z':begin // найден первый алфавитный символ
     if Start then begin // проанализировать признак ширину поля
      if(Temp='')then Temp:='0';
      try Ids[Id].Wid:=StrToInt(temp);except Ids[Id].Wid:=0;end;
      Temp:='';Start:=false;
     end;
     Temp:=Temp+upcase(S1[I]); // в любом случае, символ включается в идентификатор
     end;
    '0'..'9':Temp:=Temp+S1[I]; // включение цифры (как ширины поля, так и части идентификатора)
    '*':if Start then Ids[Id].Star:=true; // обработка служебных кодов в начале идентификатора
    '!':if Start then Ids[Id].NonClear:=true;
    '^':if Start then begin Ids[Id].CaseUp:=true;Ids[Id].CaseDown:=false;end;
    '_':if Start then begin Ids[Id].CaseDown:=true;Ids[Id].CaseUp:=false;end;
    '&':if Start then Ids[Id].Trimmer:=true;
   end;
   ReadFree:case S1[I]of // чтение разделителей
    '\':if Mask then begin Temp:=Temp+'\';Mask:=false;end else Mask:=true; // маскировочный признак
    '#':if Mask then begin Temp:=temp+'#';Mask:=false;end else begin Mode:=ReadNum;C:=0;end; // признак ASCII кода
    '''':if Mask then begin Temp:=Temp+'''';Mask:=false;end else Mode:=readQ; // признак прямого ввода строки
    '%':if Mask then begin temp:=Temp+'%';Mask:=false;end else begin // признак начала нового идентификатора
     if(Temp<>'')then begin Inc(Ids[Id].K);Ids[Id].Divs[Ids[Id].K]:=Temp;end;Dec(I);Mode:=SeekID;
     if(Ids[Id].K=0){and(Ids[Id].Wid=0)}then if(ID>1)then begin IDs[Id].Divs:=Ids[Id-1].Divs;IDs[Id].K:=Ids[Id-1].K;end else Dec(Id);
     // использовать для пустого разделителя предыдущий непустой, иначе ликвидировать "плохой" идентификатор
     Inc(Id); // перейти на новый идентификатор
    end;
    ',':if Mask then begin Temp:=Temp+',';Mask:=false;end else begin // признак нового разделителя
     Inc(Ids[Id].K);Ids[Id].Divs[Ids[Id].K]:=Temp;Temp:=''; // добавление текущего разделителя и переход к новому
    end;
    else begin Mask:=false;Temp:=temp+S1[I];end; // все остальные символы особым образом не отмечаются
   end;
   ReadNum:if(S1[I]in['0'..'9'])and(10*C+ord(S1[I])-ord('0')<255)then C:=10*C+ord(S1[I])-ord('0')
    else begin Temp:=Temp+chr(C);Mode:=ReadFree;Dec(I);end; // ввод ASCII кода
   ReadQ:if(S1[I]='''')then Mode:=ReadFree else Temp:=Temp+S1[I]; // прямой ввод строки
  end;
  Inc(I); // переход на следующий символ
 end;
 // строка разбита на лексемы, лексемы включены в массив.
 // С точки зрения использования памяти неоптимальна, но по скорости выполнения - много лучше других алгоритмов.
end;

Procedure ContDetect(var F:file);
var Buf:array[1..MaxBuf]of char;
    I,J,Cur,Last,Len,Stop:integer;
Function APos(S:string):integer;
var I,J:integer;
begin
 if S='' then begin Result:=0;Exit;end;
 // не обрабатывать пустые строки
 J:=0;I:=1;While(I+J<=Len)do begin
  if J=Length(S) then begin Result:=I;Exit;end else   // обнаружен
  if Buf[I+J]=S[J+1] then Inc(J) else // поиск
  begin Inc(I);J:=0;end;  // несовпадение
 end;
 if J<Length(S) then Result:=0 else Result:=I; // не найдено
end;
begin
 For I:=1 to ID do with Ids[I] do begin
  if Wid=0 then begin                                 // поле с кодом ширины -1 - служебное
   Last:=0;BlockRead(F,Buf,MaxBuf,Len);Stop:=0;
   For J:=1 to K do begin                             // поиск ближайшего к началу разделителя для текущего идентификатора
    Cur:=APos(Divs[J]);
    if((Last=0)or(Last>Cur))and(Cur<>0)then begin Last:=Cur;Stop:=Last+Length(Divs[J])-1;end;
   end;
   if Last<>0 then begin                              // хотя бы один разделитель найден в зоне поиска
    SetLength(Cont,Last);
    For J:=1 to Last do Cont[J]:=Buf[J];              // скопировать результат в значение
    Seek(F,FilePos(F)-(Len-Stop));                    // вернуть указатель в файле
    if Star then repeat                               // удалить все разделители после первого, если это необходимо
     BlockRead(F,Buf,MaxBuf,Len);
     For J:=1 to K do if APos(Divs[J])=1 then break;  // поиск разделителя
     if J>K then Seek(F,FilePos(F)-Len)
     else Seek(F,FilePos(F)-(Len-Length(Divs[J])));   // удаление, если разделитель найден
    until J>K;
   end else if EOF(F) then begin
    SetLength(Cont,Len);
    For J:=1 to Len do Cont[J]:=Buf[J];
   end else if UseClearID then begin                  // разделители не найдены - сбой поиска
    Seek(F,FilePos(F)-MaxBuf);                        // вернуться назад
    Cont:='';                                         // сгенерировать пустой идентификатор
   end else begin
    SetLength(Cont,Len div 2);                     // другой вариант: записать как значение полубуфер
    For J:=1 to Len div 2 do Cont[J]:=Buf[J];
    Seek(F,FilePos(F)-Len div 2);
   end;
  end else if Wid>0 then begin
   BlockRead(F,Buf,Wid,Len);                          // чтение поля фиксированной ширины
   if Len<Wid then SetLength(Cont,Len)else SetLength(Cont,Wid);
   For J:=1 to Length(Cont) do Cont[J]:=Buf[J];       // ввод в строку
  end;
  if CaseUp then Cont:=AnsiUpperCase(Cont);           // перевести значение в требуемый регистр, если это необходимо
  if CaseDown then Cont:=AnsiLowerCase(Cont);
  if Trimmer then Cont:=Trim(Cont);
  //FillChar(Buf,sizeof(Buf),0);
 end;
end;

Procedure FormatDetect(var F,F2:file);
var I,Cur,Last,Len,Num:integer;
    Buf:array[1..MaxBuf]of char;
Function APos(S:string):integer; // поиск совпадающей строки, но с использованием
var I,J,ii:integer;
begin
 if S='' then begin Result:=0;Exit;end;
 // не обрабатывать пустые строки
 ii:=2;While(upcase(S[1])<>upcase(S[ii]))and(ii<Length(S))do Inc(ii);Dec(ii);
 // оптимизация поиска по первому символу (проста, но ускоряет поиск)
 J:=0;I:=1;While(I+J<=Len)do begin
  if J=Length(S) then begin Result:=I;Exit;end else   // обнаружен
  if(upcase(Buf[I+J])=upcase(S[J+1]))and(J<Length(S))then Inc(J) else // поиск
  if J>0 then begin Inc(I,ii);J:=0;end else // частичное несовпадение
  Inc(I);                                   // полное несовпадение
 end;
 if J<Length(S) then Result:=0 else Result:=I; // не найдено
end;
begin
 Seek(F,0);
 repeat                                           // цикл по всему входному файлу
  BlockRead(F,Buf,MaxBuf,Len);Num:=0;Last:=0;     // поиск идентификатора
  For I:=1 to Id do with Ids[I] do begin
   Cur:=Apos('%'+Name+'%');
   if((Last=0)or(Last>Cur))and(Cur<>0)then begin Num:=I;Last:=Cur;end;
  end;
  if Num=0 then begin                             // копирование, если не найдено
   BlockWrite(F2,Buf,Len,Cur);if Cur<>Len then break;
  end else begin                                  // замена, если найден идентификатор
   Seek(F,FilePos(F)-Len+Last+Length(Ids[Num].Name)+1);
   BlockWrite(F2,Buf,Last-1,Cur);if Cur<>Last-1 then break;
   BlockWrite(F2,Ids[Num].Cont[1],Length(Ids[Num].Cont),Cur);
   if Cur<>Length(Ids[Num].Cont) then break;
   Len:=MaxBuf;
  end;
 until Len<MaxBuf;
end;

Function ValidID:boolean;
var I:integer;
begin
 Result:=false;
 For I:=1 to Id do with Ids[I] do if NonClear and(Cont='')then Exit;
 Result:=true;
end;

end.
