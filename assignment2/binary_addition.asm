.ORIG x3000

TRAP 0x31

                ; Initialize pointers for reading and writing
ADD R7, R0, #1        ; R7 = playerPos.x + 1
ADD R6, R2, #1        ; R6 = playerPos.z + 1 (first number)
ADD R5, R2, #2        ; R5 = playerPos.z + 2 (second number)
ADD R4, R2, #3        ; R4 = playerPos.z + 3 (result)


AND R1, R1, #0       ; Clear R1
AND R2, R2, #0       ; Clear R2


LD R3, ONE           

READ_FIRST
    ADD R0, R7, R4     ; Set x coordinate
    MOV R2, R6         ; Set z coordinate
    TRAP 0x33          ; Get block ID
    BRz FIRST_NEXT     ; If air, skip
    ADD R1, R1, R3     ; Add bit to first number

FIRST_NEXT
    ADD R7, R7, #1     ; Move to next block
    ADD R3, R3, R3     ; Shift mask left
    ADD R4, R4, #-1    ; Decrement counter
    BRp READ_FIRST

ADD R7, R0, #1         ; Reset x coordinate
LD R3, ONE             ; Reset mask
ADD R4, R4, #16        ; Reset counter

READ_SECOND
    ADD R0, R7, R4     ; Set x coordinate
    MOV R2, R5         ; Set z coordinate
    TRAP x33           ; Get block ID
    BRz SECOND_NEXT    ; If air, skip
    ADD R2, R2, R3     ; Add bit to second number

SECOND_NEXT
    ADD R7, R7, #1     ; Move to next block
    ADD R3, R3, R3     ; Shift mask left
    ADD R4, R4, #-1    ; Decrement counter
    BRp READ_SECOND

ADD R3, R1, R2          ; Sum = R1 + R2

                ;Result
AND R2, R2, #0          ; Clear R2
ADD R7, R0, #1          ; Reset x coordinate
LD R3, ONE              ; Reset mask
ADD R4, R4, #16         ; Reset counter

WRITE_RESULT
    AND R1, R3, R2       ; Extract bit
    BRz WRITE_AIR        ; If 0, write air
    LD R1, STONE_BLOCK_ID   ; Write stone
    BRnzp PLACE_BLOCK

WRITE_AIR
    LD R1, AIR_BLOCK_ID

PLACE_BLOCK
    ADD R0, R7, R4     ; Set x coordinate
    MOV R3, R1         ; Set block ID
    TRAP x34           ; Place block
    ADD R3, R3, R3     ; Shift mask left
    ADD R4, R4, #-1    ; Decrement counter
    BRp WRITE_RESULT

HALT

; Constants
ONE .FILL #1
AIR_BLOCK_ID .FILL #0
STONE_BLOCK_ID .FILL #1

.END
