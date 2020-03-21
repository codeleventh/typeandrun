unit hob;
{
Ётот модуль содержит 3 функции, преобразующие
числа в 16-м, 8-м или 2-м виде в дес€теричное
их представление. ¬есь код в цел€х быстродей-
стви€ написан на ассемблере. ѕроверки на кор-
ректность числа на входе нету: предполагаетс€,
что об этом уже позаботились.
—троки должны быть в ASCIIZ формате (т.е.
заканчиватсь€ символом #00.
}
interface
function hex(x:PChar):Longint;
function oct(x:PChar):Longint;
function bin(x:PChar):Longint;

implementation
function hex(x:PChar):Longint; assembler;
asm
  mov esi,eax; // адрес строки
  xor edx,edx; // очистка регистра с результатом
  cld; // просмотр строки "вперед"
  @1:
  lodsb; // загружаем следующий символ в al
  cmp al,0; // обработка конца строки
  jz @2;
  shl edx,4;  // умножить на 16
  cmp al,$40; // обработка букв ('A'..'F')
  jb @3;
  add al,9;
  @3:
  and al,$f; // очистка старшей тетрады
  or dl,al;  // добавим очищенное число к результату
  jmp @1;    // цикл: переходим к обработке след-го символа
  @2:
  mov eax,edx;// результат на выходе
end;

function oct(x:PChar):Longint; assembler;
asm
  mov esi,eax;
  xor edx,edx;
  cld;
  @1:
  lodsb;
  cmp al,0;
  jz @2;
  shl edx,3;
  and al,$f;
  or dl,al;
  jmp @1;
  @2:
  mov eax,edx;
end;

function bin(x:PChar):Longint; assembler;
asm
  mov esi,eax;
  xor edx,edx;
  cld;
  @1:
  lodsb;
  cmp al,0;
  jz @2;
  shl edx,1;
  and al,$f;
  or dl,al;
  jmp @1;
  @2:
  mov eax,edx;
end;

end.
