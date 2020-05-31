.data
	a11: .word 1
	a12: .word 1
	a13: .word 1
	a21: .word 1
	a22: .word 1
	a23: .word 1
	a31: .word 1
	a32: .word 1
	a33: .word 1
	no: .asciiz "There is no inverse matrix"
	space: .asciiz " "
	new_line: .asciiz "\n"
	
.text
main:

	li $t9 0
	
#data 에서 입력값을 받아옴
	lw $s0, a11
	lw $s1, a12
	lw $s2, a13
	lw $s3, a21
	lw $s4, a22
	lw $s5, a23
	lw $s6, a31
	lw $s7,	a32
	lw $t8, a33
	
#3x3 determiant 계산과정
	mul $t0, $s0, $s4
	mul $t0, $t0, $t8
	add $t9, $t9, $t0
	
	mul $t0, $s1, $s5
	mul $t0, $t0, $s6
	add $t9, $t9, $t0

	mul $t0, $s2, $s3
	mul $t0, $t0, $s7
	add $t9, $t9, $t0
	
	mul $t0, $s2, $s4
	mul $t0, $t0, $s6
	sub $t9, $t9, $t0
	
	mul $t0, $s1, $s3
	mul $t0, $t0, $t8
	sub $t9, $t9, $t0
	
	mul $t0, $s0, $s5
	mul $t0, $t0, $s7
	sub $t9, $t9, $t0

	
	
#determiant의 분모가 0이면 역행렬이 존재하지 않으므로 따로 처리	
	beq $t9, 0, no_inverse
	

#determiant 를 $t9에 저장	
	addi $t0 $zero, 1
	div $t9, $t0, $t9
	
	li $t6, 0

#역행렬 B의 성분을 구하고 하나씩 구하고 출력	
#b11 구하고 출력하기
	mul $t0, $s4, $t8
	mul $t1, $s5, $s7
	jal print_num
#b12		
	mul $t0, $s2, $s7
	mul $t1, $s1, $t8
	jal print_num
	
#b13	
	mul $t0, $s1, $s5
	mul $t1, $s2, $s4
	jal print_num
	
#b21	
	mul $t0, $s5, $s6
	mul $t1, $s3, $t8
	jal print_num
	
#b22	
	mul $t0, $s0, $t8
	mul $t1, $s2, $s6
	jal print_num
#b23	
	mul $t0, $s2, $s3
	mul $t1, $s0, $s5
	jal print_num
#b31	
	mul $t0, $s3, $s7
	mul $t1, $s4, $s6
	jal print_num
#b32	
	mul $t0, $s1, $s6
	mul $t1, $s0, $s7
	jal print_num
#b33
	mul $t0, $s0, $s4
	mul $t1, $s1, $s3
	jal print_num
	j finish


print_num:
		
	sub $t0, $t0, $t1
	mul $a0, $t0, $t9
	li $v0, 1
	syscall

#	' '나 '\n'를 출력 
# jal로 a0에 3번째마다 '\n' 아니면 ' '의 주소를 담음
	li $v0, 4
	
	
#space_newline, new_line:' '나 '\n' 판단	
	addi $t6, $t6, 1
	beq $t6, 3, newline
	la $a0, space
	syscall
	jr $ra

newline:
	la $a0, new_line
	li $t6, 0
	syscall
	jr $ra	
	


#determiant의 분모가 0일때 역행렬 없다고 출력, 이어서 종료(finish: 실행) 	
no_inverse:
	li $v0, 4
	la $a0, no
	syscall

	
	
#출력 후 프로그램 종료
finish:
	li $v0, 10
	syscall
	
	
	
	