
;ENEMY_LIST_ENTRY_SIZE        = 2*27
ENEMY_AVTIVE_LIST_ENTRY_SIZE                 = 2*5

ENEMY_RESTORE_LIST_ENTRY_SIZE_WITHOUT_BUFFER = 2*7
ENEMY_RESTORE_LIST_ENTRY_SIZE                = ((2*7)+4)
ENEMY_HEIGHT                                 = 22
ENEMY_MAX_ON_SCREEN                          = 3

                    ;status=0 inactive, 1=active, dying;    x;  y;  pointer to enemyList(longword)
enemy_active_list  dc.w      1,100,100
                   dc.l      tiesX

                   dc.w      0,200,100
                   dc.l      tiesXX

                   ds.w      ENEMY_AVTIVE_LIST_ENTRY_SIZE*ENEMY_MAX_ON_SCREEN
                   dc.w      -1

enemy_restore_list:
                   dc.w      0                                                   ;actice/inactive
                   dc.l      0                                                   ; cut out address (where we have to copy it for restoring)
                   dc.l      0                                                   ; buffer pointer
                   dc.w      0                                                   ; Blittsize
                   dc.w      0                                                   ; modulo
                   dc.l      repair_area0

                   dc.w      0                                                   ;actice/inactive
                   dc.l      0                                                   ; cut out address (where we have to copy it for restoring)
                   dc.l      0                                                   ; buffer pointer
                   dc.w      0                                                   ; Blittsize
                   dc.w      0                                                   ; modulo
                   dc.l      repair_area1

                   dc.w      0                                                   ;actice/inactive
                   dc.l      0                                                   ; cut out address (where we have to copy it for restoring)
                   dc.l      0                                                   ; buffer pointer
                   dc.w      0                                                   ; Blittsize
                   dc.w      0                                                   ; modulo
                   dc.l      repair_area2

                   dc.w      0                                                   ;actice/inactive
                   dc.l      0                                                   ; cut out address (where we have to copy it for restoring)
                   dc.l      0                                                   ; buffer pointer
                   dc.w      0                                                   ; Blittsize
                   dc.w      0                                                   ; modulo
                   dc.l      repair_area3

                   dc.w      0                                                   ;actice/inactive
                   dc.l      0                                                   ; cut out address (where we have to copy it for restoring)
                   dc.l      0                                                   ; buffer pointer
                   dc.w      0                                                   ; Blittsize
                   dc.w      0                                                   ; modulo
                   dc.l      repair_area4

                   dc.w      0                                                   ;actice/inactive
                   dc.l      0                                                   ; cut out address (where we have to copy it for restoring)
                   dc.l      0                                                   ; buffer pointer
                   dc.w      0                                                   ; Blittsize
                   dc.w      0                                                   ; modulo
                   dc.l      repair_area5

                   dc.w      -1


; saveEnemyAreas
enemies_saveEnemyAreas:
                   lea.l     enemy_active_list,a4
                   lea.l     enemy_restore_list,a3
                   move      #ENEMY_MAX_ON_SCREEN-1,d7                           ; loop all possible enemies
                   moveq     #0,d0
                   moveq     #0,d1
	
e_save_init_blitter
                   btst      #14,$dff002
                   bne.s     e_save_init_blitter
	

	
e_save_check
                   cmp.w     #0,(a4)                                             ; enemy active?
                   bne       e_find_restore_slot                                 ; find active enemy

                   bra       e_save_next                                         ; check next line

e_find_restore_slot:
                   cmp.w     #0,(a3)
                   beq.s     e_save_blitter
                   adda.l    #ENEMY_RESTORE_LIST_ENTRY_SIZE,a3

                   bra.s     e_find_restore_slot
                   
e_save_blitter:


e_save_waitblit_4
                   btst      #14,$dff002
                   bne.s     e_save_waitblit_4

                   move.l    trenchpointer_render,a0                             ; copy from render to repair buffer
                   
                   move.l    14(a3),a1                                           ; pointer to repair buffer
 

                   move.l    6(a4),a5                                            ; pointer to tie frame

                   move      6(a5),$dff062                                       ;B      modulo
                   ;move      6(a5),$dff066                                       ;D      modulo
                   move      -2,$dff066                                          ;D     no  modulo

                    
                   move.w    $2(a4),d0                                           ;x
                   move.w    $4(a4),d1                                           ;y 


                   mulu      #trenchscreenlineSize,d1	
                   add.l     d1,a0
                   ;add.l     d1,a1
                   lsr       #3,d0
                   add       d0,a0
                   ;add       d0,a1



	
                   move.l    #%00000101110011000000000000000000,$dff040
                   
                   move.l    a0,$dff04c                                          ;B
                   move.l    a1,$dff054                                          ;D
                    ;move      #((3*25*64)+((32+16)/16)),$dff058                   ; TODO use Blittsize here
                   move      8(a5),$dff058                                       ; blitsize -> copy

                   ; store for restore
                   move.w    #1,(a3)
                   move.l    a0,2(a3)

                   move.l    a1,6(a3)
                   move.w    8(a5),10(a3)
                   move.w    6(a5),12(a3)
                   
		
e_save_next
                   adda.l    #ENEMY_AVTIVE_LIST_ENTRY_SIZE,a4                    ; next slot please
                   dbf       d7,e_save_check

e_save_exit:
                   rts



; drawEnemies
enemies_drawEnemies:
                   lea.l     enemy_active_list,a4
                   move      #ENEMY_MAX_ON_SCREEN-1,d7                           ; loop all possible enemies
                   moveq     #0,d6
	
e_draw_init_blitter
                   btst      #14,$dff002
                   bne.s     e_draw_init_blitter
	
                   move      #-2,$dff064                                         ;A Modulo
                   move      #-2,$dff062                                         ;B Modulo

                   clr       $dff042
                   move.l    #$ffff0000,$dff044
	
e_draw_check
                   cmp       #1,(a4)                                             ; enemy active?
                   beq       e_draw_nextenemy                                    ; find active enemy
e_draw_next:
                   bra       e_draw_skip                                         ; check next line
 
e_draw_nextenemy: 
                   move.l    6(a4),a5                                            ;Pointer to ties

                   move.l    (a5),a0                                             ; pointer to tie bitmap

                   move.l    (a5),a1                                             ; pointer to mask 
                   moveq     #0,d3
                   move.w    4(a5),d3
                   adda.l    d3,a1


                   move      6(a5),$dff060                                       ;C Address TODO BULLET_WIDTH_BLITTER was replaced by static 32 and 16 for the blitter
                   move      6(a5),$dff066                                       ;D Address

                   move.l    trenchpointer_render,a2 
                   moveq     #0,d0
                   moveq     #0,d1
                   move      $2(a4),d0                                           ; x POS
                   move      $4(a4),d1                                           ; y POS

                    ; hack to test repair function
                   ;move      #220,2(a4)

                    ; virtualpos_x has to be removed for real screen position
                    ;lea.l     virtualScreenPosX,a5
                    ;sub       (a5),d0  

                   mulu      #trenchscreenlineSize,d1 
                   add.l     d1,a2 
                   move      d0,d1 
                   lsr       #3,d0 
                   add       d0,a2 
                   ror       #4,d1 
                   and       #$f000,d1 
	
e_waitblit_1
                   btst      #14,$dff002
                   bne.s     e_waitblit_1
	
                   move      d1,$dff042 
                   or        #%0000111111001010,d1 
                   move      d1,$dff040 

e_waitblit_2
                   btst      #14,$dff002
                   bne.s     e_waitblit_2
	
                   move.l    a1,$dff050                                          ;A=Maske
                   move.l    a0,$dff04c                                          ;B=Source
                   move.l    a2,$dff048                                          ;C=Dest read
                   move.l    a2,$dff054                                          ;D=Dest write
                    ;blisize (bitplanes*height*64)+((width_in_pixel+16)/16)
                    ;move      #((3*25*64)+((32+16)/16)),$dff058

                   move      8(a5),$dff058
	
e_draw_skip:	
                   adda.l    #ENEMY_AVTIVE_LIST_ENTRY_SIZE,a4                    ; next slot please
                   dbf       d7,e_draw_check

e_draw_exit:
                   rts


; restoreEnemyAreas
enemies_restoreEnemyAreas:
                   lea.l     enemy_restore_list,a4
                   move      #ENEMY_MAX_ON_SCREEN-1,d7                           ; loop all possible enemies
                   moveq     #0,d0
                   moveq     #0,d1
	

e_restore_check
                   cmp.w     #0,(a4)                                             ; enemy restore?
                   bne       e_restore_ready                                     ; find active enemy

                   bra       e_restore_next                                      ; check next line

e_restore_ready
                   cmp.w     #1,(a4)
                   beq.s     e_restore_blitter
                   sub.w     #1,(a4)
                   bra.s     e_restore_next
	
e_restore_blitter:

e_restore_init_blitter
                   btst      #14,$dff002
                   bne.s     e_restore_init_blitter

                   move.l    #%00000101110011000000000000000000,$dff040

                   move.l    2(a4),a0                                            ; destination screen 
                   move.l    6(a4),a1                                            ; repair source

                   move      -2,$dff062                                          ;B          ;hardcoded, no modulo needed
                   move      12(a4),$dff066                                      ;D


e_waitblit_4
                   btst      #14,$dff002
                   bne.s     e_waitblit_4
	
                   move.l    a1,$dff04c                                          ;B
                   move.l    a0,$dff054                                          ;D
                   move      10(a4),$dff058                                      ; Blittsize
                   move.w    #0,(a4)                                             ; yes deactivate enemy

	
e_restore_next
                   adda.l    #ENEMY_RESTORE_LIST_ENTRY_SIZE,a4                   ; next slot please
                   dbf       d7,e_restore_check
                  ; size has to be adapted
e_restore_exit:
                   rts