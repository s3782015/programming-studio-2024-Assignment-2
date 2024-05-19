.ORIG x3000

TRAP 0x31

LD R3, G_X 
LD R4, G_Y
LD R5, G_Z

                ; Calculate |playerPos.x - G_X|
NOT R6, R0          ; R6 = -playerPos.x
ADD R6, R6, #1
ADD R6, R6, R3      ; R6 = G_X - playerPos.x
BRzp POS_X
NOT R6, R6          ; R6 = |playerPos.x - G_X|
ADD R6, R6, #1
POS_X 

                ; Calculate |playerPos.y - G_Y|
NOT R7, R1          ; R7 = -playerPos.y
ADD R7, R7, #1
ADD R7, R7, R4         ; R7 = G_Y - playerPos.y
BRzp POS_Y
NOT R7, R7             ; R7 = |playerPos.y - G_Y|
ADD R7, R7, #1
POS_Y

                ; Calculate |playerPos.z - G_Z|
NOT R8, R2          ; R8 = -playerPos.z
ADD R8, R8, #1  
ADD R8, R8, R5      ; R8 = G_Z - playerPos.z
BRzp POS_Z
NOT R8, R8          ; R8 = |playerPos.z - G_Z|
ADD R8, R8, #1
POS_Z

                ; Calculate dmanhattan = |playerPos.x - G_X| + |playerPos.y - G_Y| + |playerPos.z - G_Z|
ADD R6, R6, R7      ; R6 = |playerPos.x - G_X| + |playerPos.y - G_Y|
ADD R6, R6, R8      ; R6 = dmanhattan


LD R9, GOAL_DIST    ; Load GOAL_DIST into R9


NOT R9, R9      ; Compare dmanhattan with GOAL_DIST
ADD R9, R9, #1
ADD R6, R6, R9    ; R6 = dmanhattan - GOAL_DIST
BRzp WITHIN_DIST


LEA R0, OUTSIDE_MSG
TRAP 0x30         ; Post to chat
BR END_PROGRAM

WITHIN_DIST
LEA R0, WITHIN_MSG
TRAP 0x30         ; Post to chat

END_PROGRAM
HALT

; Note: Please do not change the names of the constants below
G_X .FILL #7
G_Y .FILL #-8
G_Z .FILL #5
GOAL_DIST .FILL #10

WITHIN_MSG .STRINGZ "The player is within Manhattan distance of the goal"
OUTSIDE_MSG .STRINGZ "The player is outside the goal bounds"

.END
