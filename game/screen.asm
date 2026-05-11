levelPosX:
  dc.w      0

virtualScreenPosX:
  dc.w      80
	
virtualscreenPosY:
  dc.w      100                                                         ;virtualscreen_h-screenheight-1
	
paraClouds0X:
  dc.w      0

paraClouds1X:
  dc.w      0

paraMountainX:
  dc.w      0
	
paraScreenPosX:
  dc.w      0
	
paraScreenPosY:
  dc.w      0


screen_scroll:	
             ;lea.l      SHOW,a0
  move.l    trenchpointer_render,d0
 ; move.l     (a0),d0                                                     ;SHOW-> d0
	;do scrolling
  lea.l     virtualscreenPosY,a5                                        ;Y Pos
  move.w    (a5),d1
  mulu.w    #3*(trenchscreen_w/8),d1
  add.l     d1,d0
	
  lea.l     virtualScreenPosX,a5                                        ;X Pos
  move      (a5),d2                                                     ; X Position of screen 
  add       #$f,d2                                                      ; d2 = X+15
  moveq     #-1,d3	 
  sub.b     d2,d3                                                       ; d3 = -1-(X+15)
  and.b     #$f,d3                                                      ; d3 = (-1-(X+15))&15 = BPLC0N1


;remove?:	
  move.b    d3,d4
  lsl.b     #4,d4
  or.b      d4,d4

; fix flickering
;  cmp.b      #$f,d3
;  bne        s_correction
 ; move.b     #$0,d3
	
s_correction:
  lsl.b     #4,d3

  move.b    d3,scrollH+3
	
; fix done 

;	lsl.b #4,d3
;	or.b d3,scrollH+3 	; Verschiebung fuer ungerade Planes  (background)
	
  lsr       #4,d2                                                       ; d2 = (X-15)/16 = zu addierende Words
  add       d2,d2                                                       ; d2 = zu addierende Bytes fuer X
  add       d2,d0                                                       ; d2 = zu addierende Bytes fuer X+Y
	;end scrolling
	
	
  lea       copperTrenchScreen,a0
  moveq     #2,d7 
ss1:
  move      d0,6(a0) 
  swap      d0 
  move      d0,2(a0) 
  swap      d0 
  add.l     #trenchscreen_w/8,d0 
  addq.l    #8,a0 
  dbf       d7,ss1
	
	;done not set para screen (d3=foreground playfield)
	
  rts

screen_init:

  ;lea.l      trench,a0
  move.l    trenchpointer,d0
  lea       copperTrenchScreen,a0
  moveq     #2,d7 
ss2:
  move      d0,6(a0) 
  swap      d0 
  move      d0,2(a0) 
  swap      d0 
  add.l     #trenchscreen_w/8,d0 
  addq.l    #8,a0 
  dbf       d7,ss2
	
  rts

screen_init_cockpit:

  lea.l     cockpit_plus,a0
  move.l    a0,d0
  lea       copperMainScreen,a0
  moveq     #2,d7 
ss3:
  move      d0,6(a0) 
  swap      d0 
  move      d0,2(a0) 
  swap      d0 
  add.l     #virtualscreen_w/8,d0 
  addq.l    #8,a0 
  dbf       d7,ss3
	
  rts


screen_nextTrenchFrame:
  move.w    trenchframecounter,d0
  addq      #1,d0
  move.w    d0,trenchframecounter  
  cmp.w     #5,d0
  beq       screen_btf_change   
  bra       s_nextTF_done 

screen_btf_change:
  move.l    trenchpointer_render,trenchpointer

  move.w    0,trenchframecounter
  lea.l     trenchpointer_render,a0
  move.l    #trenchscreensize,d0
  add.l     d0,(a0)
  lea.l     trenchend,a1
  move.l    a1,d1
  cmp.l     (a0),d1
  bne.s     s_nextTF_done
  lea.l     trench,a1
  move.l    a1,(a0)

s_nextTF_done:
  rts





trenchpointer_render:
  dc.l      trench+trenchscreensize

trenchpointer:
  dc.l      trench+(2*trenchscreensize)




trenchframecounter:
  dc.w      0



move_cockpit:
  move.w    virtualScreenPosX,d0
  

  lea.l     joy1_left,a0
  tst.b     (a0)
  beq       mc_noLeft
  cmp.w     0,d0 
  beq       mc_noLeft
  sub.w     #4,virtualScreenPosX     
mc_noLeft:
  lea.l     joy1_right,a0
  tst.b     (a0)
  beq       mc_noRigth
  cmp.w     #trenchscreen_w-virtualscreen_w-8,d0
  bge       mc_noRigth 
  add.w     #4,virtualScreenPosX 
mc_noRigth:
  move.w    virtualscreenPosY,d0
  lea.l     joy1_down,a0
  tst.b     (a0)
  beq       mc_noDown
  cmp.w     0,d0 
  beq       mc_noDown
  sub.w     #4,virtualscreenPosY 
mc_noDown:
  lea.l     joy1_up,a0
  tst.b     (a0)
  beq       mc_noUp
  cmp.w     #trenchscreen_h-virtualscreen_h,d0
  bge       mc_noUp 
  add.w     #4,virtualscreenPosY 
mc_noUp:
  rts

copper:
             ;dc.w       BPLCON3, $0c00 
             

  dc.w      DIWSTRT,$3081
  ;dc.w       DIWSTOP,$08c1
  dc.w      DIWSTOP,$08b0
  dc.w      DDFSTRT,$30
  ;dc.w       DDFSTOP,$d0 
  dc.w      DDFSTOP,$c0 
             
  dc.w      BPLCON0, $6600

  dc.w      BPLCON2, $0024
             
scrollH:
  dc.w      BPLCON1, $000f
	


  dc.w      COLOR00, $0000
  dc.w      COLOR01, $0001
  dc.w      COLOR02, $088d
  dc.w      COLOR03, $00c0
  dc.w      COLOR04, $0ff5
  dc.w      COLOR05, $0b00
  dc.w      COLOR06, $0fb0
  dc.w      COLOR07, $0f00
	
	;colors trench

       	
  dc.w      COLOR08, $0000
  dc.w      COLOR09, $0234
  dc.w      COLOR10, $089a
  dc.w      COLOR11, $0567
  dc.w      COLOR12, $0789
  dc.w      COLOR13, $0bcd
  dc.w      COLOR14, $0678
  dc.w      COLOR15, $0345
	
  dc.w      COLOR16, $0048
  dc.w      COLOR17, $0a25
  dc.w      COLOR18, $0e35
  dc.w      COLOR19, $0816
  dc.w      COLOR20, $0616
  dc.w      COLOR21, $0e58
  dc.w      COLOR22, $0f6b
  dc.w      COLOR23, $0fdf
  dc.w      COLOR24, $0fff
  dc.w      COLOR25, $0fcf
  dc.w      COLOR26, $0faf
  dc.w      COLOR27, $0fbf
  dc.w      COLOR28, $0fff
  dc.w      COLOR29, $0e22
  dc.w      COLOR30, $0f8e
  dc.w      COLOR31, $0c24
	



copperMainScreen:
  dc.w      BPL1PTH,0
  dc.w      BPL1PTL,0
  dc.w      BPL3PTH,0
  dc.w      BPL3PTL,0
  dc.w      BPL5PTH,0
  dc.w      BPL5PTL,0

copperTrenchScreen:
  dc.w      BPL2PTH,0
  dc.w      BPL2PTL,0
  dc.w      BPL4PTH,0
  dc.w      BPL4PTL,0
  dc.w      BPL6PTH,0
  dc.w      BPL6PTL,0
   

;  dc.w       BPL1MOD,(virtualscreen_w/8)-40-2+(2*(virtualscreen_w/8)) 
;  dc.w       BPL2MOD,(trenchscreen_w/8)-40-2+(2*(trenchscreen_w/8))  	

  dc.w      BPL1MOD,(virtualscreen_w/8)-40+2+(2*(virtualscreen_w/8)) 
  dc.w      BPL2MOD,(trenchscreen_w/8)-40+2+(2*(trenchscreen_w/8))  	

sp0:	
  dc.w      $0120,$0000                                                 ; SPR0PTH
  dc.w      $0122,$0000                                                 ; SPR0PTL
sp1:
  dc.w      $0124,$0000                                                 ; SPR1PTH
  dc.w      $0126,$0000                                                 ; SPR1PTL
sp2:	
  dc.w      $0128,$0000                                                 ; SPR2PTH
  dc.w      $012a,$0000                                                 ; SPR2PTL
sp3:	
  dc.w      $012c,$0000                                                 ; SPR3PTH
  dc.w      $012e,$0000                                                 ; SPR3PTL
	
  dc.w      $0130,$0000                                                 ; SPR4PTH
  dc.w      $0132,$0000                                                 ; SPR4PTL
  dc.w      $0134,$0000                                                 ; SPR5PTH
  dc.w      $0136,$0000                                                 ; SPR5PTL
  dc.w      $0138,$0000                                                 ; SPR6PTH
  dc.w      $013a,$0000                                                 ; SPR6PTL
  dc.w      $013c,$0000                                                 ; SPR7PTH
  dc.w      $013e,$0000                                                 ; SPR7PTL
	
  dc.w      $104,%0000000000100000                                      ; sprites prio
	
	;DC.W 	$5009,$FFFE           ; Wait for vpos >= 0x3F and hpos >= 0x80
	
  dc.w      $ffdf,$fffe                                                 ; wait($df,$ff) enables waits > $ff vertical
  dc.w      $2c01,$fffe                                                 ; wait($01,$12c) - $2c is $12c
  dc.w      $0100,$0200                                                 ; BPLCON0 unset bitplanes, enable color burst
						; needed to support older PAL chips
  dc.w      $ffff,$fffe                                                 ; end of copper

	

