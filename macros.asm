print macro cadena
  mov ax,@data
  mov ds,ax
  mov ah,09h
  mov dx,offset cadena
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
  je jugar
  cmp al, 32h ;Opcion 2) Cargar Juego
  mov option[0], 32h
  je cargar
  cmp al, 33h
  mov option[0], 33h
  je salir
  ;print salto
  jmp inicio
endm

imprimirTablero macro arr_fila, fb, fn, ren, reb, fila, libre
  LOCAL inicio, pintar_espacio, pintar_fb, pintar_fn, pintar_rn, pintar_rb, next, fin
  xor si, si
  inicio:
  print fila
  mov bx, cx
  mov cx, 8
  next:
  mov al, arr_fila[si]
  cmp al, 000b
  je pintar_espacio
  cmp al, 111b
  je pintar_espacio
  cmp al, 100b
  je pintar_fb
  cmp al, 010b
  je pintar_fn
  cmp al, 101b
  je pintar_rb
  cmp al, 011b
  je pintar_rn
  pintar_espacio:
  print libre
  jmp fin
  pintar_fb:
  print fb
  jmp fin
  pintar_fn:
  print fn
  jmp fin
  pintar_rb:
  print reb
  jmp fin
  pintar_rn:
  print ren
  jmp fin
  fin:
  inc si
  cmp si, 8
  jb next
endm

get_text_kb macro buffer
  LOCAL char_get, findout
  xor si, si
  char_get:
  getChar
  cmp al, 0dh
  je findout
  mov buffer[si], al
  inc si
  jmp char_get
  findout:
  mov al, 00h
  mov buffer[si], al
endm

validar_mov macro comando, ficha
  LOCAL reporte, guardar, movimiento_ficha, movimiento_simple, movimiento_compuesto

  compare_str comando, cmdExit
  je inicio
  compare_str comando, cmdSave
  je guardar
  compare_str comando, cmdShow
  je reporte

  movimiento_ficha:
  mov al, comando[2]
  cmp al, 2ch
  je movimiento_compuesto
  jmp movimiento_simple

  guardar:
  limpiarBuffer bufferEscritura, SIZEOF bufferEscritura, 24h
  save_game bufferEscritura, handleFichero, fila8, fila7, fila6, fila5, fila4, fila3, fila2, fila1
  repetir_turno ficha

  reporte:
  rep_game bufferReporte, handlerReporte, fila8, fila7, fila6, fila5, fila4, fila3, fila2, fila1
  repetir_turno ficha

  movimiento_compuesto:
  ;VERIFICAR INICIO

  ;VERIFICAR DESTINO

  ;MOVER PIEZA
  xor di, di
  mov al, comando[di]
  inc di
  mov bl, comando[di]
  mover_pieza bl, al, ficha

  xor di, di
  inc di
  inc di
  inc di
  mov al, comando[di]
  inc di
  mov bl, comando[di]
  poner_pieza bl, al, ficha

  crearTablero
  getChar
  select_next ficha

  movimiento_simple:
  ;BUSCAR DISPONIBLE

  ;VERIFICAR DESTINO

  ;MOVER PIEZA

  crearTablero
  getChar
  select_next ficha
endm

poner_pieza macro fila_fin, col_fin, ficha
LOCAL select_fin, pushn8, pushb8, pushn7, pushb7, pushn6, pushb6, pushn5, pushb5, pushn4, pushb4, pushn3, pushb3, pushn2, pushb2, pushn1, pushb1, fin_move, fin_fila8, fin_fila7, fin_fila6, fin_fila5, fin_fila4, fin_fila3, fin_fila2, fin_fila1

select_fin:
  mov ah, fila_fin
  cmp ah, 31h ;1
  je fin_fila1
  cmp ah, 32h ;2
  je fin_fila2
  cmp ah, 33h ;3
  je fin_fila3
  cmp ah, 34h ;4
  je fin_fila4
  cmp ah, 35h ;5
  je fin_fila5
  cmp ah, 36h ;6
  je fin_fila6
  cmp ah, 37h ;7
  je fin_fila7
  cmp ah, 38h ;8
  je fin_fila8

  fin_fila8:
    xor si, si
    inc si
    mov ah, ficha[si]
    cmp ah, 4eh
    je pushn8
    cmp ah, 42h
    je pushb8

  fin_fila7:
    xor si, si
    inc si
    mov ah, ficha[si]
    cmp ah, 4eh
    je pushn7
    cmp ah, 42h
    je pushb7

  fin_fila6:
    xor si, si
    inc si
    mov ah, ficha[si]
    cmp ah, 4eh
    je pushn6
    cmp ah, 42h
    je pushb6

  fin_fila5:
    xor si, si
    inc si
    mov ah, ficha[si]
    cmp ah, 4eh
    je pushn5
    cmp ah, 42h
    je pushb5

  fin_fila4:
    xor si, si
    inc si
    mov ah, ficha[si]
    cmp ah, 4eh
    je pushn4
    cmp ah, 42h
    je pushb4

  fin_fila3:
    xor si, si
    inc si
    mov ah, ficha[si]
    cmp ah, 4eh
    je pushn3
    cmp ah, 42h
    je pushb3

  fin_fila2:
    xor si, si
    inc si
    mov ah, ficha[si]
    cmp ah, 4eh
    je pushn2
    cmp ah, 42h
    je pushb2

  fin_fila1:
    xor si, si
    inc si
    mov ah, ficha[si]
    cmp ah, 4eh
    je pushn1
    cmp ah, 42h
    je pushb1

  pushn8:
    push_valor col_fin, ficha, fila8, 010b
    jmp fin_move

  pushb8:
    push_valor col_fin, ficha, fila8, 100b
    jmp fin_move

  pushn7:
    push_valor col_fin, ficha, fila7, 010b
    jmp fin_move

  pushb7:
    push_valor col_fin, ficha, fila7, 100b
    jmp fin_move

  pushn6:
    push_valor col_fin, ficha, fila6, 010b
    jmp fin_move

  pushb6:
    push_valor col_fin, ficha, fila6, 100b
    jmp fin_move

  pushn5:
    push_valor col_fin, ficha, fila5, 010b
    jmp fin_move

  pushb5:
    push_valor col_fin, ficha, fila5, 100b
    jmp fin_move

  pushn4:
    push_valor col_fin, ficha, fila4, 010b
    jmp fin_move

  pushb4:
    push_valor col_fin, ficha, fila4, 100b
    jmp fin_move

  pushn3:
    push_valor col_fin, ficha, fila3, 010b
    jmp fin_move

  pushb3:
    push_valor col_fin, ficha, fila3, 100b
    jmp fin_move

  pushn2:
    push_valor col_fin, ficha, fila2, 010b
    jmp fin_move

  pushb2:
    push_valor col_fin, ficha, fila2, 100b
    jmp fin_move

  pushn1:
    push_valor col_fin, ficha, fila1, 010b
    jmp fin_move

  pushb1:
    push_valor col_fin, ficha, fila1, 100b
    jmp fin_move


    fin_move:
endm

mover_pieza macro fil_inicio, col_inicio, ficha
LOCAL select_fila, mov_fila8, mov_fila7, mov_fila6, mov_fila5, mov_fila4, mov_fila3, mov_fila2, mov_fila1, fin_move

select_fila:
  mov ah, fil_inicio
  cmp ah, 31h ;1
  je mov_fila1
  cmp ah, 32h ;2
  je mov_fila2
  cmp ah, 33h ;3
  je mov_fila3
  cmp ah, 34h ;4
  je mov_fila4
  cmp ah, 35h ;5
  je mov_fila5
  cmp ah, 36h ;6
  je mov_fila6
  cmp ah, 37h ;7
  je mov_fila7
  cmp ah, 38h ;8
  je mov_fila8

mov_fila8:
  push_valor col_inicio, ficha, fila8, 000b
  jmp fin_move

mov_fila7:
  push_valor col_inicio, ficha, fila7, 000b
  jmp fin_move

mov_fila6:
  push_valor col_inicio, ficha, fila6, 000b
  jmp fin_move

mov_fila5:
  push_valor col_inicio, ficha, fila5,  000b
  jmp fin_move

mov_fila4:
  push_valor col_inicio, ficha, fila4, 000b
  jmp fin_move

mov_fila3:
  push_valor col_inicio, ficha, fila3, 000b
  jmp fin_move

mov_fila2:
  push_valor col_inicio, ficha, fila2, 000b
  jmp fin_move

mov_fila1:
  push_valor col_inicio, ficha, fila1, 000b
  jmp fin_move

  fin_move:
endm


push_valor macro col_push, ficha, fila, inser
LOCAL fil_fin, pcol1, pcol2, pcol3, pcol4, pcol5, pcol6, pcol7, pcol8, end_push, pcol0

fil_fin:
mov ah, col_push
cmp ah, 41h ;A
je pcol1
cmp ah, 42h ;B
je pcol2
cmp ah, 43h ;C
je pcol3
cmp ah, 44h ;D
je pcol4
cmp ah, 45h ;E
je pcol5
cmp ah, 46h ;F
je pcol6
cmp ah, 47h ;G
je pcol7
cmp ah, 48h ;H
je pcol8

pcol1:
xor si, si
mov ah, inser
mov fila[si], ah
jmp end_push

pcol2:
xor si, si
inc si
mov ah, inser
mov fila[si], ah
jmp end_push

pcol3:
xor si, si
inc si
inc si
mov ah, inser
mov fila[si], ah
jmp end_push

pcol4:
xor si, si
inc si
inc si
inc si
mov ah, inser
mov fila[si], ah
jmp end_push

pcol5:
xor si, si
inc si
inc si
inc si
inc si
mov ah, inser
mov fila[si], ah
jmp end_push

pcol6:
xor si, si
inc si
inc si
inc si
inc si
inc si
mov ah, inser
mov fila[si], ah
jmp end_push

pcol7:
xor si, si
inc si
inc si
inc si
inc si
inc si
inc si
mov ah, inser
mov fila[si], ah
jmp end_push

pcol8:
xor si, si
inc si
inc si
inc si
inc si
inc si
inc si
inc si
mov ah, inser
mov fila[si], ah
jmp end_push

  end_push:
endm


rep_game macro buffer, handler, f8, f7, f6, f5, f4, f3, f2, f1
  crearFile buffer, handler

  escribirF SIZEOF start_html, start_html, handler
  escribirF SIZEOF head_html, head_html, handler
  escribirF SIZEOF h1_html, h1_html, handler
  LEA BX, TIME                 ; BX=offset address of string TIME
  CALL get_time
  escribirF SIZEOF TIME, TIME, handler
  escribirF SIZEOF h1e_html, h1e_html, handler
  escribirF SIZEOF inicio_html, inicio_html, handler
  escribirF SIZEOF fila_html, fila_html, handler
  prep_ff f8, handler
  escribirF SIZEOF fila_end_html, fila_end_html, handler
  escribirF SIZEOF fila_html, fila_html, handler
  prep_ff f7, handler
  escribirF SIZEOF fila_end_html, fila_end_html, handler
  escribirF SIZEOF fila_html, fila_html, handler
  prep_ff f6, handler
  escribirF SIZEOF fila_end_html, fila_end_html, handler
  escribirF SIZEOF fila_html, fila_html, handler
  prep_ff f5, handler
  escribirF SIZEOF fila_end_html, fila_end_html, handler
  escribirF SIZEOF fila_html, fila_html, handler
  prep_ff f4, handler
  escribirF SIZEOF fila_end_html, fila_end_html, handler
  escribirF SIZEOF fila_html, fila_html, handler
  prep_ff f3, handler
  escribirF SIZEOF fila_end_html, fila_end_html, handler
  escribirF SIZEOF fila_html, fila_html, handler
  prep_ff f2, handler
  escribirF SIZEOF fila_end_html, fila_end_html, handler
  escribirF SIZEOF fila_html, fila_html, handler
  prep_ff f1, handler
  escribirF SIZEOF fila_end_html, fila_end_html, handler
  escribirF SIZEOF end_html, end_html, handler

  cerrarF handler
  print report_
  getChar
endm

prep_ff macro fila, handler
  LOCAL loop_save, print_clear, print_clearn, print_fb, print_fn, print_rn, print_rb, cond_loop
  xor si, si

  loop_save:
  mov al, fila[si]
  cmp al, 000b
  je print_clear
  cmp al, 111b
  je print_clearn
  cmp al, 100b
  je print_fb
  cmp al, 010b
  je print_fn
  cmp al, 101b
  je print_rb
  cmp al, 011b
  je print_rn

  print_fb:
  escribirF SIZEOF celda_fb, celda_fb, handler
  jmp cond_loop

  print_fn:
  escribirF SIZEOF celda_fn, celda_fn, handler
  jmp cond_loop

  print_clear:
  escribirF SIZEOF celda_vnp, celda_vnp, handler
  jmp cond_loop

  print_clearn:
  escribirF SIZEOF celda_vp, celda_vp, handler
  jmp cond_loop

  print_rn:
  escribirF SIZEOF celda_rn, celda_rn, handler
  jmp cond_loop

  print_rb:
  escribirF SIZEOF celda_rb, celda_rb, handler
  jmp cond_loop

  cond_loop:
  inc si
  cmp si, 8
  jb loop_save
endm

repetir_turno macro ficha
  xor si, si
  inc si
  mov al, ficha[si]
  cmp al, 4eh
  je turno_negra
  cmp al, 42h
  je turno_blanco
endm

select_next macro ficha
  xor si, si
  inc si
  mov al, ficha[si]
  cmp al, 4eh
  je turno_blanco
  cmp al, 42h
  je turno_negra
endm

save_game macro buffer, handler, f8, f7, f6, f5, f4, f3, f2 ,f1
  print name_file
  get_path buffer
  crearFile buffer, handler
  print_ff f8, handler
  print_ff f7, handler
  print_ff f6, handler
  print_ff f5, handler
  print_ff f4, handler
  print_ff f3, handler
  print_ff f2, handler
  print_ff f1, handler
  cerrarF handler
  print save_
  getChar
endm

print_ff macro fila, handle
  LOCAL loop_save, print_clear, print_clearn, print_fb, print_fn, print_rn, print_rb, cond_loop
  xor si, si
  loop_save:
  mov al, fila[si]
  cmp al, 000b
  je print_clear
  cmp al, 111b
  je print_clearn
  cmp al, 100b
  je print_fb
  cmp al, 010b
  je print_fn
  cmp al, 101b
  je print_rb
  cmp al, 011b
  je print_rn
  print_fb:
  escribirF SIZEOF FBlanco, FBlanco, handle
  jmp cond_loop
  print_fn:
  escribirF SIZEOF FNegro, FNegro, handle
  jmp cond_loop
  print_clear:
  escribirF SIZEOF VacioP, VacioP, handle
  jmp cond_loop
  print_clearn:
  escribirF SIZEOF VacioNP, VacioNP, handle
  jmp cond_loop
  print_rn:
  escribirF SIZEOF RNegro, RNegro, handle
  jmp cond_loop
  print_rb:
  escribirF SIZEOF RBlanco, RBlanco, handle
  jmp cond_loop
  cond_loop:
  inc si
  cmp si, 8
  jb loop_save
endm

get_path macro buffer
  LOCAL get_char, finout
  xor si, si
  get_char:
  getChar
  cmp al, 0dh
  je finout
  mov buffer[si], al
  inc si
  jmp get_char
  finout:
  mov al, 00h
  mov buffer[si], al
endm

compare_str macro str1, str2
  LOCAL _loop, start_loop, end_loop
  xor si, si
  mov cx, 5
  start_loop:
  cmp str1[si], 24h
  je end_loop
  cmp str2[si], 24h
  je end_loop
  mov al, str1[si]
  mov dl, str2[si]
  cmp al, dl
  jne end_loop
  cmp al, dl
  je _loop
  jmp end_loop
  _loop:
  inc si
  dec cx
  cmp cx, 0001b
  ja start_loop
  jmp end_loop
  end_loop:
  cmp al, dl
endm

llenar_filas macro f8, f7, f6, f5, f4, f3, f2, f1, infor, numBytes
  LOCAL loop_fill, condi_loop, reset_fil, fill_f1, fill_f2, fill_f3, fill_f4, fill_f5, fill_f6, fill_f7, fill_f8
  xor si, si
  xor di, di

  loop_fill:
  cmp si, 8
  jb fill_f8
  cmp si, 16
  jb fill_f7
  cmp si, 24
  jb fill_f6
  cmp si, 32
  jb fill_f5
  cmp si, 40
  jb fill_f4
  cmp si, 48
  jb fill_f3
  cmp si, 56
  jb fill_f2
  cmp si, 64
  jb fill_f1

  fill_f8:
  insert_val f8, di, infor[si]
  jmp condi_loop

  fill_f7:
  insert_val f7, di, infor[si]
  jmp condi_loop

  fill_f6:
  insert_val f6, di, infor[si]
  jmp condi_loop

  fill_f5:
  insert_val f5, di, infor[si]
  jmp condi_loop

  fill_f4:
  insert_val f4, di, infor[si]
  jmp condi_loop

  fill_f3:
  insert_val f3, di, infor[si]
  jmp condi_loop

  fill_f2:
  insert_val f2, di, infor[si]
  jmp condi_loop

  fill_f1:
  mov al, infor[si]
  insert_val f1, di, al
  jmp condi_loop

  condi_loop:
  inc si
  inc di

  cmp di, 8
  jb reset_fil
  xor di, di

  reset_fil:
  cmp si, 64
  jb loop_fill
endm

insert_val macro fila, pos, dato
LOCAL insert_fn, insert_fb, insert_rn, insert_rb, insert_vp, insert_vnp, end_ins

  cmp dato, 30h
  je insert_fn
  cmp dato, 31h
  je insert_fb
  cmp dato, 32h
  je insert_rn
  cmp dato, 33h
  je insert_rb
  cmp dato, 34h
  je insert_vp
  cmp dato, 35h
  je insert_vnp

  insert_fn:
    mov al, 010b
    mov fila[pos], al
    jmp end_ins

  insert_fb:
    mov al, 100b
    mov fila[pos], al
    jmp end_ins

  insert_rn:
    mov al, 011b
    mov fila[pos], al
    jmp end_ins

  insert_rb:
    mov al, 101b
    mov fila[pos], al
    jmp end_ins

  insert_vp:
    mov al, 000b
    mov fila[pos], al
    jmp end_ins

  insert_vnp:
    mov al, 111b
    mov fila[pos], al
    jmp end_ins

  end_ins:

endm

clear_screen macro
  mov ax, 03h
  int 10h
endm

cerrarF macro handle
  mov ah, 3eh
  mov bx, handle
  int 21h
  jc errorCerrar
endm

abrirF macro ruta, handle
  mov ah, 3dh
  mov al, 02h
  lea dx, ruta
  int 21h
  mov handle, ax
  jc errorAbrir
endm

leerF macro numBytes, buffer, handle
  mov ah, 3fh
  mov bx, handle
  mov cx, numBytes
  lea dx, buffer
  int 21h
  jc errorLeer
endm

escribirF macro numBytes, buffer, handle
  mov ah, 40h
  mov bx, handle
  mov cx, numBytes
  lea dx, buffer
  int 21h
  jc errorEscribir
endm

limpiarBuffer macro buffer, numBytes, char
  LOCAL loop_
  xor si, si
  xor cx, cx
  mov cx, numBytes
  loop_:
  mov buffer[si], char
  inc si
  loop loop_
endm
