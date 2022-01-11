

screen_swap:
  lea.l      RENDER,a0
  lea.l      SHOW,a5
  move.l     (a0),d0                      ;RENDER-> d0
  move.l     (a5),(a0)                    ;SHOW->RENDER
  move.l     d0,(a5)                      ;d0->SHOW
  rts
	
screen_scroll:	
  lea.l      SHOW,a0
  move.l     (a0),d0                      ;SHOW-> d0
	;do scrolling
  lea.l      virtualscreenPosY,a5         ;Y Pos
  move.w     (a5),d1
  mulu.w     #3*(virtualscreen_w/8),d1
  add.l      d1,d0
	
  lea.l      virtualScreenPosX,a5         ;X Pos
  move       (a5),d2                      ; X Position of screen 
  add        #$f,d2                       ; d2 = X+15
  moveq      #-1,d3	 
  sub.b      d2,d3                        ; d3 = -1-(X+15)
  and.b      #$f,d3                       ; d3 = (-1-(X+15))&15 = BPLC0N1
	
  move.b     d3,d4
  lsl.b      #4,d4
  or.b       d4,d4

; fix flickering
;  cmp.b      #$f,d3
;  bne        s_correction
 ; move.b     #$0,d3
	
s_correction:
  move.b     d3,scrollH+3
	
; fix done 

;	lsl.b #4,d3
;	or.b d3,scrollH+3 	; Verschiebung fuer ungerade Planes  (background)
	
  lsr        #4,d2                        ; d2 = (X-15)/16 = zu addierende Words
  add        d2,d2                        ; d2 = zu addierende Bytes fuer X
  add        d2,d0                        ; d2 = zu addierende Bytes fuer X+Y
	;end scrolling
	
	
  lea        copperMainScreen(pc),a0
  moveq      #2,d7 
ss1:
  move       d0,6(a0) 
  swap       d0 
  move       d0,2(a0) 
  swap       d0 
  add.l      #virtualscreen_w/8,d0 
  addq.l     #8,a0 
  dbf        d7,ss1
	
	;done not set para screen (d3=foreground playfield)
  bsr        ss2_moveparascreen
	
  rts
	

ss2_moveparascreen:
;cloudsA
  lea.l      cloud1(pc),a0	
  adda.l     #4,a0                        ;skip copper wait instruction
  lea        cloud1_0,a1
  move.l     a1,d0
  moveq      #2,d7                        ; number of bitplanes -1
	
	
  lea.l      paraClouds0X(pc),a3
  moveq      #0,d5                        ; clean up
  move.w     (a3),d5                      ; para x pos
  lsl.w      #1,d5                        ; load offset in bytes (*2)
  lea.l      paraOffsetClouds0,a2         ; load offsets 
  adda.l     d5,a2                        ; pointer to correct offset	(column)
  moveq      #0,d4                        ; clean up
  move.b     (a2),d4                      ; load offset
  move.b     1(a2),d5                     ;d5 reuse for vertical pos
  lsl.b      #4,d5
  and.b      #$000F,d3                    ;delete hi bits
  or.b       d5,d3                        ;add new hi bits	
  add.l      d4,d0                        ;y offset
	
sscA_para:
  move       d0,6(a0) 
  swap       d0 
  move       d0,2(a0) 
  swap       d0
  add.l      #parabitplanesize_a,d0 
  addq.l     #8,a0 
  dbf        d7,sscA_para	
  move.b     d3,3(a0)
	
	
	
;cloudsB
  lea.l      cloud2(pc),a0	
  adda.l     #4,a0                        ;skip copper wait instruction
  lea        cloud2_0,a1
  move.l     a1,d0
  moveq      #2,d7                        ; number of bitplanes -1
	
  lea.l      paraClouds1X(pc),a3
  moveq      #0,d5                        ; clean up
  move.w     (a3),d5                      ; para x pos
  lsl.w      #1,d5                        ; load offset in bytes (*2)
  lea.l      paraOffsetClouds1,a2         ; load offsets 
  adda.l     d5,a2                        ; pointer to correct offset	(column)
  moveq      #0,d4                        ; clean up
  move.b     (a2),d4                      ; load offset
  move.b     1(a2),d5                     ;d5 reuse for vertical pos
  lsl.b      #4,d5
  and.b      #$000F,d3                    ;delete hi bits
  or.b       d5,d3                        ;add new hi bits	
  add.l      d4,d0                        ;y offset
	
sscB_para:
  move       d0,6(a0) 
  swap       d0 
  move       d0,2(a0) 
  swap       d0
  add.l      #parabitplanesize_b,d0 
  addq.l     #8,a0 
  dbf        d7,sscB_para	
  move.b     d3,3(a0)
	
;mountain
  lea.l      mountain(pc),a0	
  adda.l     #4,a0                        ;skip copper wait instruction
  lea        mountain_0,a1
  move.l     a1,d0
  moveq      #2,d7                        ; number of bitplanes -1
	
  lea.l      paraMountainX(pc),a3
  moveq      #0,d5                        ; clean up
  move.w     (a3),d5                      ; para x pos
  lsl.w      #1,d5                        ; load offset in bytes (*2)
  lea.l      paraOffsetMountain,a2        ; load offsets 
  adda.l     d5,a2                        ; pointer to correct offset	(column)
  moveq      #0,d4                        ; clean up
  move.b     (a2),d4                      ; load offset
  move.b     1(a2),d5                     ;d5 reuse for vertical pos
  lsl.b      #4,d5
  and.b      #$000F,d3                    ;delete hi bits
  or.b       d5,d3                        ;add new hi bits	
  add.l      d4,d0                        ;y offset
	
sscM_para:
  move       d0,6(a0) 
  swap       d0 
  move       d0,2(a0) 
  swap       d0
  add.l      #parabitplanesize_m,d0 
  addq.l     #8,a0 
  dbf        d7,sscM_para	
  move.b     d3,3(a0)

;landscape
  lea.l      parascroll(pc),a0	
  adda.l     #4,a0                        ;skip copper wait instruction
	
  lea.l      paraScreenPosX(pc),a3
  moveq      #0,d5                        ; clean up
  move.w     (a3),d5                      ; para x pos
  lsl.w      #1,d5                        ; load offset in bytes (*2)
	
  lea.l      paraOffset,a2                ; load offsets 
	
  adda.l     d5,a2                        ; pointer to correct offset	(column)
  moveq      #0,d4                        ; clean up
  move.b     (a2),d4                      ; load offset
	
  move.b     1(a2),d5                     ;d5 reuse for vertical pos
  lsl.b      #4,d5
  and.b      #$000F,d3                    ;delete hi bits
	
  or.b       d5,d3                        ;add new hi bits
	
	
  lea        para0,a1
  move.l     a1,d0
  add.l      d4,d0                        ; add y offset
	
  moveq      #2,d7                        ; number of bitplanes -1
  moveq      #99,d6                       ; number of para lines-1
	

ss3_para:
  move       d0,6(a0) 
  swap       d0 
  move       d0,2(a0) 
  swap       d0
  add.l      #parabitplanesize_l,d0 
  addq.l     #8,a0 
  dbf        d7,ss3_para
	
  move.b     d3,3(a0)                     ; set vertical offset (here: only foreground playfield so far)
	
  moveq      #2,d7                        ; number of para lines-1
  suba.l     #3*8,a0                      ; correct pointer to copper list
  adda.l     #paracopperlinesize,a0       ; next line

  sub.l      #3*parabitplanesize_l,d0     ; correct pointer to para bitplane
  add.l      #parallaxscreen_w/8,d0       ; next line
	
	;Y
  sub.l      d4,d0                        ; sub old offset
  adda.l     #320,a2                      ; point to new offset (next offset line)
  move.b     (a2),d4                      ; load new offset
  add.l      d4,d0
	
	;X 
  move.b     1(a2),d5                     ;d5 reuse for vertical pos	
  lsl.b      #4,d5
  and.b      #$000F,d3                    ;delete hi bits
  or.b       d5,d3                        ;add new hi bits
	
  dbf        d6,ss3_para
  rts

screen_init:
  moveq      #0,d0
  moveq      #0,d1
  moveq      #20,d3                       ; virtualscreen_w/16

i_1:	
  lea.l      level1,a0
  lea.l      SCREEN0,a1
  lea.l      SCREEN0,a2
  lea.l      SCREEN0,a3
  adda.l     d1,a0
  adda.l     d0,a1
  adda.l     d0,a2
  adda.l     d0,a3
  bsr        p_addTilesToScreen
  lea.l      level1,a0
  lea.l      SCREEN1,a1
  lea.l      SCREEN1,a2
  lea.l      SCREEN1,a3
  adda.l     d1,a0
  adda.l     d0,a1
  adda.l     d0,a2
  adda.l     d0,a3
  bsr        p_addTilesToScreen
  lea.l      level1,a0
  lea.l      SCREENR,a1
  lea.l      SCREENR,a2
  lea.l      SCREENR,a3
  adda.l     d1,a0
  adda.l     d0,a1
  adda.l     d0,a2
  adda.l     d0,a3
  bsr        p_addTilesToScreen
	
  add.w      #2,d0                        ;next screen column
  add.w      #26*2,d1                     ;next level column

  dbf        d3,i_1
  rts


screen_update:
	;find level map tile column
  lea.l      levelPosX,a0
  moveq      #0,d1
  move.w     #screenwidth+16,d1           ;take first level column outside screen 
  add.w      (a0),d1
  lsr.w      #4,d1                        ; levelPosX/16 -> offset
  mulu.w     #4*13,d1                     ; offset(long words=4 byte) * level column size
	
  lea.l      virtualScreenPosX,a0         ; find position/column on virtual screen
  moveq      #0,d0
  move.w     (a0),d0
  add.w      #screenwidth+16,d0
	;cmp.w  #virtualscreen_w,d0	; still in virtualScreen?
	;ble	   up1					; yes
	;sub.w  #virtualscreen_w,d0	; no -> go to start pos of virtualScreen
	
up1:
  move.w     d0,d2                        ;only every 16 pixels
  and.w      #$000f,d2
  cmp.w      #0,d2
  bne        up3_updateSkip               ; skip it
  lsr.w      #3,d0                        ;offset in bytes; order bytes? aber nur alle 16 pixel bzw. alle words
	
  lea.l      level1,a0
  lea.l      SCREEN0,a1
  lea.l      SCREEN0,a2
  lea.l      SCREEN0,a3
  adda.l     d1,a0
  adda.l     d0,a1
  adda.l     d0,a2
  adda.l     d0,a3
  bsr        p_addTilesToScreen
  lea.l      level1,a0                    ;TODO: copy by blitter
  lea.l      SCREEN1,a1
  lea.l      SCREEN1,a2
  lea.l      SCREEN1,a3
  adda.l     d1,a0
  adda.l     d0,a1
  adda.l     d0,a2
  adda.l     d0,a3
  bsr        p_addTilesToScreen
  lea.l      level1,a0                    ;TODO: copy by blitter
  lea.l      SCREENR,a1
  lea.l      SCREENR,a2
  lea.l      SCREENR,a3
  adda.l     d1,a0
  adda.l     d0,a1
  adda.l     d0,a2
  adda.l     d0,a3
  bsr        p_addTilesToScreen
	
up3_updateSkip:	
  rts
	



p_addTilesToScreen:
  adda.l     #(virtualscreen_w/8),a2
  adda.l     #(virtualscreen_w/8)*2,a3
	
	
		
p_getTile:
  move.l     (a0)+,d5                     ; read tiles offset
  cmp.l      #-1,d5                       ; empty tile?
  bne        p_loadtile                   ; not please draw tile
	
  bra        p_loademptytile              ; ok draw empty tile
	;adda.l #virtualscreen_w/8*16,a1
	;adda.l #virtualscreen_w/8*16,a2
	;adda.l #virtualscreen_w/8*16,a3	
  bra        p_getTile                    ; get next		

p_loadtile:	
  lea.l      tiles,a5                     ; load tile address
  adda.l     d5,a5                        ; add offset
  moveq      #31,d7
	
p_copyTile:
  move.w     (a5),(a1)                    ; first line
  move.w     $2(a5),(a2)                  ; second line
  move.w     $4(a5),(a3)                  ; third line^

  adda.l     #3*(virtualscreen_w/8),a1
  adda.l     #3*(virtualscreen_w/8),a2
  adda.l     #3*(virtualscreen_w/8),a3
  adda.l     #6,a5                        ; 2 byte* 3 bitmaps
  dbf        d7,p_copyTile
  cmp.l      #-2,(a0)
  bne        p_getTile
  rts
	
p_loademptytile:	
	;moveq  #0,d4	; empty 
  moveq      #31,d7
	
p_copyemptyTile:
  move.w     #0,(a1)
  move.w     #0,(a2)
  move.w     #0,(a3)
  adda.l     #3*(virtualscreen_w/8),a1
  adda.l     #3*(virtualscreen_w/8),a2
  adda.l     #3*(virtualscreen_w/8),a3
  dbf        d7,p_copyemptyTile
  cmp.l      #-2,(a0)
  bne        p_getTile
  rts
	
	
screen_swapAndCopyCopper
	
  lea.l      COPPER_BUF,a0
  lea.l      COPPER_SHOW,a1
  move.l     (a0),d0                      ;BUF-> d0
  move.l     (a1),(a0)                    ;SHOW->BUF
  move.l     d0,(a1)                      ;d0->SHOW
	
							; put copper address into a1
  move.l     (a1),$dff080                 ; COP1LCH (also sets COP1LCL)

  movea.l    (a0),a1 BUF to a1

	
  lea.l      copper,a0
	
  lea.l      COPPER_BUF,a1
  move.l     (a1),a1
		
coCo:
  move.l     (a0)+,(a1)+
  cmp.l      #$fffffffe,(a0)
  bne        coCo
  move.l     (a0)+,(a1)+                  ;last longword
	
	;lea.l COPPER_BUF,a1
	;move.l  (a1),$dff080
  rts
	
screen_initFooter:
  lea.l      copper_footer(pc),a0	
  lea        footer_0,a1
  suba.l     #2,a1                        ; correction of x position
  move.l     a1,d0
  moveq      #4,d7                        ; number of bitplanes -1
	
ssc_footer:
  move       d0,6(a0) 
  swap       d0 
  move       d0,2(a0) 
  swap       d0
  add.l      #((320/8)*40),d0 
  addq.l     #8,a0 
  dbf        d7,ssc_footer	
  rts