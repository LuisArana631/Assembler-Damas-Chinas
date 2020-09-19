include macros.asm

crearFile macro ruta, handle
    mov ah, 3ch
    mov cx, 00h
    lea dx, ruta
    int 21h
    jc ErrorCrear
    mov handle, ax
endm

.model small
.stack
.data

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

  msgError0    db 0ah, 0dh, "  ** Error al crear archivo **", "$"

  bufferLectura db 1000 dup('$')
  bufferEscritura db 1000 dup('$')
  bufferAuxiliar db  1000 dup('$')

  opcionActual db ' ', '$'

  salto db 0ah, 0dh, "$"

.code

main proc
  inicio:
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
    print opcion2
    jmp inicio
  cargarJuego:
    print opcion3
    jmp inicio
  errorCrear:
    print msgError0
    getChar
    jmp inicio
  salir:
    mov ah, 4ch
    xor al, al
    int 21h

main endp
end main
