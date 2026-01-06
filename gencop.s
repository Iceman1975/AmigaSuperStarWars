	; mc0501
  INCDIR     "include"
  include    "include/hw.i"
	
  SECTION    ChipData,  DATA_C

screenwidth          = 320
screenheight         = 256

virtualscreen_w      = 304
virtualscreen_h      = 200
virtualbitplanesize  = (virtualscreen_w/8)*virtualscreen_h
virtualscreensize    = virtualbitplanesize*3     

trenchscreen_w       = 384
trenchscreen_h       = 326
trenchbitplanesize   = (trenchscreen_w/8)*trenchscreen_h
trenchscreensize     = trenchbitplanesize*3               ; 3 bitplanes
trenchscreenlineSize = (3*(trenchscreen_w/8))


  ;move.w     #$4000,$dff09a                               ; POTINP - clear external interrupt

  ;or.b       #%10000000,$bfd100                           ; CIABPRB stops drive motors  and.b      #%10000111,$bfd100                           ; CIABPRB

  move.w     #%0011111111111111,$dff09a
  ;move.w    #%0001111111111111,$dff09a          ; 2. try

  or.b       #%10000000,$bfd100                           ; CIABPRB stops drive motors
  and.b      #%10000111,$bfd100                           ; CIABPRB


  LEA        CUSTOM,a6                                    ;Point a0 at custom chips

  move.w     #$01a0,$dff096                               ; DMACON clear bitplane, copper, sprite

	;move.w  #$1200,$dff100 ; BPLCON0 one bitplane, color burst
  move.w     #$6600,BPLCON0(a6)                           ; BPLCON0 6 bitplanes, color burst, dual playfield
  move.w     #$0000,$dff102                               ; BPLCON1 scroll
  move.w     #$003f,$dff104                               ; BPLCON2 video


  move.w     #$3081,DIWSTRT(a6)
  move.w     #$30c1,DIWSTOP(a6)
  move.w     #$30,DDFSTRT(a6)
  move.w     #$d0,DDFSTOP(a6)

  ;bsr        screen_init
  bsr        screen_init_cockpit
  bsr        screen_scroll
  bsr        sound_init
  bsr        sprites_init
  bsr        sprites_drawBullet

  lea.l      copper,a1                                    ; put copper address into a1
  move.l     a1,$dff080                                   ; COP1LCH (also sets COP1LCL)
  move.w     $dff088,d0                                   ; COPJMP1 
  move.w     #$81a0,$dff096                               ; DMACON set bitplane, copper, sprite


	;bsr bullet_create
	
wait:              	   ; wait until at beam line 0
  move.l     $dff004,d0                                   ; read VPOSR and VHPOSR into d0 as one long word
  asr.l      #8,d0                                        ; shift right 8 places
  and.l      #$1ff,d0
  cmp.w      #0,d0
  bne        wait                                         ; if not equal jump to wait

wait2:             ; wait until at beam line 1
  move.l     $dff004,d0                                   ; read VPOSR and VHPOSR into d0 as one long word
  asr.l      #8,d0
  and.l      #$1ff,d0
  cmp.w      #1,d0
  bne        wait2                                        ; if not equal jump to wait



	
	
;  lea        enemy_active_list,a1
;  move.l     6(a1),d0
;  lea.l      tiesX,a0
;  cmp.l      a0,d0
;  beq.s      .s
;  add.l      #10,6(a1)
;  bra.s      .ss
;.s:
;  lea.l      ties,a0
 ; move.l     a0,6(a1)
;.ss:

  bsr        screen_init
  bsr        screen_scroll
  bsr        screen_nextTrenchFrame

 ; move.w     trenchframecounter,d0
  ;tst.w      d0
  ;bne.s      .noFrameChange
  bsr        enemies_restoreEnemyAreas
  bsr        enemies_saveEnemyAreas
  bsr        enemies_drawEnemies
;.noFrameChange
  
  bsr        sprites_createBullet
  bsr        sprites_moveBullet
  bsr        sprites_drawBullet
  bsr        sound_update
 

  bsr        joystick
  bsr        move_cockpit
  bra        wait



;**** current end
	

  move.w     #$0080,$dff096                               ; reestablish DMA's and copper

  move.l     $04,a6
  move.l     156(a6),a1
  move.l     38(a1),$dff080

  move.w     #$8080,$dff096

  move.w     #$c000,$dff09a
  rts






  include    "game/screen.asm"
  include    "game/joystick.asm"
  include    "game/sound.asm"
  include    "game/enemies.asm"
  include    "game/sprites.asm"
  include    "game/ptplayer.asm"
	

  section    bitmapdata,data,chip
  		               
  include    "game/data/chipMem_trench_imagedata.asm"
trenchend:

cockpit_plus:
  ds.b       virtualscreen_w/8*3*20                       ; 20 empty lines
  include    "game/data/chipMem_enemies_imagedata.asm"
  include    "game/data/chipMem_bullet_sprites.asm"
  include    "game/data/chipMem_tie.asm"
  include    "game/data/chipMem_sounds.asm"

lastAddress:   




        
