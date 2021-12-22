IDEAL
MODEL small
STACK 100h

DATASEG
	array db 4, 7, 5, 1, 4, 6, 32, 45, 11, 15
	len db 10
  min db ?
  index db ?

CODESEG
;--------------------------------------FIND SMALLEST NUMBER IN AN ARRAY--------------------------------------
;IN: offset min, offset len, offset array, offset index
;OUT: none
  proc findSmallest
  	;compare first number with the rest, put the smallest at start
  	push bp
  	mov bp, sp
  	push ax
  	push bx
  	push cx
    push dx

  	mov bx, [bp+6] ; len offset
		xor ch, ch
    mov cl, [bx] ; len
  	mov bx, [bp+8] ; array offset
    ; bx = [0], cx = length (10)
  	; for loop to find smallest number between array offset [0], and length-1 [9]
    mov al, [bx] ; first item in array
		dec cx
		add cx, bx
		dec cx
    loop1:
      cmp al, [bx+1]
      jl skip1
      mov al, [bx+1] ; new min

			mov dx, bx
			inc dx

      skip1:
        inc bx
        dec cx
				cmp cx, [bp+8]
				jge loop1

		mov bx, [bp+6]
		inc bx
		mov ax, [bp+8]
		inc ax
    mov [bx], ax ; new min

		cmp dl, 0
		jne not_zero
		mov dl, al
		dec dl

		not_zero:
    	mov bx, [bp+10]
			xor dh, dh
    	mov [bx], dl ; new index
    pop dx
    pop cx
  	pop bx
  	pop ax
  	pop bp
  	ret 8
  	endp findSmallest
;------------------------------------------------------------------------------------------------------------

;-----------------------SWITCH OLD INDEX WITH NEW MIN AND OLD MIN WITH NEW INDEX-----------------------------
;IN: offset min, offset index
;OUT: none
	proc switch
	  push bp
	  mov bp, sp
	  push bx
	  push cx
	  push ax
	  push dx

		mov bx, [bp+6] ; bx = offset offset index
		mov al, [bx] ; al = offset index
		xor ah, ah
		mov bx, ax
		mov al, [bx] ; al = index

		mov bx, [bp+4] ; bx = offset offset min
		mov cl, [bx] ; cl = offset min
		xor ch, ch
		mov bx, cx
		mov cl, [bx-1] ; cl = min

		mov bx, [bp+6] ; bx = offset offset index
		mov dl, [bx] ; dl = offset index
		xor dh, dh
		mov bx, dx
		mov [bx], cl ; offset index <-- cl ( = min)

		mov bx, [bp+4] ; bx = offset offset min
		mov dl, [bx] ; dl = offset min
		xor dh, dh
		mov bx, dx
		mov [bx-1], al ; offset min <-- al ( = index)

	  pop dx
	  pop ax
	  pop cx
	  pop bx
		pop bp
	  ret 4
	  endp switch
;------------------------------------------------------------------------------------------------------------


;--------------------------------------MAIN------------------------------------------------------------------
start:
	mov ax, @data
	mov ds, ax

setup:
  mov bx, offset array
	xor ch, ch
	mov cl, [len]
	dec cl

	main:
		firstProc:
			mov ax, offset index
	    push ax ; [bp+10]
			push bx ; offset array+bx  ; [bp+8]
			mov ax, offset len
			push ax ; [bp+6]
	    mov ax, offset min
			push ax ; [bp+4]
			call findSmallest

		secondProc:
	    mov ax, offset index
			push ax ; [bp+4]
	    mov ax, offset min
			push ax ; [bp+6]
	    call switch

		dec [len]
    inc bx
    cmp bx, cx
		jne main

exit:
	mov ax, 4c00h
	int 21h

END start
