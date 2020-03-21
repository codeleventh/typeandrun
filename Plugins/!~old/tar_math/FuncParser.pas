unit FuncParser;
 {Version 1.02}

{Юнит содержит класс TParsedFunction и описания типов, необходимых для
 работы с ним.

 Класс TParsedFunction (PF) является интерпретатором (парсером) функций.
 Метод ParseFunction позволяет распознать любое математическое выражение,
 содержащее (опционально) x, y, z, различные мат. функции и численные
 константы (см. список ниже), записанное в виде строки. Распознанное выражение
 записывается особым образом в виде 4 массивов переменных. При этом метод
 содержит параметр ErCode, позволяющий определить, успешно ли прошла операция
 распознавания:
   ErCode =
     0 - Операция прошла успешно
     1 - Встречена неизвестная функция или оператор
     2 - В выражении содержится неравное количество открывающихся и
         закрывающихся скобок
     3 - Обнаружен недопустимый символ
         (допустимыми являются: лат буквы любого регистра, цифры, круглые
          скобки, пробел, символы + - * / ^ и точка.)
     4 - Вероятно, пропущен оператор ( ситуация типа 12х )

 Метод Compute позволяет вычислить значение ранее распознанной функции для
 заданных значений x, y и z (если параметр опущен, он считается равным 0).

 Методы ImportParsed и ExportParsed позволяют импортировать/экспортировать
 распознанные функции в види запаси типа TPFRecord.

 Принцип и алгоритм работы парсера:
 Рассмотрим следующее выражение (в качестве примера):

 (5+у)*sin(x^3)+х

 Это выражение можно записать как а1 = а2 + а3,
 где а2 = (5+у)*sin(x^3), а а3 = х.
 В свою очередь, а2 = а4*а5, где а4 = 5+у, а а5 = sin(х^3)...
 И так далее. В конце концов мы получим цепочку простейших операций
 над двумя или одним операндом, каждый из которых может быть либо
 числом/переменной, либо другой парой операндов.
 Цепочка технически записывается тремя массивами: одномерным массивом,
 содержащим указание на операцию (в моем юните каждая операция обозначена
 номером и хранится в типе byte - вряд ли вы придумаете более 255 операций :)
 Я лично вспомнил только 23 :)). Второй массив является двухмерным и
 хранит ссылки на участывующие в операции операнды. Ссылки представляют
 собой номера звеньев цепи и хранятся в типе word.
 Третий массив содержит переменные, числовые константы и числа, обнаруженные
 в выражении. Этот массив связан двумя первыми операций присвоения, которая
 у меня имеет номер 0. В этом случае номер первого операнда ссылается не на
 элемент массива операндов, а на элемент этого тертьего массива.
 Как видите, все просто!
 Чтобы подсчитать значение выражения, необходимо ввести еще один массив
 (у меня обозначен как а). Заметьте, что операнды, участвующие в каждой
 операции, всегда имеют номер больше, чем у этого операнда. Поэтому, чтобы
 вычислить значение самого выражения (т.е. элемента а1), достаточно
 подсчитать значение каждого элемента а, начиная с конца массива.


 Скорость вычисления:
 Благодаря тому, что распознавание функции производится только 1 раз,
 а вся операция вычисления по сути сводится к действиям над массивами,
 удается достичь скорости вычисления, сравнимой со скоростью вычисления
 того же выражения самим компилятором Дельфи.
 Сами скорости вычисления различаются в зависимости от сложности выражения
 (иногда скорость вычислений парсера получается даже выше, чем у компилятора!
  Это вызвано определенной оптимизацие выражения при парсинге), но в среднем
  время вычислений парсера составляет 150-200% времени вычислений компилятора.

  Точность вычислений:
  Информация хранится в типе Single. В большей точности нет смысла, псокольку
  в строке действительные числа передаются с очевидной погрешностью. В любом
  случае, чтобы добиться большей точности, необходимо просто поменять single на
  нужный тип, везде, где он встречается.
  Точность вычислений в среднем составляет е-5

  Формат представления строки:
  - Длина строки ограничена 255 символами
    (ограничение можно снять, заменив shortString на ansiString в
    определении метода)
  - Регистр букв НЕВАЖЕН
  - Разрешается использовать пробелы
  - Десятичная часть должна быть отделена точкой (а не запятой)
  - Выражение должно быть записано по обычным правилам записи мат. выражений
    для компьютера. (Например: x^2 + sin(5*y)/exp(4*z) )
  - Программа учитывает приоритет действий (в порядке убывания: вычисление
    функций, взятие в степень, умножение и деление, сложение и вычитание)
  - Программа учитывает скобки
  - Программа знает следующие мат. операции:
      + : сложение
      - : вычитание
      / : деление
      * : умножение
      ^ : возведение в произвольную степень
  - Программа знает следующие мат. функции:
      sin     - синус
      cos     - косинус
      tan     - тангенс
      cot     - котангенс
      exp     - экспонента
      ln      - нат. логарифм
      sqr     - квадрат
      sqrt    - квадратный корень
      round   - округление
      trunc   - целая часть
      asin    - арксинус
      acos    - арккосинус
      atan    - арктангенс
      acot    - арккотангенс
      sinh    - гип. синус
      cosh    - гип. косинус
      tanh    - гип. тангенс
      coth    - гип. котангенс

  - Программа знает следующие числовые константы:
      pi  - число пи
      e   - число е

  - Программа понимает функции вплоть до 3 переменных.
    Переменные обозначаются буквами x, y, z

  - Программа понимает только числа, представленные в
    десятином виде

   Примечание (емкость массивов)
   Требуемая емкость массива определяется как сумма:
   кол-во операторов(функций) + кол-во вхождений величин + 2.
   Например:  5*sin(x^3)+х
   4 оператора (умножение, синус, сложение, возведение в степень)
   +
   4 вхождения величин (5, 3, х, х)
   +
   2 = 10.
   Автору представляется, что емкости 100 должно хватить для записи
   весьма сложного выражения. В любом случае емкость можно увеличить
   изменением константы Capacity.
   (Изначально в программе использовались динамические массивы,
   но затем от них пришлось отказаться - слишком много геммороя :) )

   !WARNINGS!

  Необходимо самостоятельно контролировать следующие вещи:
  - Обращение к методу Compute для нераспознанной функции вызовет
    ошибку времени исполнения
  - Превышение возможной емкости массивов также, разумеется, вызовет ошибку.
    Подгоните значение Capacity под собственные нужды.
  - Ошибки типа деления на ноль, которые могут быть в выражении, лежат
    полностью на совести пользователя  

   ЛИЦЕНЗИЯ:
   Данный юнит и представленные в нем классы и методы, а также алгоритм
   распознавания функций являются интеллектуальной собственностью
   ЩЕГЛОВА ИЛЬИ АЛЕКСАНДРОВИЧА <franzy@comail.ru>.
   Данные класс, его методы и алгоритм распространяются бесплатно для
   некоммерческого использования. Какое-либо другое распространение
   указанной информации с целью получения выгоды запрещено. Использование
   класса, его методов или алгоритма распознавания в программах,
   распространяемых комерческим путем, возможно только с письменного
   разрешения названного выше владельца авторского права.

   Данная информация должна быть указана в теле любой программы, использующей
   алгоритм распознавания, класс или его методы.

   Благодарности:
   Юрию Лапухову за помощь в обнаружении ошибок в алгоритме

  }

interface

uses
  Math, SysUtils, hob;

const
 Capacity = 100;

type
 TOperation = Array [1..Capacity] of byte;
   //код операции
 TOperand = Array [1..2] of Word;
   //операнды
 TAoTOperand = Array [1..Capacity] of TOperand;
 TAoextended = Array [1..Capacity div 2] of extended;
   //величины

 TPFRecord = Record
   rb: TAoTOperand;
   ro: TOperation;
   rc: TAoextended;
   Blength: word;   //=fi
   Clength: word;   //=ci
 End;
 {needed for import/export}

 TParsedFunction = class (TObject)

  public
    procedure ParseFunction(s: ansiString; var ErCode: byte);
    function Compute(const x: extended = 0;
                     const y: extended = 0;
                     const z: extended = 0): extended;
    procedure ExportParsed(var r: TPFRecord);
    procedure ImportParsed(const r: TPFRecord);

  private
    a: TAoextended ;
    { elementary blocks }
    b: TAoTOperand;
    {numbers of el. blocks, envolved in operation}
    o: TOperation;
    { code of operation }
    c: TAoextended;
    { constants, maybe variables or numbers;
      c[1]=x, c[2]=y, c[3]=z, c[4]=PI, c[5]=e, ....}

    fi         : word; //free index, also length of array b
    ConstIndex : word; //last index for const, starting from 3

  End;   //class


implementation

  procedure TParsedFunction.ImportParsed;
   var i: word;
   begin
      for i:=1 to r.Blength do
       begin
         o[i]:=r.ro[i];
         b[i]:=r.rb[i];
       end;
      for i:=4 to r.Clength do
         c[i]:=r.rc[i];

      ConstIndex:=r.Clength;
      fi:=r.Blength;
   end;

  procedure TParsedFunction.ExportParsed;
   var i: word;
   begin
      for i:=1 to fi do
       begin
				 r.ro[i]:=o[i];
         r.rb[i]:=b[i];
       end;
      for i:=4 to ConstIndex do
         r.rc[i]:=c[i];

      r.Clength:=ConstIndex;
      r.Blength:=fi;

   end;

  Function TParsedFunction.Compute(const x,y,z:extended):extended;
   var i: word;

   begin
     c[1]:=x;
     c[2]:=y;
     c[3]:=z;
     c[4]:=PI;
     c[5]:=exp(1);

     for i:=fi downto 1 do
      case o[i] of
       0 : a[i]:= c[b[i,1]];                  // Assignment
       1 : a[i]:= a[b[i,1]] + a[b[i,2]];      // Summ
       2 : a[i]:= a[b[i,1]] - a[b[i,2]];      // Substract
       3 : a[i]:= a[b[i,1]] * a[b[i,2]];      // Multiplication
       4 : a[i]:= a[b[i,1]] / a[b[i,2]];      // Division
       5 : a[i]:= sqr(a[b[i,1]]);             // ^2
       6 : a[i]:= sqrt(a[b[i,1]]);            // square root
       7 : a[i]:= power(a[b[i,1]],a[b[i,2]]); // Power
       8 : a[i]:= sin(a[b[i,1]]);             // Sin
       9 : a[i]:= cos(a[b[i,1]]);             // Cos
      10 : a[i]:= tan(a[b[i,1]]);             // Tangence
      11 : a[i]:= cot(a[b[i,1]]);             // Cotangence
      12 : a[i]:= exp(a[b[i,1]]);             // exp
      13 : a[i]:= ln(a[b[i,1]]);              // ln
      14 : a[i]:= -a[b[i,1]];                 // unary -
      //RESERVED  for possible future use
      16 : a[i]:= trunc(a[b[i,1]]);           // whole part
      17 : a[i]:= round(a[b[i,1]]);           // round
      18 : a[i]:= arcsin(a[b[i,1]]);          // arcsin
      19 : a[i]:= arccos(a[b[i,1]]);          // arccos
      20 : a[i]:= arctan(a[b[i,1]]);          // arctan
      21 : a[i]:= arccot(a[b[i,1]]);          // arccotan
      22 : a[i]:= sinh(a[b[i,1]]);            // hyp sin
      23 : a[i]:= cosh(a[b[i,1]]);            // hyp cos
      24 : a[i]:= tanh(a[b[i,1]]);            // hyp tan
      25 : a[i]:= coth(a[b[i,1]]);            // hyp cotan
			26 : a[i]:= abs(a[b[i,1]]);             // abs. value
			//27 : a[i]:= hex(a[b[i,1]]);             // abs. value
			//28 : a[i]:= dec(a[b[i,1]]);             // abs. value
			//29 : a[i]:= ocr(a[b[i,1]]);             // abs. value
			//30 : a[i]:= bin(a[b[i,1]]);             // abs. value

     end; //case

     Result:=a[1];
   end;  //proc

    procedure TParsedFunction.ParseFunction;
    const
      letter   : set of Char = ['a'..'z', 'A'..'Z'];
      digit    : set of Char = ['0'..'9'];
      operand  : set of Char = ['-','+','*','/','^'];
      bracket  : set of Char = ['(',')'];
      variable : set of Char = ['x','y','z'];

    var

      i,j : word; //counters
      len : word;
      ls: string;

     function MyPos(const ch: char; const start,fin:word):word;
     {searches ch in s OUTSIDE brackets in given interval}

      var i,br: integer;
      begin
        Result:=0;
        br:= 0;
        For i:=fin downto start do
         begin
          case s[i] of
            '(' : inc(br);
            ')' : dec(br);
          end;
          if (br=0) and (ch=s[i]) then  Result:=i;
         end;

      end;

     procedure ReversePluses(const start,fin:word);
      var i,br: integer;
          ch: char;
      begin
        br:=0;
        for i:=start to fin do
         begin
          case s[i] of
            '(' : inc(br);
            ')' : dec(br);
          end;
          if br=0 then
           begin
            ch:=s[i];
            if s[i]='+' then ch:='-';
            if s[i]='-' then ch:='+';
            s[i]:=ch;
           end;
         end;
      end;

     procedure ReverseDiv(const start,fin:word);
      var i,br: integer;
          ch: char;
      begin
        br:=0;
        for i:=start to fin do
         begin
          case s[i] of
            '(' : inc(br);
            ')' : dec(br);
          end;
          if br=0 then
           begin
            ch:=s[i];
            if s[i]='/' then ch:='*';
            if s[i]='*' then ch:='/';
            s[i]:=ch;
           end;
         end;
      end;

     procedure ParseExpr(start,fin,curfi:word);
     {index of a block is fi}

      var
       cp : word;//cur position
       ss,st: string;
       mynum : extended;
       i,br:word;
       br_ok : boolean;
       Err : integer;

     begin

      repeat

       ss:= Copy(s,start,fin-start+1);   //for debug

       //first get rid of useless enclosing brackets if present
       // like here: (sin(x)/cos(y))

       If (s[start]='(') and (s[fin]=')') then
        begin

          //If we have any operator within brackets at which
          //bracket counter (br) = 0, then we MUST NOT remove brackets
          //If there is none, we CAN do that.

          br_ok:=true; //we CAN remove by default
          br:= 0;
          for i:=start to fin do
            Case s[i] of
              '(' : inc(br);
              ')' : dec(br);
              '+','-','*','^','/' :
                    if br=0 then br_ok:=false;
            end;

          if br_ok then
            begin
              inc(start);
              dec(fin);
              continue;
            end;

        end;


        // seek for +
        cp:= MyPos('+',start,fin);
        If cp>0 then
         begin
           o[curfi]:=1;
           fi:=fi+1;
           b[curfi,1]:=fi;
           ParseExpr(start,cp-1,fi);
           fi:=fi+1;
           b[curfi,2]:=fi;
           ParseExpr(cp+1,fin,fi);
           break;
         end;

        //seek for -
        cp:= MyPos('-',start,fin);
        If cp>0 then
          begin
            If cp>start then
             begin
              o[curfi]:=2;
              fi:=fi+1;
              b[curfi,1]:=fi;
              ParseExpr(start,cp-1,fi);
              fi:=fi+1;
              ReversePluses(cp+1,fin);
              //change + for - and vice versa
              b[curfi,2]:=fi;
              ParseExpr(cp+1,fin,fi);
             end
            else
             begin     //unary -
              o[curfi]:=14;
              fi:=fi+1;
              ReversePluses(1,fin);
              b[curfi,1]:=fi;
              ParseExpr(start+1,fin,fi);
             end;
           break;
          end;

        //seek for *
        cp:= MyPos('*',start,fin);
        if cp>0 then
          begin
            o[curfi]:=3;
            fi:=fi+1;
            b[curfi,1]:=fi;
            ParseExpr(start,cp-1,fi);
            fi:=fi+1;
            b[curfi,2]:=fi;
            ParseExpr(cp+1,fin,fi);
            break;
          end;

        //seek for /
        cp:= MyPos('/',start,fin);
        If cp>0 then
          begin
            o[curfi]:=4;
            fi:=fi+1;
            b[curfi,1]:=fi;
            ParseExpr(start,cp-1,fi);
            fi:=fi+1;
            b[curfi,2]:=fi;
            ReverseDiv(cp+1,fin);
            //change * for / and vice versa
            ParseExpr(cp+1,fin,fi);
            break;
          end;

        //seek for ^;
        cp:= MyPos('^',start,fin);
        if cp>0 then
           begin
             o[curfi]:=7;
             fi:=fi+1;
             b[curfi,1]:=fi;
             ParseExpr(start,cp-1,fi);
             fi:=fi+1;
             b[curfi,2]:=fi;
             ParseExpr(cp+1,fin,fi);
             break;
           end;

        //seek for variables
        If length(ss)=1 then
         case UpCase(s[start]) of
          'X' : begin
                  o[curfi]:=0;
                  b[curfi,1]:=1;
                  break;
                end;
          'Y' : begin
                  o[curfi]:=0;
                  b[curfi,1]:=2;
                  break;
                end;
          'Z' : begin
                  o[curfi]:=0;
                  b[curfi,1]:=3;
                  break;
                end;
         end; //case

        If s[start] in digit then
                begin
                  val(ss,mynum,Err);
                  If Err=0 then
                    begin
                      //ReadNumber(start, mynum);
                      o[curfi]:=0;
                      ConstIndex:=ConstIndex+1;
                      b[curfi,1]:=ConstIndex;
                      c[ConstIndex]:=mynum;
                    end
                  else ErCode:=4;
                  break;
                end;

        //we have either function either special char, e.g. PI
        //check for PI
        if UpperCase(ss)='PI' then
           begin
              o[curfi]:=0;
              b[curfi,1]:=4;
              break;
           end;
        //check for E
        if UpperCase(ss)='E' then
           begin
              o[curfi]:=0;
              b[curfi,1]:=5;
              break;
           end;

        //seek for func, as we have nothing else possible
        //we have a function. Every func must have arg in brackets
        //So, read ss until opening bracket:
        cp:= MyPos('(',start,fin);
        if cp<>0 then
          begin
            st:= Copy(s,start,cp-start);
            st:=UpperCase(st);

            if st='SQR' then
               begin
                 o[curfi]:=5;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='SQRT' then
               begin
                 o[curfi]:=6;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='SIN' then
               begin
                 o[curfi]:=8;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='COS' then
               begin
                 o[curfi]:=9;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='TAN' then
               begin
                 o[curfi]:=10;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='COT' then
               begin
                 o[curfi]:=11;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='EXP' then
               begin
                 o[curfi]:=12;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='LN' then
               begin
                 o[curfi]:=13;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='TRUNC' then
               begin
                 o[curfi]:=16;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='ROUND' then
               begin
                 o[curfi]:=17;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
              end;

            if st='ASIN' then
               begin
                 o[curfi]:=18;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='ACOS' then
               begin
                 o[curfi]:=19;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='ATAN' then
               begin
                 o[curfi]:=20;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='ACOT' then
               begin
                 o[curfi]:=21;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='SINH' then
               begin
                 o[curfi]:=22;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='COSH' then
               begin
                 o[curfi]:=23;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='TANH' then
               begin
                 o[curfi]:=24;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='COTH' then
               begin
                 o[curfi]:=25;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;

            if st='ABS' then
               begin
                 o[curfi]:=26;
                 fi:=fi+1;
                 b[curfi,1]:=fi;
                 ParseExpr(cp, fin,fi);
                 break;
               end;
{            if st='HEX' then
							 begin
								 o[curfi]:=27;
								 fi:=fi+1;
								 b[curfi,1]:=fi;
								 ParseExpr(cp, fin,fi);
								 break;
							 end;
						if st='DEC' then
							 begin
								 o[curfi]:=28;
								 fi:=fi+1;
								 b[curfi,1]:=fi;
								 ParseExpr(cp, fin,fi);
								 break;
							 end;
						if st='OCT' then
							 begin
								 o[curfi]:=29;
								 fi:=fi+1;
								 b[curfi,1]:=fi;
								 ParseExpr(cp, fin,fi);
								 break;
							 end;
						if st='BIN' then
							 begin
								 o[curfi]:=30;
								 fi:=fi+1;
								 b[curfi,1]:=fi;
								 ParseExpr(cp, fin,fi);
								 break;
               end;}

          end;   //if

          if ErCode<>4 then ErCode:=1;

        until ErCode<>0;

       end; //proc

    begin

     len:= length(s);
     fi:= 1;
     ConstIndex:= 5;

     //Check for errors first
     ErCode:=0;
     j:=0;
     for i:=1 to len do
      begin
       if s[i]='(' then inc(j);
       if s[i]=')' then dec(j);
      end;
     if j<>0 then ErCode:=2;

     if ErCode<>2 then
      for i:=1 to len do
       if not ((s[i] in digit) or (s[i] in letter) or (s[i] in operand)
         or (s[i] in [')','(','.',' '])) then ErCode:=3;

     //kill all spaces

    ls:='';
    for i:=1 to len do
        if s[i]<>' ' then ls:=ls + Copy(s,i,1);

    len:=length(ls);

    //a bit of optimization: kill useless unary pluses

    if ls[1]<>'+' then s:=s[1] else s:='';
    for i:=2 to len do
        if (ls[i]<>'+') or (ls[i-1]<>'(') then
           s:=s + Copy(ls,i,1);

    len:=length(s);

    if ErCode=0 then ParseExpr(1,len,1);

    end; //func

end.
