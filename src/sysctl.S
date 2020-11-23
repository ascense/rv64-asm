.section .text
.balign 8
.global asm_sysctl_clk_enable

.include "mmap.inc"
.include "sysctl.inc"

asm_sysctl_clk_enable:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0, a0
    call .sysctl_clk_bus_enable

    mv a0, s0
    call .sysctl_clk_dev_enable

    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret

# TODO: Support clocks other than GPIO
.sysctl_clk_bus_enable:
    addi sp, sp, -16
    sd ra, 8(sp)

    # calculate base address for central clock enable register
    li t0, SYSCTL_BASE_ADDR
    addi t0, t0, SYSCTL_CLK_EN_CENT

    # enable APB0
    li t1, 1
    sw t1, SYSCTL_CLK_APB0_EN(t0)

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# TODO: Support clocks other than GPIO
.sysctl_clk_dev_enable:
    addi sp, sp, -16
    sd ra, 8(sp)

    # calculate base address for peripheral clock enable register
    li t0, SYSCTL_BASE_ADDR
    addi t0, t0, SYSCTL_CLK_EN_PERI

    # enable GPIO clock
    li t1, 1
    sw t1, SYSCTL_CLK_GPIO_EN(t0)

    ld ra, 8(sp)
    addi sp, sp, 16
    ret
