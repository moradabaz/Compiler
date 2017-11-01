   
  
 
   

            
      
     


###############################
# Seccion de datos
	 .data

$str2:
 	 .asciiz "\n" 
$str1:
 	 .asciiz "c = " 
_d: 
 	 .word 0 
_c: 
 	 .word 0 
_b: 
 	 .word 0 
_a: 
 	 .word 0 
	
########################
# Seccion de codigo 
     .text

     .globl main
main:
     li  $t0, 0
     sw  $t0, _a
     li  $t0, 0
     sw  $t0, _b
     li  $t0, 6
     li  $t1, 2
     add  $t2, $t0, $t1
     li  $t0, 2
     sub  $t1, $t2, $t0
     sw  $t1, _c
     li  $t0, 0
     sw  $t0, _d
     li  $t0, 0
     sw $t0, _d
     lw  $t1, _d
     li  $t2, 4
     slt $t3, $t1, $t2
 Label1:
     sb $t4, _d
     bnez $t1, Label2
     lw  $t1, _c
     li  $t2, 1
     add  $t5, $t1, $t2
     sw  $t5, _c
     la  $a0 , $str1
     li  $v0 , 4
     syscall
     lw  $t1, _c
     move  $a0 , $t1
     li  $v0 , 1
     syscall
     la  $a0 , $str2
     li  $v0 , 4
     syscall
     lw  $t1, _d
     li  $t2, 1
     add  $t4, $t1, $t2
     sw $t4, _d
     b, Label1
 Label2:

########################
# Fin
	jr $ra

