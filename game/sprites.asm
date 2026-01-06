BULLET_HEIGHT     EQU 15
BULLET_PHASE_SIZE EQU 20*4*2
BULLET_WIDTH      EQU 16

BULLET_X_START    EQU 80
BULLET_Y_START    EQU 80

phasecounter:	
               dc.w      0
	
phasepointer:
               dc.l      0,0,0
               dc.l      0,0,0
               dc.l      0,0,0
               dc.l      0,0,0
               dc.l      BULLET_PHASE_SIZE,BULLET_PHASE_SIZE,BULLET_PHASE_SIZE
               dc.l      BULLET_PHASE_SIZE,BULLET_PHASE_SIZE,BULLET_PHASE_SIZE
               dc.l      BULLET_PHASE_SIZE,BULLET_PHASE_SIZE,BULLET_PHASE_SIZE
               dc.l      BULLET_PHASE_SIZE,BULLET_PHASE_SIZE,BULLET_PHASE_SIZE
               dc.l      2*BULLET_PHASE_SIZE,2*BULLET_PHASE_SIZE,2*BULLET_PHASE_SIZE
               dc.l      2*BULLET_PHASE_SIZE,2*BULLET_PHASE_SIZE,2*BULLET_PHASE_SIZE
               dc.l      3*BULLET_PHASE_SIZE,3*BULLET_PHASE_SIZE,3*BULLET_PHASE_SIZE
               dc.l      3*BULLET_PHASE_SIZE,3*BULLET_PHASE_SIZE
               dc.l      4*BULLET_PHASE_SIZE,4*BULLET_PHASE_SIZE,4*BULLET_PHASE_SIZE
               dc.l      4*BULLET_PHASE_SIZE
               dc.l      5*BULLET_PHASE_SIZE,5*BULLET_PHASE_SIZE,5*BULLET_PHASE_SIZE
               dc.l      -1

player_score:
               dc.w      0

bullet_screen_x:
               dc.w      $80

bullet_screen_x_move:
               dc.w      BULLET_X_START

bullet_screen_y:
               dc.w      $80		

bullet_active  dc.w      0

bullet_slow_count:	;buffer for reducing creation speed of bullets
               dc.w      0


sprites_init:
               lea.l     blanksprite,a1                                                 ; put blanksprite address into a1
               lea.l     sp0,a2                                                         ; put copper address into a2
               add.l     #2,a2                                                          ; add 10 to copper address in a2
               move.l    a1,d1                                                          ; move blanksprite address into d1
               moveq     #7,d0                                                          ; setup sprite counter

s1_sprcoploop:            ; set all 7 sprite pointers
               swap      d1                                                             ; high and low to point to blanksprite 
               move.w    d1,(a2)
               addq.l    #4,a2
               swap      d1
               move.w    d1,(a2)
               addq.l    #4,a2
               dbra      d0,s1_sprcoploop                                               ; loop trough all 7 sprite pointers
               rts

            
;add bullet sprite
               lea.l     sprite0_0,a1                                                   ; put sprite address into a1
               lea.l     sp0,a2                                                         ; put copper address into a2
               move.l    a1,d1                                                          ; move sprite address into d1
               move.w    d1,6(a2)                                                       ; transfer sprite address high to copper
               swap      d1                                                             ; swap
               move.w    d1,2(a2)                                                       ; transfer sprite address low to copper

               lea.l     sprite1_0,a1                                                   ; put sprite address into a1
               lea.l     sp1,a2                                                         ; put copper address into a2
               move.l    a1,d1                                                          ; move sprite address into d1
               move.w    d1,6(a2)                                                       ; transfer sprite address high to copper
               swap      d1                                                             ; swap
               move.w    d1,2(a2)                                                       ; transfer sprite address low to copper
	
               lea.l     sprite0_0,a1                                                   ; put sprite address into a1
               lea.l     sp2,a2                                                         ; put copper address into a2
               move.l    a1,d1                                                          ; move sprite address into d1
               move.w    d1,6(a2)                                                       ; transfer sprite address high to copper
               swap      d1                                                             ; swap
               move.w    d1,2(a2)                                                       ; transfer sprite address low to copper

               lea.l     sprite1_0,a1                                                   ; put sprite address into a1
               lea.l     sp3,a2                                                         ; put copper address into a2
               move.l    a1,d1                                                          ; move sprite address into d1
               move.w    d1,6(a2)                                                       ; transfer sprite address high to copper
               swap      d1                                                             ; swap
               move.w    d1,2(a2)                                                       ; transfer sprite address low to copper
               rts
	





	
sprites_drawBullet:
               move.w    bullet_active,d0
               tst.w     d0
               beq       sd_done

	
               lea.l     phasecounter,a2       
               moveq     #0,d0                                                                                                                      
               move.w    (a2),d0
                                                                                                                                
               lea.l     phasepointer,a2                                                                                                            
               add.l     d0,a2
               move.l    (a2),d2                                                        ; load currrent phase

              ; move.l    #BULLET_PHASE_SIZE,d2
	
up0:
	;move sprite:
               lea.l     bullet_screen_x,a4
               moveq     #0,d4
               move.w    (a4),d4
               sub.w     virtualScreenPosX,d4

               sub.w     bullet_screen_x_move,d4
	
               lea.l     bullet_screen_y,a4
               moveq     #0,d5
               move.w    (a4),d5

               sub.w     virtualscreenPosY,d5

               move.w    d5,d6
               add.w     #BULLET_HEIGHT,d6
	
	
	;set sprite:
             ;move.w     (a3),d2
	
               lea.l     sprite0_0,a1                                                   ; put sprite address into a1
	;add.w	#4*152,a1
               add.l     d2,a1
	
               move.b    d4,1(a1)                                                       ; set x pos
               move.b    d5,(a1)                                                        ; set y pos
               move.b    d6,2(a1)                                                       ; set y pos + height
	
               lea.l     sp0,a2                                                         ; put copper address into a2
               move.l    a1,d1                                                          ; move sprite address into d1
               move.w    d1,6(a2)                                                       ; transfer sprite address high to copper
               swap      d1                                                             ; swap
               move.w    d1,2(a2)                                                       ; transfer sprite address low to copper

               lea.l     sprite1_0,a1                                                   ; put sprite address into a1
	;add.l	#4*152,a1
               add.l     d2,a1
               move.b    d4,1(a1)                                                       ; set x pos
               move.b    d5,(a1)                                                        ; set y pos
               move.b    d6,2(a1)                                                       ; set y pos + height
               lea.l     sp1,a2                                                         ; put copper address into a2
               move.l    a1,d1                                                          ; move sprite address into d1
               move.w    d1,6(a2)                                                       ; transfer sprite address high to copper
               swap      d1                                                             ; swap
               move.w    d1,2(a2)                                                       ; transfer sprite address low to copper
	
               add.w     bullet_screen_x_move,d4                                        ; shift 2 bytes for right part x+2
               add.w     bullet_screen_x_move,d4 
               lea.l     sprite0_1,a1   
             ;adda.l     #BULLET_PHASE_SIZE*6,a1                                                                                                    ; put sprite address into a1
	;add.l	#4*152,a1
               add.l     d2,a1
               move.b    d4,1(a1)                                                       ; set x pos
               move.b    d5,(a1)                                                        ; set y pos
               move.b    d6,2(a1)                                                       ; set y pos + height
               lea.l     sp2,a2                                                         ; put copper address into a2
               move.l    a1,d1                                                          ; move sprite address into d1
               move.w    d1,6(a2)                                                       ; transfer sprite address high to copper
               swap      d1                                                             ; swap
               move.w    d1,2(a2)                                                       ; transfer sprite address low to copper

               lea.l     sprite1_1,a1      
             ;adda.l     #BULLET_PHASE_SIZE*6,a1                                                                                                    ; put sprite address into a1
	;add.l	#4*152,a1
               add.l     d2,a1
               move.b    d4,1(a1)                                                       ; set x pos
               move.b    d5,(a1)                                                        ; set y pos
               move.b    d6,2(a1)                                                       ; set y pos + height
               lea.l     sp3,a2                                                         ; put copper address into a2
               move.l    a1,d1                                                          ; move sprite address into d1
               move.w    d1,6(a2)                                                       ; transfer sprite address high to copper
               swap      d1                                                             ; swap
               move.w    d1,2(a2)    
sd_done:                                                                                                               ; transfer sprite address low to copper
               rts
	
sprites_createBullet:
               move.w    bullet_active,d0
               tst.w     d0
               bne.s     sskip

               move.w    button_automatic,d0
               tst.w     d0
               beq.s     sskip
               move.w    #1,bullet_active
               
               move.w    virtualScreenPosX,d0
               add.w     #(virtualscreen_w+200)/4,d0
               move.w    d0,bullet_screen_x

               move.w    virtualscreenPosY,d0
               add.w     #(virtualscreen_h)/2,d0
               add.w     #BULLET_Y_START,d0
               move.w    d0,bullet_screen_y

               move.w    #BULLET_X_START,bullet_screen_x_move
               lea.l     laserSound,a0
               move.l    a0,soundEventPrio0
sskip:               
               rts

sprites_moveBullet:
               move.w    bullet_active,d0
               tst.w     d0
               beq       .done

               sub.w     #2,bullet_screen_y
               sub.w     #2,bullet_screen_x_move
               lea.l     phasecounter,a2
               add.w     #4,(a2)         
               moveq     #0,d2                                                          ; add next phase	
               move.w    (a2),d2                                                        ; get pointers
	
               lea.l     phasepointer,a4     
               adda.l    d2,a4                                                          ; load pointer to phases
               move.l    (a4),d2                                                        ; load currrent phase
	

               cmp.l     #-1,d2
               bne       .done                                                          ; animation not ended

               move.w    #0,(a2)  
               move.w    #0,bullet_active 
               move.w    virtualscreenPosY,d0
               add.w     #(virtualscreen_h)/2,d0
               add.w     #BULLET_Y_START,d0
               move.w    d0,bullet_screen_y
               bsr       sprites_init
.done:
               rts

blanksprite    ds.w      64