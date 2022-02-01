#####################################################################
#
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Joseph Zhao, 1005913068, zhaojose
#
# Bitmap Display Configuration:
# -Unit width in pixels: 8 (update this as needed)
# -Unit height in pixels: 8 (update this as needed)
# -Display width in pixels: 256 (update this as needed)
# -Display height in pixels: 256 (update this as needed)
# -Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# Milestone 1, Mar. 28. 2021
# Milestone 2, April, 2, 2021
# Milestone 3, April, 2, 2021
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
#... (add more if necessary)
#
# Link to video demonstration for final submission:
# -(insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# -no, and please share this project githublink as well!
#
# Any additional information that the TA needs to know:
# -(write here, if any)
# y position/coords means up and down rows of the bitmap 
# x position/coords means left and right columns of the bitmap
######################################################################
.eqv	BASE_ADDRESS	0x10008000
.eqv 	MOVE_CONST	0x00000100
.eqv	SLEEP_CONST	25


.data
#bitmap:	.word	0:512
player:	.word	BASE_ADDRESS
ships:	.word	BASE_ADDRESS:3
ship_count:	.word	0:3
health:		.word	100, 268472000	# max health, position of current end of health bar
player_parts:	.word	48, 0, -4, 4, 8, -128, 128, 256, -256, -124, -260, 132, 252
letterG:	.word	40, 0, 4, 8, 128, 256, 384, 388, 392, 264, 520
letterA:	.word	32, 4, 128, 136, 256, 260, 264, 384, 392
letterM:	.word	44, 0, 16, 128, 132, 140, 144, 256, 264, 272, 384, 400
letterE:	.word   44, 0, 4, 8, 128, 256, 260, 264, 384, 512, 516, 520
letterO:	.word	48, 0, 4, 8, 128, 136, 256, 264, 384, 392, 512, 516, 520
letterV:	.word	36, 0, 16, 128, 144, 260, 268, 388, 396, 520
letterR:	.word	40, 0, 4, 128, 136, 256, 260, 384, 392, 512, 524
.text
.globl main
	
main:	li $t0, BASE_ADDRESS	# load beginning of map 
	addi $t0, $t0, 2052 	# add 2052 to get the first word in the center row of the map
	la $t1, player
	sw $t0, 0($t1)		# store the address in the player array for the player's center
	sw $t0, -4($sp)
	addi $sp, $sp, -4	#
	jal paint_player	# jump to paint player to paint the player ship
	addi $sp, $sp, 4
	addi $t0,  $zero, 3456	# store address for first word to paint health display
	addi $t0, $t0, BASE_ADDRESS	# 
	li $t1, 0xc0c0c0		# load colour for grey
	sw $t1, 0($t0)	#//
	addi $t2, $t0, 128		# store end of health display for the first row of the display
	
health_display_row1:	sw $t1, 0($t0)				# colour first word of the first row of display grey
			addi $t0, $t0, 4			# go to next word
			beq $t0, $t2, health_display_row2	# if on next row of display start painting next row
			j health_display_row1			# else paint next word in the first row
health_display_row2:	sw $t1, 0($t0)				# paint first word in second row of display grey
			addi $t0, $t0, 4			# go to next word 
			sw $t1, 0($t0)				# paint grey again
			addi $t0, $t0, 4			# go to next word
			li $t1, 0xff0000			# store colour red for health symbol
			sw $t1, 0($t0)				# paint word red for top of health symbol	
			li $t1, 0xc0c0c0			# get grey again
			addi $t0, $t0, 4			# go to next word
			addi $t2, $zero, BASE_ADDRESS		# store in t2 address of start of row 3 for display's health symbol
			addi $t2, $t2, 3716		# 
health_display_row3:	sw $t1, 0($t0)				# colour word grey
			addi $t0, $t0, 4			#  go to next word
			beq $t0, $t2, health_display_row4	# if at beginnning of row 3 health symbol end loop 
			j health_display_row3			# else continue painting row 2
health_display_row4:	li $t1, 0xff0000			# store red for health symbol
			sw $t1, 0($t0)				# colour word red for health symbol 3 times for center of symbol
			addi $t0, $t0, 4			#
			sw $t1, 0($t0)				#
			addi $t0, $t0, 4			#
			sw $t1, 0($t0)				#
			addi $t0, $t0, 4			#
			li $t1, 0xc0c0c0			# store grey b/c grey space between healthbar and symbol
			sw $t1, 0($t0)				# colour space between healthbar and symbol grey
			addi $t0, $t0, 4			#
			sw $t1, 0($t0)				#
			addi $t0, $t0, 4			#
			li $t1, 0xff0000			# store red now to colour healthbar
			add $t2, $zero, $zero			# store index for healthbar loop in t2 
healthbar:		sw $t1, 0($t0)				# colour word red for healthbar
			addi $t0, $t0, 4			# go to next word
			addi $t2, $t2, 1			# increment index
			beq $t2, 10, healthbar_end		# if index is 10, end loop
			j healthbar				# else keep painting healthbar
healthbar_end:		li $t1, 0xc0c0c0			# store grey for painting remainder of display
			li $t2, 3848			# load address of health symbol for row 4 
			addi $t2, $t2, BASE_ADDRESS		#
display_row4:		sw $t1, 0($t0)				#  colour word grey
			addi $t0, $t0, 4			# go to next word
			beq $t2, $t0, display_end		# if at health symbol address for row 4 end loop
			j display_row4				# else continue painting grey
display_end:	li $t1, 0xff0000	# load colour red
		sw $t1, 0($t0)		# colour red for bottom of health symbol
		addi $t0, $t0, 4	# go to next word
		li $t1, 0xc0c0c0	# load colour grey
		li $t2, 4096		# store address after last address of map
		addi $t2, $t2, BASE_ADDRESS	#
				
display_end_loop:	sw $t1, 0($t0)		# paint word grey
			addi $t0, $t0, 4	# go to next word
			beq $t2, $t0, main_loop	# if after end of map end loop
			j display_end_loop	# else continue painting rest of display grey
	
paint_player:	la $t0, player
		lw $t0, 0($t0)
		li $t3, 0xa9a9a9	# this code just loads address for parts of ship from the center and colours them
					# their appropriate colours
		sw $t3, 0($t0)
		 li $t3, 0xa9a9a9
		sw $t3, -4($t0)	
		li $t3, 0x53adcb		
		sw $t3, 4($t0)
		li $t3, 0xdcdcdc
		sw $t3, 8($t0)
		li $t3, 0xa9a9a9
		sw $t3, -128($t0)
		li $t3, 0xa9a9a9
		sw $t3, 128($t0)
		li $t3, 0xd3d3d3
		sw $t3, 256($t0)
		li $t3, 0xd3d3d3
		sw $t3, -256($t0)
		li $t3, 0xc0c0c0
		sw $t3, -124($t0)
		li $t3, 0xffffff
		sw $t3, -260($t0)
		li $t3, 0xc0c0c0
		sw $t3, 132($t0)
		li $t3, 0xffffff
		sw $t3, 252($t0)
		jr $ra


paintblack_player:  la $t0, player
		    lw $t0, 0($t0)
		    li $t3, 0x000000	#loads parts of the ship from the center and colour the parts black
		 sw $t3, 0($t0)
		 
		sw $t3, -4($t0)	
				
		sw $t3, 4($t0)
		
		sw $t3, 8($t0)
		
		sw $t3, -128($t0)

		sw $t3, 128($t0)
	
		sw $t3, 256($t0)
	
		sw $t3, -256($t0)
	
		sw $t3, -124($t0)
	
		sw $t3, -260($t0)
	
		sw $t3, 132($t0)
	
		sw $t3, 252($t0)
 		jr $ra		
 
main_loop:	jal key_check		# main loop of game that jumps to each function that the game needs
		jal ship_loop		# detect collisions, check for key presses, move enemy ships, etc..
		jal collision_detect
		jal paint_player		
		j main_loop

	
key_check:	li $t9, 0xffff0000 	# load t8 with value at address store in t9
		lw $t8, 0($t9)		# 
		sub $t8, $t8, 1		#
		bgez $t8, keypr		# if a key is pressed jump and link to the keypressed function
		jr $ra			# return to mainloop
	
keypr:	lw $t2, 4($t9) 			# if key pressed obtain ascii value for key that was pressed
	beq $t2, 0x64, dmove 		# jump to the following label for the corresponding key that was pressed
	beq $t2, 0x73, smove		#
	beq $t2, 0x77, wmove		#
	beq $t2, 0x61, amove		#
	beq $t2, 0x70, reset_request	#
	jr $ra				# then return back to the key_check fcn for return to main_loop
	
reset_request:	la $t0, ships			# load enemy ship center array address for reset
		la $t3, ship_count		# load the ship increment halting array for reset
		addi $t2, $zero, BASE_ADDRESS	# load the base address of map for reseting ship center array
		add $t1, $t0, 12		# load end address for both arrays
		jal reset			# jump to function to reset all arrays in use
		jal reset_start
		j main
		
dmove:	la $t0, player
	lw $t0, 0($t0)		# load the ship center address
	addi $t7, $zero, 128	# divide the address by 128 to check if at the right edge of the map
	div $t0, $t7		# calculate y postion of ship center
	mflo $t7		#
	sll $t7, $t7, 7		#
	addi $t7, $t7, 116	# add 120 to get the word before the right edge of map at ships y row of map
	beq $t0, $t7, return	# if it is at the word before  the right edge word do not move right i.e return to main_loop
	move $v1, $ra		# store return address in v1 for jump to paint black function
				# else move right
	sw $t0, -4($sp)		# push on stack
	addi $sp, $sp, -4	# 
	jal paintblack_player	# jump to function to paint current ship position black
	lw $t0, 0($sp)		# load center address of ship for player
	addi $sp, $sp, 4	# delete center from stack
	move $ra, $v1		# move return address into ra again
	addi $t0, $t0, 4	# sent new center to next word
	la $t1, player
	sw $t0, 0($t1)		# store new center in stack position with player's center
	move $v1, $ra		# 
	sw $t0, -4($sp)		# push new center on stack and jump to function to paint new ship position
	addi $sp, $sp, -4	#
	jal paint_player	
	addi $sp, $sp, 4	# remove arg from stack
	move $ra, $v1		# jump back to keypr
	jr $ra
	
smove:	la $t0, player
	lw $t0, 0($t0)		# load the ship center address
	li $t7, BASE_ADDRESS		# store in t7 the starting address of first word of the row before the display
	addi $t7, $t7, 3072		# and check if the center is at the corresponding row by check if the address 
	bge $t0, $t7, return		# is greater than or equal to the first word address of that row
	add $s0, $t0, $zero
	addi $s0, $s0, 256
	blt $s0, $t7, normal_s
	move $v1, $ra			#
					# if not paint the current position black 
	sw $t0, -4($sp)			#
	addi $sp, $sp, -4		#
	jal paintblack_player		#
	lw $t0, 0($sp)	
	addi $sp, $sp, 4		#
	move $ra, $v1			#
	div $s3, $t0, 128
	mfhi $s3
	add $t0, $t7, $s3
	la $t1, player
	sw $t0, 0($t1)			# and repaint new ship position
	move $v1, $ra			#
	sw $t0, -4($sp)			# 
	addi $sp, $sp, -4		#
	jal paint_player			#
	addi $sp, $sp, 4		#
	move $ra, $v1			#
	jr $ra				# return to keypr
	
normal_s:move $v1, $ra			#
					# if not paint the current position black 
	sw $t0, -4($sp)			#
	addi $sp, $sp, -4		#
	jal paintblack_player		#
	lw $t0, 0($sp)	
	addi $sp, $sp, 4		#
	move $ra, $v1			#
	addi $t0, $t0, 256		# then update the center position to be one row down
	la $t1, player
	sw $t0, 0($t1)			# and repaint new ship position
	move $v1, $ra			#
	sw $t0, -4($sp)			# 
	addi $sp, $sp, -4		#
	jal paint_player			#
	addi $sp, $sp, 4		#
	move $ra, $v1			#
	jr $ra				# return to keypr

wmove:	la $t0, player
	lw $t0, 0($t0)			# load player center
	li $t7, BASE_ADDRESS		# check if the player center is on the second row of the map by checking if 
	addi $t7, $t7, 256		# the address of the player center is less than or equal to the last word on the second row
	ble $t0, $t7, return		# of the map.
	addi $s0, $t0, -256
	bgt $s0, $t7, normal_w
	move $v1, $ra			# if not then paint current ship position black 
	sw $t0, -4($sp)			#
	addi $sp, $sp, -4		#
	jal paintblack_player		#
	lw $t0, 0($sp)
	addi $sp, $sp, 4		#
	move $ra, $v1			#
	div $s1, $t0, 128
	mfhi $s1
	add $t0, $t7, $s1		# update the ships center position to be one row above by subtracting 128 from current address
	la $t1, player
	sw $t0, 0($t1)			# Then repaint new player position
	move $v1, $ra			#
	sw $t0, -4($sp)			#
	addi $sp, $sp, -4		#
	jal paint_player			#
	addi $sp, $sp, 4		#
	move $ra, $v1			#
	jr $ra		
	  

normal_w:	move $v1, $ra			# if not then paint current ship position black 
	sw $t0, -4($sp)			#
	addi $sp, $sp, -4		#
	jal paintblack_player		#
	lw $t0, 0($sp)
	addi $sp, $sp, 4		#
	move $ra, $v1			#
	addi $t0, $t0, -256		# update the ships center position to be one row above by subtracting 128 from current address
	la $t1, player
	sw $t0, 0($t1)			# Then repaint new player position
	move $v1, $ra			#
	sw $t0, -4($sp)			#
	addi $sp, $sp, -4		#
	jal paint_player			#
	addi $sp, $sp, 4		#
	move $ra, $v1			#
	jr $ra				# return to keypr

amove:	la $t0, player
	lw $t0, 0($t0)		# load player's center
	add $t7, $zero, $t0 	# load t7 with the player's y postion then check if the players center address is 
	add $t7, $t7, -4	# at the word before the left edge word of the row corresponding the player's y position
	sll $t7, $t7, 25 	# 
	beqz $t7, return	# 
	move $v1, $ra		# 
				# if not at word before left edge word for the players center row then paint player's current position
	sw $t0, -4($sp)		# black
	addi $sp, $sp, -4	#
	jal paintblack_player	#
	lw $t0, 0($sp)
	addi $sp, $sp, 4	#
	move $ra, $v1		#		
	addi $t0, $t0, -4	# update center address to be one word back 
	la $t1, player
	sw $t0, 0($t1)		# and repaint the players new position
	move $v1, $ra		#

	sw $t0, -4($sp)		#
	addi $sp, $sp, -4	#
	jal paint_player	#
	addi $sp, $sp, 4	#
	move $ra, $v1		#
	jr $ra			# return to keypr

return: jr $ra	# label just for returning for branching instructions 

collision_detect:	sw $ra, -4($sp)			# push return address to main_loop on stack
			addi $sp, $sp , -4		# 
			la $t0, player_parts			# load t0 with players center, load t1 with value of purple
			lw $s0, 0($t0)
			addi $s2, $t0, 4
			add $s4, $zero, $s2
			add $s3, $zero, $zero
			li $t1, 0x800080		# load t3 with colour at each of the player's ships parts
			la $t0, player
			lw $t0, 0($t0)
collision_detect_loop:	lw $s1, 0($s4)
			add $t2, $t0, $s1		# check if the colour at each player's ships part is purple 
			lw $t3, 0($t2)			# if at least one is purple then a collision happenned
			beq $t3, $t1, collision_check   #
			addi $s3, $s3, 4
			beq $s3, $s0, no_collision
			add $s4, $s2, $s3
			j collision_detect_loop
no_collision:	j return_s	

collision_check: 	add $t0, $zero, $zero	# load t0 with index into array of ships of enemy
			la $t1, ships		# load address of array ships
	
collision_loop:	add $t1, $t1, $t0		# loops through each of the ships to check which ship caused collision
		lw $t3, 0($t1)			# t3 loads center of the ship at address ships + index and 
		add $t3, $t3, $zero		# we calculate if the collision piece address stored in t2 can be offset back to the  
		beq $t3, $t2, collision_make	# enemy center, if possible then we delete that ship, reset it and paint explosion
		lw $t3, 0($t1)
		addi $t3, $t3, -128
		beq $t3, $t2, collision_make
		lw $t3, 0($t1)
		addi $t3, $t3, 128
		beq $t3, $t2, collision_make
		lw $t3, 0($t1)
		addi $t3, $t3, -4
		beq $t3, $t2, collision_make
		lw $t3, 0($t1)
		addi $t3, $t3, -8
		beq $t3, $t2, collision_make
		lw $t3, 0($t1)
		addi $t3, $t3, -132
		beq $t3, $t2, collision_make
		lw $t3, 0($t1)
		addi $t3, $t3, 124
		beq $t3, $t2, collision_make
		addi $t0, $t0, 4
		la $t1, ships
		beq $t0, 12, return_s
		j collision_loop
		

collision_make:	sw $t1, -4($sp)		# push the enemy center that collided on the stack
		addi $sp, $sp, -4
		jal paint_ship_black	# paint the enemy ship black because destroyed
		la $t0, health		# load the players health bar end address to update on the display
		addi $t0, $t0, 4	# 
		lw $t2, 0($t0)		# colour the current word the health bar end is at black and the word before then
		li $t1, 0x000000	# update the health bar end address to be 3 words back
		sw $t1, 0($t2)		#
		addi $t2, $t2, -4	#
		sw $t1, 0($t2)		#
		addi $t2, $t2, -4	#
		sw $t2, 0($t0)		#
		addi $t0, $t0, -4	#
		lw $t1, 0($t0)		# load the players health value 
		subi $t1, $t1, 20	# subtract 20 
		sw $t1, 0($t0)		# update value in health array

		lw $t2, 0($sp)			# load the enemy center 
		addi $t0, $zero, BASE_ADDRESS	# reset center to BASE_ADDRESS
		lw $t7, 0($t2)			# 
		sw $t0, 0($t2)			#
		subi $t3, $t7 , BASE_ADDRESS	# calculate the y position of the enemy center before the reset
		div $t3, $t3, 128 		# t3 = previous enemy ship center y coord
		mfhi $t4			# remainder of the division is the x coord
		li $t1, 0xffffff		# paint first sprite for explosion with colour white
		li $t2, 0x000000		# paint first sprite at the ships previous center position
		sw $t1, 0($t7)			#
		# sleep to make explosion visible to player
		
		li $v0, 32			
		li $a0, SLEEP_CONST
		syscall
		
		sw $t2, 0($t7)			# then remove first sprite by painting word black
		addi $t5, $t7, -4		# then we check if the word before the ships center is on the same y position as center
		subi $t6, $t5 , BASE_ADDRESS	# to check if we can paint the second sprite's left figure properly
		div $t6, $t6, 128		# 
		bne $t6, $t3, small_collision_sprite1 
		sw $t1, 0($t5) 			# if possible then paint word before center white
		
small_collision_sprite1:	addi $t5, $t7, -128		# then we check if the top piece for next explosion sprite will 
			blt $t5, BASE_ADDRESS, small_collision_sprite2	# still be on the map if possible paint white else check
			sw $t1, 0($t5)					# next piece
small_collision_sprite2:	addi $t5, $t7, 4		# check if the right piece of the next explosion sprite will be on the 
			subi $t6, $t5 , BASE_ADDRESS		# same row as the center of the previous enemy ship 
			div $t6, $t6, 128			# by checking equivlance of y positions for both word addresses
			bne $t6, $t3, small_collision_sprite3	#
			sw $t1, 0($t5)				# if on same y coord paint white
small_collision_sprite3:	addi $t5, $t7, 128		# check if bottom piece of the next explosion sprite is still on the map
			addi $t6, $zero, BASE_ADDRESS		# if possible paint the bottom of the sprite piece white
			addi $t6, $t6, 3200
			bgt $t5, $t6, small_collision_sprite4
			sw $t1, 0($t5)				
small_collision_sprite4:	addi $t5, $t7, -4		# check if the left piece of the small collision sprite will have the 
			subi $t6, $t5 , BASE_ADDRESS		# same y coord as the ships previous center if true then paint 
			div $t6, $t6, 128			# the left piece white
			beq $t6, $t3, small_collision_delete1
			sw $t1, 0($t5)
			# sleep
		
small_collision_delete1:li $v0, 32 						# sleep before deleting sprite inorder for
			li $a0, SLEEP_CONST					# player to see sprite
			syscall
			addi $t5, $t7, -128					# check if the top piece is on map inorder to 
			blt $t5, BASE_ADDRESS, small_collision_delete2		# paint the top piece black else do not
			sw $t2, 0($t5)						#
small_collision_delete2:	addi $t5, $t7, 4				# check if the right piece of the small sprite is 
			subi $t6, $t5 , BASE_ADDRESS				# on the same y coord as previous ships center 
			div $t6, $t6, 128					# if true paint black
			bne $t6, $t3, small_collision_delete3			# 
			sw $t2, 0($t5)						#
small_collision_delete3:	addi $t5, $t7, 128				# check if the bottom piece is still on map 
			addi $t6, $zero, BASE_ADDRESS				# if so delete by painting black
			addi $t6, $t6, 3200					#
			bgt $t5, $t6, small_collision_delete4			#
			sw $t2, 0($t5)						#
small_collision_delete4:addi $t5, $t7, -4					#  check if the left piece of the sprite is on the same
			subi $t6, $t5 , BASE_ADDRESS				# y coord as the previous ships center		
			div $t6, $t6, 128					# if true delete by painting black
			bne $t6, $t3, store_medium_colision
			sw $t2, 0($t5)
store_medium_colision:	addi $t5, $t7, -132		# push on stack addresses for the medium collision sprite
			sw $t5, -4($sp)
			addi $t5, $t7, -124
			sw $t5, -8($sp)
			addi $t5, $t7, 124
			sw $t5, -12($sp)
			addi $t5, $t7, 132
			sw $t5, -16($sp)
			addi $t5, $t7, -256
			sw $t5, -20($sp)
			addi $t5, $t7, 256
			sw $t5, -24($sp)
			addi $t5, $t7, 8
			sw $t5, -28($sp)
			addi $t5, $t7, -8
			sw $t5, -32($sp)
			addi $sp, $sp, -32
		
			lw $t5, 0($sp)				# pop the left piece of the medium sprite
			addi $sp, $sp, 4			# 
			subi $t6, $t5 , BASE_ADDRESS		# 
			div $t6, $t6, 128			#
			bne $t6, $t3, med_colision_sprite1	# check if y position is same as previous ships center y position
			sw $t1, 0($t5)				# if true paint white else skip
med_colision_sprite1:	lw $t5, 0($sp)				#
			addi $sp, $sp, 4			# pop right piece of medium sprite
			subi $t6, $t5 , BASE_ADDRESS		# check if y position is same as previous ships center y position
			div $t6, $t6, 128			# if true paint white else skip
			bne $t6, $t3, med_colision_sprite2
			sw $t1, 0($t5)
med_colision_sprite2:	lw $t5, 0($sp)				# pop bottom piece of medium sprite
		addi $sp, $sp, 4				#
		bge $t3, 22, med_colision_sprite3		# check if the y position of the ships prev center is 
		sw $t1, 0($t5)					# 2 or 1 away from the display's y position if true don't paint 
med_colision_sprite3:	lw $t5, 0($sp)				# bottom else paint
		addi $sp, $sp, 4				# load the top piece of medium sprite 
		ble $t3, 1, med_colision_sprite4		#
		sw $t1, 0($t5)					# check if the ships prev y coord center is on the second row of the 
med_colision_sprite4:	lw $t5, 0($sp)				# map, if true don't paint top piece else paint white
		addi $sp, $sp, 4				# load bottom right corner piece of sprite 
		beq $t4, 124, med_colision_sprite5		# 
		bge $t3, 22 , med_colision_sprite5		# check if the ships prev center x coord is on the right edge 
		sw $t1, 0($t5)					# or the ships prev center y coord is >= 22, if true dont paint piece
med_colision_sprite5:	lw $t5, 0($sp)				# else paint
		addi $sp, $sp, 4				# load bottom left corner piece of med sprite 
		beqz $t4, med_colision_sprite6			# if the  x coord of ships prev center is on the left edge or the 
		bge $t3, 22 , med_colision_sprite6		# y coord is >= 22, dont paint else paint white
		sw $t1, 0($t5)					# 
med_colision_sprite6:	lw $t5, 0($sp)				# load the top right corner piece of med sprite
		addi $sp, $sp, 4				# check if the ships prev center x coord is 124 
		bge $t4, 124, med_colision_sprite7		# if true dont paint else paint white
		sw $t1, 0($t5)					# load top left corner piece of med sprite
med_colision_sprite7:	lw $t5, 0($sp)				# and check if the ships prev center x coord is 0, if true dont paint
		addi $sp, $sp, 4				# else paint piece address white
		beqz $t4, delete_med_colision
		sw $t1, 0($t5)

		# sleep
delete_med_colision:	li $v0, 32			# sleep to show medium collision to player
			li $a0, SLEEP_CONST
			syscall
		
		move $t0, $t7			# just setting t0 to the address of prev ships center
		addi $t5, $t0, -132		# push address of all pieces for deletion on stack
		sw $t5, -4($sp)
		addi $t5, $t0, -124
		sw $t5, -8($sp)
		addi $t5, $t0, 124
		sw $t5, -12($sp)
		addi $t5, $t0, 132
		sw $t5, -16($sp)
		addi $t5, $t0, -256
		sw $t5, -20($sp)
		addi $t5, $t0, 256
		sw $t5, -24($sp)
		addi $t5, $t0, 8
		sw $t5, -28($sp)
		addi $t5, $t0, -8
		sw $t5, -32($sp)
		addi $sp, $sp, -32
		lw $t5, 0($sp)				# load the left piece address of the med sprite
		addi $sp, $sp, 4
		subi $t6, $t5 , BASE_ADDRESS		# same checks as for the painting of the sprite but now we paint black
		div $t6, $t6, 128
		bne $t6, $t3, delete_med_col1
		sw $t2, 0($t5)			
delete_med_col1:	lw $t5, 0($sp)			# load the right piece address of the med sprite
		addi $sp, $sp, 4			# same checks as for the painting of the sprite but now we paint black
		subi $t6, $t5 , BASE_ADDRESS
		div $t6, $t6, 128
		bne $t6, $t3, delete_med_col2
		sw $t2, 0($t5)
delete_med_col2:	lw $t5, 0($sp)			# load the bottom piece address of the med sprite
		addi $sp, $sp, 4			# same checks as for the painting of the sprite but now we paint black
		bge $t3, 22, delete_med_col3
		sw $t2, 0($t5)				# load the top piece address of the med sprite
delete_med_col3:	lw $t5, 0($sp)			# same checks as for the painting of the sprite but now we paint black
		addi $sp, $sp, 4
		ble $t3, 1, delete_med_col4
		sw $t2, 0($t5)
delete_med_col4:	lw $t5, 0($sp)			# load the bottom right piece address of the med sprite
		addi $sp, $sp, 4			# same checks as for the painting of the sprite but now we paint black
		bge $t4, 124, delete_med_col5
		bge $t3, 22 , delete_med_col5
		sw $t2, 0($t5)
delete_med_col5:	lw $t5, 0($sp)			# load the bottom left piece address of the med sprite
		addi $sp, $sp, 4			# same checks as for the painting of the sprite but now we paint black
		beqz $t4, delete_med_col6
		bge $t3, 22 , delete_med_col6
		sw $t2, 0($t5)
delete_med_col6:	lw $t5, 0($sp)			# load the top left piece address of the med sprite
		addi $sp, $sp, 4			# same checks as for the painting of the sprite but now we paint black
		bge $t4, 124, delete_med_col7
		sw $t2, 0($t5)
delete_med_col7:	lw $t5, 0($sp)			# load the top right piece address of the med sprite
		addi $sp, $sp, 4			# same checks as for the painting of the sprite but now we paint black
		beqz $t4, reset_collision_ship	
		sw $t2, 0($t5)
		
reset_collision_ship:	jal new_ship		# jump to function to set new center for enemy ship that collided
			lw $t0, 0($sp)		# pop collided enemy center address on ships array from stack into t0
			addi $sp, $sp, 4	
			lw $ra, 0($sp)		# if not dead, pop ra and return to main_loop
			addi $sp, $sp, 4
			la $t0, health		# load health array for checking if health is < 0
			lw $t0, 0($t0)
			bltz $t0, paint_game_over	# if less than 0 reset game due to death
			jr $ra
																																					
return_s:	lw $ra, 0($sp)
		addi $sp, $sp, 4	
		jr $ra			#
				

ship_loop: 	sw $ra, -4($sp)		#store return address
		addi $sp, $sp, -4	# 
start:		la $t0, ships		# load array for ships address
		add $t1, $zero, $zero	# set index counter to 0
s_loop:		add $t0, $t1, $t0	# set array value to array address + index
		sw $t1, -4($sp)		# store on stack index to save value
		sw $t0, -8($sp)		# store on stack address + index at top as arg for next function
		addi $sp, $sp, -8	# 
		jal boundary_check	# jump to boundary check
		lw $t1, 4($sp)		# 
		addi $sp, $sp, 8
		la $t0, ships
		addi $t1, $t1, 4
		beq $t1, 12, return_s
		j s_loop
	
boundary_check:	lw $t0, 0($sp)	# array address + index
		lw $t1, 0($t0)	#load value at array + index
		subi $t1, $t1, BASE_ADDRESS # calculate if value at address + index is multiple of 128
		andi $t1, $t1, 127 	#
		bne $t1, $zero, j_increment	# if result division is not zero increment center
		
j_new_ship:	la $t3, ship_count
		lw $t2, 4($sp)
		add $t1, $t2, $t3
		lw $t2, 0($t1)
		bne $t2, MOVE_CONST, next_ship
		sw $zero, 0($t1)
		move $v1, $ra
		jal new_ship		# jump to new_ship
		move $ra, $v1
		jr $ra			# return to s_loop

j_increment:	la $t3, ship_count
		lw $t2, 4($sp)
		add $t1, $t2, $t3
		lw $t2, 0($t1)
		bne $t2, MOVE_CONST, next_ship
		sw $zero, 0($t1)
		move $v1, $ra
		jal increment_ship	# jump to ship increment
		move $ra, $v1
		jr $ra

next_ship:	la $t1, ship_count
		lw $t2, 4($sp)
		lw $t3, 4($sp)
		add $t2, $t1, $t2
		lw $t2, 0($t2)
		addi $t2, $t2, 1
		add $t1, $t1, $t3
		sw $t2, 0($t1)
		jr $ra

increment_ship:	lw $t0, 0($sp)		# load ship[i] address in t0
		sw $ra, -4($sp)		# store return address
		addi $sp, $sp, -4	# 
		sw $t0, -4($sp)		# store ship[i] address in stack
		addi $sp, $sp, -4	#
		jal paint_ship_black	# paint the current ship position black
		lw $t0, 0($sp)		# load t0 with ship[i] address
		lw $t1, 0($t0)
		addi $t1, $t1, -4	# update position of ship center
		sw $t1, 0($t0)
		jal paint_new_ship	# paint new ship position
		lw $ra, 4($sp)		# load return address
		addi $sp, $sp, 8	# delete both from stack
		jr $ra			# return to j_increment
		
		
paint_ship_black:	lw $t0, 0($sp)		# load t0 with address in ships array + index
			li $t1, 0x000000	# load colour black
			lw $t2, 0($t0)		# load center address from ships array address + index in t0
			sw $t1, 0($t2)		# colour the ships center and all parts ( offsets from center ) of ship black
			lw $t2, 0($t0)
			addi $t2, $t2, -128
			sw $t1, 0($t2)
			lw $t2, 0($t0)
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			lw $t2, 0($t0)
			addi $t2, $t2, -4
			sw $t1, 0($t2)
			lw $t2, 0($t0)
			addi $t2, $t2, -8
			sw $t1, 0($t2)
			lw $t2, 0($t0)
			addi $t2, $t2, -132
			sw $t1, 0($t2)
			lw $t2, 0($t0)
			addi $t2, $t2, 124
			sw $t1, 0($t2)
			jr $ra		# return to caller

paint_new_ship:		lw $t0, 0($sp)		# load ships array address + index
			li $t1, 0x800080	# load rgb value of purple
			lw $t2, 0($t0)		# load center address of ship
			sw $t1, 0($t2)		# paint center purple 
			subi $t3, $t2, BASE_ADDRESS	
			div $t3, $t3, 128			# calculate y position of center
			addi $t4, $t2, -4			# check if the word before the center has the same 
			subi $t5, $t4, BASE_ADDRESS		# y position as the center if true paint purple else skip
			div $t5, $t5, 128
			beq $t5, $t3, a_center_purple
			j check_center_fin		# if not at right position skip
			
			
a_center_purple:	li $t1, 0x800080	# paint purple 
			sw $t1, 0($t4)
			
check_center_fin:	addi $t4, $t2, -8		# check if 2 words before the center is on the same y position if 
			subi $t5, $t4, BASE_ADDRESS	# true paint purple else skip
			div $t5, $t5, 128
			beq $t5, $t3, a_center_fin_purple
			j check_upper_fin
			
a_center_fin_purple:	li $t1, 0x800080
			sw $t1, 0($t4)

check_upper_fin:	addi $t4, $t2, -132		# check if the upper fin of the ship's y position is 1 less than the 
			subi $t5, $t4, BASE_ADDRESS	# center's y position
			div $t5, $t5, 128		# if true paint purple else skip
			addi $t6, $t3, -1
			beq $t5, $t6, upper_fin_purple
			j check_lower_fin	

upper_fin_purple:	li $t1, 0x800080
			sw $t1, 0($t4)
			
check_lower_fin:	addi $t4, $t2, 124		#  check if the upper fin of the ship's y position is 1 more than the
			subi $t5, $t4, BASE_ADDRESS	# center's y position
			div $t5, $t5, 128		# if true paint purple else skip
			addi $t6, $t3, 1	
			beq $t5, $t6, lower_fin_purple
			j back_purple
			
lower_fin_purple:	li $t1, 0x800080
			sw $t1, 0($t4)
			
back_purple:		li $t1, 0x800080		# paint the back pieces of ship as purple
			lw $t2, 0($t0)
			addi $t2, $t2, -128
			sw $t1, 0($t2)
			lw $t2, 0($t0)
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			lw $t2, 0($t0)
			sw $t1, 0($t2)
			jr $ra 		# return to caller
			
new_ship:	lw $t0, 0($sp)		# load ship[i] address
		sw $ra, -4($sp)		# store return address on stack
		addi $sp, $sp, -4	# 
		sw $t0, -4($sp) 	# store ship[i] address on stack
		addi $sp, $sp, -4	#
		jal paint_ship_black	# jump to paint the ship position black 
gen_loop:	li $v0, 42		# load random num in a0
		li $a0, 0		#
		li $a1, 24		#
		syscall			#
		blt $a0, 2,gen_loop	# if 0 gen again
		sll $a0, $a0, 7		# compute a0 as address on bitmap
		addi $a0, $a0, 124	#
		addi $a0, $a0, BASE_ADDRESS	#
		sw $a0, -4($sp)			# store bitmap address on stack
		la $t2, ships			# store address of array ships on stack
		sw $t2, -8($sp)			#
		addi $sp, $sp, -8		#
		jal is_unique			# jump to find if address is not already used
		lw $t2, 0($sp)			#  pop return value of is_unique from stack
		addi $sp, $sp, 8		#
		beq $t2, 1, unique		# if unique jump to unique label
		addi $sp, $sp, 4		# else delete bitmap address from stack to generate new one
not_unique:	j gen_loop			# if not generate new random number

unique:		lw $t3, 0($sp)			# load new ship address on t3
		lw $t0, 4($sp)			# load t0 with ship[i] address
		sw $t3, 0($t0)			# ship[i] = new ship bitmap address
		addi $sp, $sp, 4
		
		jal paint_new_ship		# jump to paint the new ship
		lw $ra, 4($sp)			# load return address
		addi $sp, $sp, 8		# delete all values from stack
		jr $ra				# jump back to j_new_ship / collision_make
		
is_unique:	lw $t2, 0($sp)				# load $t2 with address of array of ships
		add $t0, $zero, $zero			# set t0 = 0
		lw $t3, 4($sp)				# load t3 with bitmap address 
unique_loop:	add $t1, $t2, $t0			# get ships[i] address
		lw $t1, 0($t1)				# t1 = ships[i]
		subi $t4, $t1, BASE_ADDRESS		# get y position of ship[i] center
		div $t4, $t4, 128			#
		subi $t5, $t3, BASE_ADDRESS		# get y position of ship[i] center
		div $t5, $t5, 128			#
		sub $t4, $t4, $t5
		abs $t4, $t4
		ble $t4, 3, return_not_unique
		addi $t0, $t0, 4			#
		beq $t0, 12, return_unique		# if at end of loop return bitmap address
		j unique_loop				# else continue loop
		
return_unique:	addi $t0, $zero, 1			# set t0 = 1
		sw $t0, -4($sp)				# store 1 on stack
		addi $sp, $sp, -4			#
		jr $ra					# return to rand_loop
		
return_not_unique:	add $t0, $zero, $zero		# set t0 = 0
			sw $t0, -4($sp)			# push 0 on stack
			addi $sp, $sp, -4		# 
			jr $ra				# return to rand_loop

reset:	addi $t0, $zero, BASE_ADDRESS	# set t0 to BASE_ADDRESS for reseting purposes
	li $t3,0x000000			# set t3 to rgb for black for reseting purposes
	addi $t1, $zero, BASE_ADDRESS	# set $t1 to word address after last word address of map
	addi $t1, $t1, 4096
reset_loop:	sw $t3, 0($t0)		#  this loop sets the entire screen to black 
		addi $t0, $t0, 4	#
		beq $t0, $t1, screen_now_black
		j reset_loop
screen_now_black:	jr $ra

paint_game_over:	jal reset
			jal reset_start
			li $t1, 0xffffff		# load rgb value for white in t1
			addi $t0, $zero, BASE_ADDRESS	# load position to start painting the letter G
			addi $t0, $t0, 660		# paint the letter G on the map
			sw $t0, -4($sp)
			la $t1, letterG
			lw $t2, 0($t1)
			addi $t1, $t1, 4
			sw $t2, -8($sp)
			sw $t1, -12($sp)
			addi $sp, $sp, -12
			jal paint_char
			addi $sp, $sp, 8
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			
			addi $t0, $t0, 16		# paint letter A
			sw $t0, -4($sp)
			la $t1, letterA
			lw $t2, 0($t1)
			addi $t1, $t1, 4
			sw $t2, -8($sp)
			sw $t1, -12($sp)
			addi $sp, $sp, -12
			jal paint_char
			addi $sp, $sp, 8
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			
			addi $t0, $t0, 16	# paint letter M
			sw $t0, -4($sp)
			la $t1, letterM
			lw $t2, 0($t1)
			addi $t1, $t1, 4
			sw $t2, -8($sp)
			sw $t1, -12($sp)
			addi $sp, $sp, -12
			jal paint_char
			addi $sp, $sp, 8
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			
			addi $t0, $t0, 24	# paint letter E
			sw $t0, -4($sp)
			la $t1, letterE
			lw $t2, 0($t1)
			addi $t1, $t1, 4
			sw $t2, -8($sp)
			sw $t1, -12($sp)
			addi $sp, $sp, -12
			jal paint_char
			addi $sp, $sp, 8
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			
			addi $t0, $t0, -24	# move t0 to row below the word GAME
			addi $t0, $t0, -16
			addi $t0, $t0, -16
			
			addi $t0, $t0, 784	# move the word OVER so it is painted in the center below GAME
			addi $t0, $t0, 12	# Paint letter O
			sw $t0, -4($sp)
			la $t1, letterO
			lw $t2, 0($t1)
			addi $t1, $t1, 4
			sw $t2, -8($sp)
			sw $t1, -12($sp)
			addi $sp, $sp, -12
			jal paint_char
			addi $sp, $sp, 8
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			
			addi $t0, $t0, 16	# paint the letter V
			sw $t0, -4($sp)
			la $t1, letterV
			lw $t2, 0($t1)
			addi $t1, $t1, 4
			sw $t2, -8($sp)
			sw $t1, -12($sp)
			addi $sp, $sp, -12
			jal paint_char
			addi $sp, $sp, 8
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			
			addi $t0, $t0, 24	# paint the letter E
			sw $t0, -4($sp)
			la $t1, letterE
			lw $t2, 0($t1)
			addi $t1, $t1, 4
			sw $t2, -8($sp)
			sw $t1, -12($sp)
			addi $sp, $sp, -12
			jal paint_char
			addi $sp, $sp, 8
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			
			addi $t0, $t0, 16	# paint the letter R
			sw $t0, -4($sp)
			la $t1, letterR
			lw $t2, 0($t1)
			addi $t1, $t1, 4
			sw $t2, -8($sp)
			sw $t1, -12($sp)
			addi $sp, $sp, -12
			jal paint_char
			addi $sp, $sp, 8
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			
			
				
wait_for_reset:		li $t9, 0xffff0000 	# set up t9 and t8 to check for a keypress in a loop
			lw $t8, 0($t9)
			beq $t8, 1, check_for_p
			j wait_for_reset

check_for_p:		lw $t2, 4($t9) 			# if a keypressed check if ascii value was p 
			beq $t2, 0x70, restart	# if true paint the entire screen black
			j wait_for_reset

restart:	jal reset
		j main

reset_start:		la $t0, ships		# t0 = address of ships array
			la $t3, ship_count	# t3 = address of ships count array
			addi $t2, $zero, BASE_ADDRESS	# load t2 with BASE_ADDRESS to reset ships array
			add $t1, $t0, 12
clean_vars:		sw $t2, 0($t0)		# reset game
			sw $zero, 0($t3)	# t2 has the ships array address + index and t3 has the ships_count array address + index
			addi $t0, $t0, 4	# reset both to their respective values
			addi $t3, $t3, 4
			beq $t0, $t1, reset_health
			j clean_vars
reset_health:		la $t0, health	# reset health to 100 and address of end of healthbar to full value
			li $t1, 100
			sw $t1, 0($t0)
			addi $t0, $t0, 4
			li $t1, 268472000
			sw $t1, 0($t0)
			addi $t0, $zero, BASE_ADDRESS	# prepare registers for clearing screen to black
			li $t3,0x000000
			addi $t1, $zero, BASE_ADDRESS
			addi $t1, $t1, 4096
			jr $ra



# function paints character with white text with args, array of offsets, address and length of 
# array
paint_char:	lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		li $t4, 0xffffff
		add $t3, $zero, $zero
		add $t5, $t0, $zero
paint_charloop:	lw $t7, 0($t5)
		add $t6, $t2, $t7 
		sw $t4, 0($t6)
		addi $t3, $t3, 4
		beq $t3, $t1, paint_char_end
		add $t5, $t0, $t3
		j paint_charloop
		
paint_char_end:	jr $ra
