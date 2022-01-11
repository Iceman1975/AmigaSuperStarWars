
;
;in a6 _custom
;

joystick:
		lea.l   button,a0
		;move.w	#1,(a0)
		lea.l   button_automatic,a1
		btst    #6,$bfe001			; button pressed?
		bne		joy_clean			; no -> clean
		cmp.w	#5,(a0)				;auto fire?
		bgt		joy_auto
		add.w	#1,(a0)	
		bra		joy_0
joy_auto:
		move 	#1,(a1)				;set auto fire
		bra	joy_0
		
joy_clean:
		move.w  #0,(a0)	; clean buttons
		move.w  #0,(a1)
joy_0:
		lea.l	joy1_left,a0
		
		move.w	JOY1DAT(a6),d1
		lea.l	joy1_old,a1
		lea.l	joyChanged,a2
		move.w	#0,(a2)	;set back
		cmp.w	(a1),d1
		beq		joy_1	;changed?
		move.w	#1,(a2)	;yes
joy_1:
		move	d1,(a1)	;current to old
		move.w	d1,d0
		add.w	d1,d1
		eor.w	d0,d1
		and.w	#514,d0
		and.w	#514,d1
		move.w	d0,(a0)+
		move.w	d1,(a0)
		rts
		
joy1_old		dc.w	0

joyChanged		dc.w 	0

joy1_left:		dc.b	0
joy1_right:		dc.b	0
joy1_up:		dc.b	0
joy1_down:		dc.b	0

button				dc.w 0
button_automatic	dc.w 0

;Usage
;		lea	left(pc),a0
;		tst.b	(a0)+
;		beq.b	.right
;
;		do something for left direction
;
;.right		tst.b	(a0)+
;		beq.b	.up
;
;		;right direction
;.up
;		;and so on...
;