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
  LOCAL reporte, guardar, movimiento_ficha

  compare_str comando, cmdExit
  je inicio
  compare_str comando, cmdSave
  je guardar
  compare_str comando, cmdShow
  je reporte

  movimiento_ficha:
  getChar
  repetir_turno ficha
  guardar:
  limpiarBuffer bufferEscritura, SIZEOF bufferEscritura, 24h
  save_game bufferEscritura, handleFichero, fila8, fila7, fila6, fila5, fila4, fila3, fila2, fila1
  repetir_turno ficha
  reporte:
  rep_game bufferReporte, handlerReporte, fila8, fila7, fila6, fila5, fila4, fila3, fila2, fila1
  repetir_turno ficha

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
  je print_rn
  cmp al, 011b
  je print_rb

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
  je print_rn
  cmp al, 011b
  je print_rb
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
