.data
prompt1: .asciiz "Player 1, enter your choice (r/p/s): "
mySpace: .asciiz "\n"
prompt2: .asciiz "Player 2, enter your choice (r/p/s): "
rock: .asciiz "Rock"
paper: .asciiz "Paper"
scissors: .asciiz "Scissors"
win_msg1: .asciiz "Player 1 wins this round!"
win_msg2: .asciiz "Player 2 wins this round!"
draw_msg: .asciiz "It's a draw!"
invalid: .asciiz "Invalid choice. Try again."
user_wins1: .asciiz "Congratulations Player 1! You won the best of three"
user_wins2: .asciiz "Congratulations Player 2! You won the best of three"
truth_or_dare: .asciiz "\nPlease choose Truth or Dare! (t/d): "
truth: .asciiz "You chose Truth!"
dare: .asciiz "You chose Dare!"

truth_punishment1:.asciiz "Truth: Reveal your most embarrassing moment."
truth_punishment2:.asciiz "Truth: What's your biggest fear?"
truth_punishment3:.asciiz "Truth: Who do you have a crush on?"
dare_punishment1: .asciiz "Dare: Do 10 push-ups."
dare_punishment2: .asciiz "Dare: Sing a song loudly."
dare_punishment3: .asciiz "Dare: Dance for 1 minute."

.text
.globl main

main:
    li $t2, 0 # Player 1 score
    li $t3, 0 # Player 2 score

loop:
    beq $t2, 2, player1_won
    beq $t3, 2, player2_won

    # Prompt Player 1 for their choice
    li $v0, 4
    la $a0, prompt1
    syscall
    li $v0, 12
    syscall
    move $t0, $v0 # Save Player 1's choice in $t0
    
    li $v0, 4    #print function
    la $a0, mySpace
    syscall
 
    # Prompt Player 2 for their choice
    li $v0, 4
    la $a0, prompt2
    syscall
    li $v0, 12
    syscall
    move $t1, $v0 # Save Player 2's choice in $t1
    
    li $v0, 4    #print function
    la $a0, mySpace
    syscall

    # Compare the choices and declare the winner
    beq $t0, 'r', check_rock1
    beq $t0, 'p', check_paper1
    beq $t0, 's', check_scissors1
    j invalid_choice

check_rock1:
    beq $t1, 'r', draw
    beq $t1, 'p', player2_score
    beq $t1, 's', player1_score
    j invalid_choice

check_paper1:
    beq $t1, 'r', player1_score
    beq $t1, 'p', draw
    beq $t1, 's', player2_score
    j invalid_choice

check_scissors1:
    beq $t1, 'r', player2_score
    beq $t1, 'p', player1_score
    beq $t1, 's', draw
    j invalid_choice

player1_score:
    li $v0, 4
    la $a0, win_msg1
    syscall
    addi $t2, $t2, 1 # Increment Player 1 score
    j loop

player2_score:
    li $v0, 4
    la $a0, win_msg2
    syscall
    addi $t3, $t3, 1 # Increment Player 2 score
    j punishment

draw:
    li $v0, 4
    la $a0, draw_msg
    syscall
    j loop

invalid_choice:
    li $v0, 4
    la $a0, invalid
    syscall
    j loop

punishment:
    # Prompt for truth or dare
    li $v0, 4
    la $a0, truth_or_dare
    syscall
    li $v0, 12
    syscall
    move $t6, $v0 # Save choice (t/d) in $t6

    # Display truth or dare result
    beq $t6, 't', truth_choice
    beq $t6, 'd', dare_choice
    j invalid_choice

truth_choice:
    # Randomly select a truth punishment
    li $v0, 42
    li $a1, 3 # Range 0 to 2
    syscall
    move $t7, $a0 # Save random number in $t7

    # Load the appropriate truth punishment
    la $a0, truth_punishment1
    beq $t7, 1, truth_punishment2
    beq $t7, 2, truth_punishment3
    syscall
    j truth_punishment_end


truth_punishment_end:
    j exit

dare_choice:
    # Randomly select a dare punishment
    li $v0, 42
    li $a1, 3 # Range 0 to 2
    syscall
    move $t7, $a0 # Save random number in $t7

    # Load the appropriate dare punishment
    la $a0, dare_punishment1
    beq $t7, 1, dare_punishment2
    beq $t7, 2, dare_punishment3
    syscall
    j dare_punishment_end

dare_punishment2:
    la $a0, dare_punishment2
    syscall
    j dare_punishment_end

dare_punishment3:
    la $a0, dare_punishment3
    syscall
    j dare_punishment_end

dare_punishment_end:
    j exit

player1_won:
    li $v0, 4
    la $a0, user_wins1
    syscall
    j exit

player2_won:
    li $v0, 4
    la $a0, user_wins2
    syscall
    j exit

exit:
    li $v0, 10
    syscall
