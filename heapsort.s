.data
	space: .asciiz " "
	inform: .asciiz "-9999 입력시 종료"
	input: .asciiz "\n\n입력:"
	output: .asciiz "출력:"
	
	#heap 배열 할당
	heap: 	.align 2	#word를 할당 (int형 자료)
			.space 4000 #heap 배열 정수 1000개까지로 할당

.text
main:

# "-9999 입력시 종료"를 출력
li $v0, 4
la $a0, inform
syscall

#heap의 현재주소를 저장하기 위해 변수 할당
la $s7, heap
#heap의 현재 크기를 저장하기위한 변수 할당
li $s0, 0

#입력 값을 읽어 들이고 스택에 저장함
read:
	
	#"\n\n입력:"을 출력함
	li $v0, 4
	la $a0, input
	syscall
	
	li $v0, 5
	syscall
	
	# -9999입력시 종료시킴
	beq $v0, -9999, finish
	
	# 읽어들인 값 heap배열에 저장
	addi $s7, $s7, 4
	addi $s0, $s0, 1
	sw $v0, 0($s7)
	


	
#heap 의 max index와 current index 초기화	
	
	
	
	addi $t7, $s0, 0
	addi $t9, $s0, 0


#새로운 입력이 들어오면 insert 알고리즘에의해 maxheap 구성하는 재귀적 과정(아래서 위로 heapify)


## heap insertion 에서 사용될 register
# $s0  max index(말단 노드 index)
# $t8  parent index
# $t7  current index
# $t6  parent value
# $t5  current value


insert:
	

	beq $t7, 1, load_heap
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
	bne $t0, 0, load_heap
	
	
	sw $t6, 0($t2)
	sw $t5, 0($t1)
	

	
	addi $t7, $t8, 0
	
	
	j insert
	







##정렬을 위해 heap array에서 stack으로 데이터를 가져옴

load_heap:
	
	# heap array[1]의 주소를 가져옴
	li $t0, 0
	mul $t1, $s0, 4
	sub $t1, $s7, $t1

	#heap array[1] 부터 끝까지 순차대로 stak에 값 저장
load_val:

	
	lw $t2, 0($t1)
	addi $sp, $sp -4
	sw $t2, 0($sp)
	
	beq $t0, $s0, sort_initial
	
	
	addi $t1, $t1, 4
	addi $t0, 1
	j load_val






## heap sort 과정 

##사용될 register 목록들
#s0 heap의 전체 크기
#t9 current max index
#t8 current index
#t7 current value
#t6 left value
#t5 right value
#t4 current address
#t3 left address
#t2 right address


#stack에 가져온 heap데이터를 sort 하기위해 필요한 초기화 과정 
sort_initial:
	
	#heap의 크기가 1이 되면 heap sort 종료
	beq $t9, 1 ,print_heap
	
	#첫번째 노드와 마지막 노드의 값을 바꾸는 과정
	sub $t0, $s0, $t9
	mul $t0, $t0, 4
	add $t0, $sp, $t0
	lw $t2 ,0($t0)
	
	sub $t1, $s0, 1
	mul $t1, $t1, 4
	add $t1, $sp, $t1
	lw $t3, 0($t1)
	
	sw $t3, 0($t0)
	sw $t2, 0($t1)
	

	# heap의 크기를 1 줄인다.
	sub $t9, $t9, 1

	#현재 index $t8, roof에서 아래로 heapify하므로 1로 줌
	li $t8, 1







sort_recur:


#case1 자식이 없을 경우 다음 노드에서 실행

	#left child의 index $t1 = current index *2 / $t1에 저장
	mul $t1, $t8, 2

	#left child index > current max index 보다 클경우 자식이 없음 다음 swap 진행
	slt $t3, $t9, $t1
	bne $t3, 0, sort_initial

	


#case2 자식이 하나일 경우

	#current address를 $t4에 저장하고 /current value를 $t7에 load한다.
	sub $t4, $s0, $t8
	mul $t4, $t4, 4
	add $t4, $sp, $t4
	lw $t7, 0($t4)

	#left child address를 $3에 저장하고 /left child value를 $t6에 load한다.
	sub $t3, $s0, $t1
	mul $t3, $t3, 4
	add $t3, $sp, $t3
	lw $t6, 0($t3)


	beq  $t1, $t9, one_child #아래 one_child:에서 값 비교 후 정렬 실행, 코드 효율성과 jump를 줄이기 위해 아래에 배치함.



#case3 자식이 둘인 경우

	#right child의 index $t2 = left child의  index+1 $t2에 저장
	addi $t2, $t1, 1 


	#right child address를 $2에 저장하고 /left child value를 $t5에 load한다.
	sub $t2, $s0, $t2
	mul $t2, $t2, 4
	add $t2, $sp, $t2
	lw $t5, 0($t2)


	#t7 current value
	#t6 left value
	#t5 right value
	#t4 current address
	#t3 left address
	#t2 right address



	#자기자신과  left child 비교
	slt $t0, $t7, $t6
	bne $t0, 0, small

	#자기 자신이  left child 보다 클때
	slt $t0, $t7, $t5
	bne $t0, 0, change_right
	j sort_initial


	#자기 자신이  left child보다 작을때
	small:

	slt $t0, $t6, $t5
	bne $t0 , 0 ,change_right
	j change_left


	
	
	#case2의 비교,정렬 / 자식이 하나일 경우 부모가 자식보다 작으면 jump 없이 바로 change_left 실행
	one_child:
	slt $t0, $t7, $t6
	beq $t0, 0, sort_initial


#부모와 left child의 값을 바꾸고 current index를 left child의 index로 바꿈 
change_left:
sw $t7, 0($t3)
sw $t6, 0($t4)
mul $t8, $t8, 2
j sort_recur	



#부모와 right child의 값을 바꾸고 current index를 right child의 index로 바꿈
change_right:
sw $t7, 0($t2)
sw $t5, 0($t4)
mul $t8, $t8, 2
addi $t8, $t8, 1
j sort_recur	






##heap sort가 끝난 후 stack에 저장된 값을 pop하면서 내림차순으로 출력


print_heap:
	# "출력:"을 출력함
	li $v0, 4
	la $a0, output
	syscall


	#반복 counting에 필요한 변수 t0 할당
	li $t0, 0

print_num:
	
	#출력이 끝난후 다시 입력으로 이동
	beq $t0, $s0, read
	addi $t0, $t0, 1
	
	#숫자 출력 및 스택포인터 반환 
	li $v0, 1
	lw $a0, 0($sp)
	syscall
	addi $sp, $sp, 4
	
	
	# 숫자사이 공백 출력
	li $v0, 4
	la $a0, space
	syscall
	
	#숫자 출력 반복하게 함
	j print_num


#"-9999입력시 프로그램 종료"
finish:
	li $v0, 10
	syscall
	