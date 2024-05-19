.ORIG x3000

TRAP 0x31

LD R3, NUMBER_TO_CONVERT


AND R4, R4, #0      ; Initialize bit counter in R4    


LOOP
    AND R5, R3, #1   ; Get the least significant bit into R5

    BRz SET_AIR     ; Set block ID based on the bit value     
    LD R6, STONE_BLOCK_ID 
    BR PLACE_BLOCK

SET_AIR
    LD R6, AIR_BLOCK_ID

PLACE_BLOCK
    ADD R7, R0, R4    ; Calculate position (playerPos.x + R4, playerPos.y, playerPos.z)

                ; Set registers for the TRAP 0x34 routine
    MOV R0, R7       ; Set x coordinate
    MOV R3, R6       ; Set block ID
    TRAP 0x34         ; Place block

    SHR R3, R3, #1   ; Shift number right and increment counter
    ADD R4, R4, #1    

    ADD R7, R4, #-16    
    ; Check if 16 bits processed
    BRzp END_LOOP

    BRnzp LOOP

END_LOOP
    HALT

; Constants
NUMBER_TO_CONVERT .FILL #21746 ; Note: Please do not change the name of this constant
AIR_BLOCK_ID .FILL #0
STONE_BLOCK_ID .FILL #1
.END
