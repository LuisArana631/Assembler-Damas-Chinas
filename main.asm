include macros.asm

crearFile macro ruta, handle
    mov ah, 3ch
    mov cx, 00h
    lea dx, ruta
    int 21h
    jc errorCrear
    mov handle, ax
endm

crearTablero macro
  print separador
  print salto
  imprimirTablero fila8, fb, fn, ren, reb, f8, vacio
  print separador
  print salto
  imprimirTablero fila7, fb, fn, ren, reb, f7, vacio
  print separador
  print salto
  imprimirTablero fila6, fb, fn, ren, reb, f6, vacio
  print separador
  print salto
  imprimirTablero fila5, fb, fn, ren, reb, f5, vacio
  print separador
  print salto
  imprimirTablero fila4, fb, fn, ren, reb, f4, vacio
  print separador
  print salto
  imprimirTablero fila3, fb, fn, ren, reb, f3, vacio
  print separador
  print salto
  imprimirTablero fila2, fb, fn, ren, reb, f2, vacio
  print separador
  print salto
  imprimirTablero fila1, fb, fn, ren, reb, f1, vacio
  print separador
  print cols
  print salto
  print salto
endm

iniciarJuego macro
  iniciargame:
  mov puntosB, 0
  mov puntosN, 0
  clear_screen
  print key_start
  print salto
  crearTablero
  getChar

  turno_blanco:
  limpiarBuffer str_instr, SIZEOF str_instr, 24h
  clear_screen
  print turnoB
  get_text_kb str_instr
  validar_mov str_instr, fb
  crearTablero
  getChar

  turno_negra:
  limpiarBuffer str_instr, SIZEOF str_instr, 24h
  clear_screen
  print turnoN
  get_text_kb str_instr
  validar_mov str_instr, fn
  crearTablero
  getChar

  jmp turno_blanco
endm

cargarJuego macro
  clear_screen
  limpiarBuffer bufferLectura, SIZEOF bufferLectura, 24h
  print pathFile
  get_text_kb bufferLectura
  print bufferLectura
  abrirF bufferLectura, handleAux
  loop_read:
  limpiarBuffer bufferAuxiliar, SIZEOF bufferAuxiliar, 24h
  leerF SIZEOF bufferAuxiliar, bufferAuxiliar, handleAux
  llenar_filas fila8, fila7, fila6, fila5, fila4, fila3, fila2, fila1, bufferAuxiliar, SIZEOF bufferAuxiliar
  jmp jugar
endm

.model small
.stack
.data

  puntosN WORD 0
  puntosB WORD 0

  encabezado0 db 0ah, 0dh, " ______________________________________________________", "$"
  encabezado1 db 0ah, 0dh, "|                                                      |", "$"
  encabezado2 db 0ah, 0dh, "|    Universidad de San Carlos de Guatemala            |", "$"
  encabezado3 db 0ah, 0dh, "|    Facultad de Ingenieria                            |", "$"
  encabezado4 db 0ah, 0dh, "|    Ciencias y Sistemas                               |", "$"
  encabezado5 db 0ah, 0dh, "|    Arquitectura de Computadores y Ensambladores 1    |", "$"
  encabezado7 db 0ah, 0dh, "|    Nombre: Luis Fernando Arana Arias                 |", "$"
  encabezado8 db 0ah, 0dh, "|    Carnet: 201700988                                 |", "$"
  encabezado6 db 0ah, 0dh, "|    Seccion A                                         |", "$"
  encabezado9 db 0ah, 0dh, "|______________________________________________________|", "$"
  opcion0     db 0ah, 0dh, "|                                                      |", "$"
  opcion1     db 0ah, 0dh, "|    Opciones:                                         |", "$"
  opcion2     db 0ah, 0dh, "|         1. Iniciar Juego                             |", "$"
  opcion3     db 0ah, 0dh, "|         2. Cargar Juego                              |", "$"
  opcion4     db 0ah, 0dh, "|         3. Salir                                     |", "$"
  opcion5     db 0ah, 0dh, "|______________________________________________________|", "$"

  textoOpcion db 0ah, 0dh, "  Seleccione una Opcion: ", "$"
  turnoB      db 0ah, 0dh, "  Turno Blancas: ", "$"
  turnoN      db 0ah, 0dh, "  Turno Negras: ", "$"
  pathFile    db 0ah, 0dh, "  Ingrese la ruta del archivo: ", "$"
  key_start   db 0ah, 0dh, "  Presiona una tecla para iniciar.", "$"
  name_file   db 0ah, 0dh, "  Ingresa el nombre del archivo: ", "$"
  save_       db 0ah, 0dh, "  -> Juego guardado exitosamente!", "$"
  load_       db 0ah, 0dh, "  -> Juego cargado exitosamente!", "$"

  ;Contenido de tablero
  f8 db " 8  |", "$"
  f7 db " 7  |", "$"
  f6 db " 6  |", "$"
  f5 db " 5  |", "$"
  f4 db " 4  |", "$"
  f3 db " 3  |", "$"
  f2 db " 2  |", "$"
  f1 db " 1  |", "$"

  fn    db "FN|", "$"
  fb    db "FB|", "$"
  ren   db "RN|", "$"
  reb   db "RB|", "$"
  vacio db "  |", "$"

  separador db 0ah, 0dh, "    -------------------------", "$"
  cols      db 0ah, 0dh, "     A  B  C  D  E  F  G  H ", " $"

  msgError0   db 0ah, 0dh, "  ** Error al crear archivo **", "$"
  msgError1   db 0ah, 0dh, "  ** Error al abrir archivo **", "$"
  msgError2   db 0ah, 0dh, "  ** Error al leer archivo **", "$"
  msgError3   db 0ah, 0dh, "  ** Error al escribir archivo **", "$"
  msgError4   db 0ah, 0dh, "  ** Error al cerrar archivo **", "$"
  msgMovIn    db 0ah, 0dh, "  ** No se puede retroceder la ficha **", "$"
  msgMovDia   db 0ah, 0dh, "  ** Solo se puede mover en diagonal **", "$"

  str_instr db 4 dup('$')
  ;Archivos
  bufferLectura db 1000 dup('$')
  bufferEscritura db 1000 dup('$')
  bufferAuxiliar db  1000 dup('$')
  handleFichero dw ?
  handleAux dw ?


  opcionActual db ' ', '$'
  turno db 0b

  ;espacio correcto 000
  ;espacio incorrecto 111

  ;ficha blanca 100
  ;ficha negra 010
  ;reina blanca 101
  ;reina negra 011

  fila8 db 100b, 111b, 100b, 111b, 100b, 111b, 100b, 111b
  fila7 db 111b, 100b, 111b, 100b, 111b, 100b, 111b, 100b
  fila6 db 100b, 111b, 100b, 111b, 100b, 111b, 100b, 111b
  fila5 db 111b, 000b, 111b, 000b, 111b, 000b, 111b, 000b
  fila4 db 000b, 111b, 000b, 111b, 000b, 111b, 000b, 111b
  fila3 db 111b, 010b, 111b, 010b, 111b, 010b, 111b, 010b
  fila2 db 010b, 111b, 010b, 111b, 010b, 111b, 010b, 111b
  fila1 db 111b, 010b, 111b, 010b, 111b, 010b, 111b, 010b

  salto db 0ah, 0dh, "$"

  cmdExit db "EXIT"
  cmdSave db "SAVE"
  cmdShow db "SHOW"

  numbers db 4 dup('$'), '$'
  arr_aux db 8 dup('$'), '$'

  FNegro db "0"
  FBlanco db "1"
  RNegro db "2"
  RBlanco db "3"
  VacioP db "4"
  VacioNP db "5"

  TIME db  '00:00:00', '$'

.code

main proc
  inicio:
    clear_screen
    ;-------------Mostrar encabezado
    print encabezado0
    print encabezado1
    print encabezado2
    print encabezado3
    print encabezado4
    print encabezado5
    print encabezado6
    print encabezado7
    print encabezado8
    print encabezado9
    ;-------------Mostrar opciones
    print opcion0
    print opcion1
    print opcion2
    print opcion3
    print opcion4
    print opcion5
    print salto
    print textoOpcion
    selectMenu opcionActual
    print salto
    print salto
  jugar:
    iniciarJuego
    jmp inicio
  cargar:
    cargarJuego
    getChar
    jmp inicio
  errorCrear:
    print msgError0
    getChar
    jmp inicio
  errorAbrir:
    print msgError1
    getChar
    jmp inicio
  errorLeer:
    print msgError2
    getChar
    jmp inicio
  errorEscribir:
    print msgError3
    getChar
    jmp inicio
  errorCerrar:
    print msgError4
    getChar
    jmp inicio
  salir:
    mov ah, 4ch
    xor al, al
    int 21h

  get_time proc
    push ax
    push cx
    mov ah, 2ch
    int 21h
    mov al, ch
    call convert
    mov [bx], ax
    mov al, cl
    call convert
    mov [bx+3], ax
    mov al, dh
    call convert
    mov [bx+6], ax
    pop cx
    pop ax
    ret
  get_time endp

  convert proc
    push dx
    mov ah, 0
    mov dl, 10
    div dl
    or ax, 3030h
    pop dx
    ret
  convert endp

main endp
end main
