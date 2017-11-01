   
  
 
 
     
      
         
       
        
        
   
###############################
# Seccion de datos
	 .data

$str6:
 	 .asciiz "Final" 
$str5:
 	 .asciiz "c = " 
$str4:
 	 .asciiz "No a y b\n" 
$str3:
 	 .asciiz "\n" 
$str2:
 	 .asciiz "a" 
$str1:
 	 .asciiz "Inicio del programa\n" 
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
     li  $t0, 5
     li  $t1, 2
     add  $t2, $t0, $t1
     li  $t0, 2
     sub  $t1, $t2, $t0
     sw  $t1, _c
     la  $a0 , $str1
     li  $v0 , 4
     syscall
     lw  $t0, _a
     li  $t1, 0
     beqz  $t0, $l4
     la  $a0 , $str2
     li  $v0 , 4
     syscall
     la  $a0 , $str3
     li  $v0 , 4
     syscall
     b  $l5
 $l4:
     lw  $t0, _b
     beqz  $t0, $l2
     la  $a0 , $str4
     li  $v0 , 4
     syscall
     b  $l3
 $l2:
 $l1:
     la  $a0 , $str5
     li  $v0 , 4
     syscall
     lw  $t1, _c
     move  $a0 , $t1
     li  $v0 , 1
     syscall
     la  $a0 , $str3
     li  $v0 , 4
     syscall
     lw  $t1, _c
     li  $t3, 2
     sub  $t4, $t1, $t3
     li  $t1, 1
     add  $t3, $t4, $t1
     sw  $t3, _c
     lw  $t1, _c
     li  $t3, 0
     sne $t4, $t1, $t3
     bnez $t1, $l1
 $l3:
 $l5:
     la  $a0 , $str6
     li  $v0 , 4
     syscall
     la  $a0 , $str3
     li  $v0 , 4
     syscall

########################
# Fin
	jr $ra

