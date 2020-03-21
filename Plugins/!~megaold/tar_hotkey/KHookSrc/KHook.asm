.386
.model flat,stdcall
option casemap:none
include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\kernel32.lib
include C:\masm32\include\user32.inc
includelib C:\masm32\lib\user32.lib

.const
WM_KEYBOARDHOOK equ WM_USER+17
.data
hInstance dd 0

.data?
hHook dd ?
hWnd dd ?

.code
DllEntry proc hInst:HINSTANCE, reason:DWORD, reserved1:DWORD
 push hInst
 pop hInstance
 mov eax,TRUE
 mov hHook,0 ; хук не установлен
 ret
DllEntry Endp

KeyboardProc proc nCode:DWORD,wParam:DWORD,lParam:DWORD
 mov eax,lParam
 shr eax,16
 invoke SendMessage,hWnd,WM_KEYBOARDHOOK,wParam,eax
 .if eax==0
  invoke CallNextHookEx,0,nCode,wParam,lParam 
 .endif
 ret
KeyboardProc endp

InstallHook proc Flag:DWORD,Wnd:DWORD
 .if Flag==0 
  .if hHook==0 ; хук не установлен и не надо
   mov eax,TRUE
   ret
  .else        ; хук установлен, но не надо - снять
   invoke UnhookWindowsHookEx,hHook
   .if eax!=0
    mov hHook,0
   .endif 
   ret
  .endif
 .else 
  .if hHook==0 ; хук не установлен, но нужен - поставить
   push Wnd
   pop hWnd
   invoke SetWindowsHookEx,WH_KEYBOARD,addr KeyboardProc,hInstance,0
   mov hHook,eax
   ret
  .else    ; хук установлен, но нужен другой - модифицировать
   push Wnd
   pop hWnd
   ret
  .endif
 .endif  
InstallHook endp  

End DllEntry