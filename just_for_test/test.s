.data
	space: .asciiz " "
	test: .asciiz "test"
	input: .asciiz "\n\n입력:"
	output: .asciiz "출력:"
	heap: 	.align 2
			.space 4000 #heap 최대 1000개까지 저장가능

.text
main:

#heap의 현재주소를 저장
la $s7, heap
#heap의 현재 크기를 저장
li $s0, 0

#입력 값을 읽어 들이고 스택에 저장함
read:

	li $v0, 4
	la $a0, input
	syscall
	
	li $v0, 5
	syscall
	addi $s7, $s7, 4
	addi $s0, $s0, 1
	sw $v0, 0($s7)
	


	
#heap 의 max index와 current index 초기화	
	
	
	
	addi $t7, $s0, 0
	addi $t9, $s0, 1


#새로운 입력이 들어오면 insert 알고리즘에의해 maxheap 구성하는 재귀적 과정



# $s0  max index
# $t8  parent index
# $t7  current index
# $t6  parent value
# $t5  current value


insert:
	

	beq $t7, 1, sort_initial
	srl $t8 $t7, 1
	

	sub $t1, $s0, $t8
	mul $t1, $t1, 4
	sub $t1, $s7, $t1 
	lw $t6, 0($t1)

	sub $t2, $s0, $t7
	mul $t2, $t2, 4
	sub $t2, $s7, $t2
	lw $t5, 0($t2)

	slt $t0, $t5, $t6
	bne $t0, 0, sort_initial
	
	
	sw $t6, 0($t2)
	sw $t5, 0($t1)
	

	
	addi $t7, $t8, 0
	
	
	j insert

	

sort_initial:

li $t0, 0
mul $t1, $s0, 4
sub $t1, $t1, 4
sub $t1, $s7, $t1



print_num:
	#숫자 출력, 출력 완료시 다시 읽기가 실행됨
	beq $t0, $s0, read
	addi $t0, $t0, 1
	
	li $v0, 1
	lw $a0, 0($t1)
	syscall
	addi $t1, $t1, 4
	
	
	# 숫자사이 공백 출력
	li $v0, 4
	la $a0, space
	syscall
	j print_num