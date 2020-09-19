print macro cadena
  mov ax, @data
  mov ds, ax
  mov ah, 09h
  mov dx, offset cadena
  int 21h
endm

getChar macro
  mov ah, 01h
  int 21h
endm

selectMenu macro option
  getChar
  cmp al,31h  ;Opcion 1) Jugar
  mov option[0], 31h
  je Jugar
  cmp al, 32h ;Opcion 2) Cargar Juego
  mov option[0], 32h
  je CargarJuego
  cmp al, 33h
  mov option[0], 33h
  je Salir
  print salto
  jmp inicio
endm
