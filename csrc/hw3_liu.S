.org 0
.global _start

/* newlib system calls */
.set SYSEXIT,  93
.set SYSWRITE, 64


.data
     list:.word 4353
     string1: .string "leading zeros:"
.text    

# this is 32 unsign int clz computation for three node for list 
_start:
  li s6, 0x4
  la  s0,list
  lw  a0,0(s0)   
  
clz:
#s0 is x
add s0,x0,a0

#x|=(x>>1)
srli t0,s0,1
or s0,s0,t0

#x|=(x>>2)
srli t0,s0,2
or s0,s0,t0

#x|=(x>>4)
srli t0,s0,4
or s0,s0,t0

#x|=(x>>8)
srli t0,s0,8
or s0,s0,t0

#x|=(x>>16)
srli t0,s0,16
or s0,s0,t0

#x -= ((x>>1) & 0x55555555)
li t1,0x55555555
srli t0,s0,1
and t0,t0,t1
sub s0,s0,t0


#x = ((x>>2) & 0x33333333)+(x &0x33333333)
li t1,0x33333333
srli t0,s0,2
and t0,t0,t1
and t1,s0,t1
add s0,t0,t1

#x = ((x>>2) +4)&0x0f0f0f0f
srli t0,s0,4
add t0,t0,s0
li t1,0x0f0f0f0f
and s0,t0,t1

#x += (x>>8) 
srli t0,s0,8
add s0,t0,s0

#x += (x>>16) 
srli t0,s0,16
add s0,t0,s0

#(32-(x&0x1f))
li a0,32
andi t0,s0,0x1f
sub a0,a0,t0

result:
sw   a0, 0(s6)          # store the result into address s6
li a0, 1
la a1, string1
li a7, SYSWRITE
li a7, SYSEXIT   # "exit" syscall
ecall
 


