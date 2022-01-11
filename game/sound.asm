sound_test:  
  move.w    #$0001,$dff096                                                ; DMACON disable audio channel 0
                            
  lea.l     laser,a1                                                      ; move sample address into a1
  move.l    a1,$dff0a0                                                    ; AUD0LCH/AUD0LCL set audio channel 0 location to sample address
  ;move.w    #8,$dff0a4                                                    ; AUD0LEN set audio channel 0 length to 48452 words
  move.w    #13664,$dff0a4

  ;move.w    #0,$dff0a6                                                    ; AUD0PER set audio channel 0 period to 700 clocks (less is faster)
  move.w    #162,$dff0a6

  ;move.w    #0,$dff0a8                                                    ; AUD0VOL set audio channel 0 volume to 0
  move.w    #64,$dff0a8                                                    
                            
  move.w    #$8001,$dff096                                                ; DMACON enable audio channel 0
  rts
; and play

  lea.l     music,a1                                                      ; move music address into a1

smainloop:               ; begin mainloop
  bsr       swait                                                         ; branch to subroutine wait

  move.w    (a1)+,d1                                                      ; move value pointed to by a1 into d1 and increment a1 (word)
  move.w    d1,$dff0a6                                                    ; set AUD0PER to d1
  move.w    (a1)+,d2                                                      ; move value pointed to by a1 into d2 and increment a1 (word)
  move.w    d2,$dff0a8                                                    ; set AUD0VOL to d2

  cmp.w     #0,d1                                                         ; compare 0 with value in d1
  bne       smainloop                                                     ; if d1 != 0 goto mainloop
  cmp.w     #0,d2                                                         ; compare 0 with value in d2
  bne       smainloop                                                     ; if d2 != 0 goto mainloop

  move.w    #$0001,$dff096                                                ; DMACON disable audio channel 0
  rts                                                                     ; return from subroutine (exit program)

swait:                 ; wait subroutine - waits 5/50th of second
  moveq     #4,d1                                                         ; set wait counter to 4

swait2:                ; wait subroutine - waits 1/50th of a second 
  move.l    $dff004,d0                                                    ; read VPOSR and VHPOSR into d0 as one long word
  asr.l     #8,d0                                                         ; algorithmic shift right d0 8 bits
  and.l     #$1ff,d0                                                      ; add mask - preserve 9 LSB
  cmp.w     #200,d0                                                       ; check if we reached line 200
  bne       swait2                                                        ; if not goto wait
                      
swait3:                ; second wait - part of the wait subroutine
  move.l    $dff004,d0                                                    ; read VPOSR and VHPOSR into d0 as one long word
  asr.l     #8,d0                                                         ; algorithmic shift right d0 8 bits
  andi.l    #$1ff,d0                                                      ; add mask - preserve 9 LSB
  cmp.w     #201,d0                                                       ; check if we reached line 201
  bne       swait3                                                        ; if not goto wait2

  dbra      d1,swait2                                                     ; if wait counter > -1 goto wait2

  rts                                                                     ; return from wait subroutine

samplex:               ; sample of a sine wave defined by 16 values
  dc.b      0,40,90,110,127,110,90,40,0,-40,-90,-110,-127,-110,-90,-40

music:                ; pairs of period and volume - wait 1/10th second between pairs
  dc.w      428,64,428,64                                                 ; C2, C2 at max volume
  dc.w      428,0                                                         ; C2 at min volume
  dc.w      381,64,381,64                                                 ; D2, D2 at max volume
  dc.w      381,0                                                         ; D2 at min volume
  dc.w      339,64,339,64                                                 ; E2, E2 at max volume
  dc.w      339,0                                                         ; E2 at min volume 
  dc.w      320,64,320,64                                                 ; F2, F2 at max volume
  dc.w      320,0                                                         ; F2 at min volume
  dc.w      285,64,285,64                                                 ; G2, G2 at max volume
  dc.w      285,0                                                         ; G2 at min volume
  dc.w      254,64,254,64                                                 ; A2, A2 at max volume
  dc.w      254,0                                                         ; A2 at min volume
  dc.w      226,64,226,64                                                 ; H2, H2 at max volume
  dc.w      226,0                                                         ; H2 at min volume
  dc.w      214,64,214,64,214,64                                          ; C3, C3, C3 at max volume
  dc.w      214,0,214,0,214,0                                             ; C3, C3, C3 at min volume

  dc.w      214,64                                                        ; C3 at max volume
  dc.w      226,64                                                        ; H2 at max volume
  dc.w      254,64                                                        ; A2 at max volume
  dc.w      285,64                                                        ; G2 at max volume
  dc.w      320,64                                                        ; F2 at max volume
  dc.w      339,64                                                        ; E2 at max volume
  dc.w      381,64                                                        ; D2 at max volume
  dc.w      428,64,428,64,428,64                                          ; C2, C2, C2 at max volume

  dc.w      428,0,428,0,428,0                                             ; C2, C2, C2 at min volume
  dc.w      856,64,856,64,856,64                                          ; C1, C1, C1 at max volume 

  dc.w      0,0                                                           ; end of music is set by the zero pair



saddrTable:
;  dc.l      s_Catch,s_Brick1,s_Exp1,s_WarpIn,s_Dink,s_ShiftQ
;  dc.l      s_CylCatch1,s_Piew2,s_Bonk,s_Dink,s_Piew,s_ShiftQ
;  dc.l      s_CylCatch1,blksnd,blksnd,blksnd,blksnd,s_ExpBrick

slenTable:
;  dc.l      ends_Catch-s_Catch,ends_Brick1-s_Brick1,ends_Exp1-s_Exp1
;  dc.l      ends_WarpIn-s_WarpIn,ends_Dink-s_Dink
;  dc.l      ends_ShiftQ-s_ShiftQ,ends_CylCatch1-s_CylCatch1
;  dc.l      ends_Piew2-s_Piew2,ends_Bonk-s_Bonk,ends_Dink-s_Dink
;  dc.l      ends_Piew-s_Piew,10000,ends_CylCatch1-s_CylCatch1
;  dc.l      16,16,16,16,ends_ExpBrick-s_ExpBrick

sperTable:   ;3579546/Saples_per_sec
  dc.w      856,340,428,428,329,390,568,600,334,284,246,390,1712
  dc.w      4000,4000,4000,4000
