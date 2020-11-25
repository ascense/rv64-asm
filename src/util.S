.section .text
.balign 8
.global delay

.include "util.inc"

# a0 - ms to sleep
delay:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s1, 16(sp)
    sd s2, 8(sp)

    csrr s1, mcycle
    mv s2, a0

    # calculate time to stop looping
    #call asm_sysctl_clk_get_freq
    li a0, 300000000 # DBG
    li t1, USEC_IN_SEC
    div t0, a0, t1
    mul t0, t0, s2
    add t0, t0, s1

1:  # loop until done
    csrr t1, mcycle
    blt t1, t0, 1b

    ld ra, 24(sp)
    ld s1, 16(sp)
    ld s2, 8(sp)
    addi sp, sp, 32
    ret
