.section .text
.balign 4

.include "mmap.inc"
.include "fpioa.inc"

# a0 - function
# Returns: io number or -1
.globl asm_fpioa_get_io_by_function
asm_fpioa_get_io_by_function:
    addi sp, sp, -16
    sd ra, 8(sp)

    li t0, FPIOA_BASE_ADDR
    li t1, FPIOA_IO_MAX
    mv t2, zero
    li t6, FPIOA_IO_CFG_SIZE

2:  # loop
    mul t3, t2, t6
    add t3, t0, t3
    lwu t4, 0(t3)

    andi t4, t4, FPIOA_IO_CFG_CH_SEL
    beq t4, a0, 0f

    addi t2, t2, 1
    ble t2, t1, 2b

    # no match found, error out
    li t2, -1

0:  # exit
    mv a0, t2

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# a0 - io number
# a1 - function
.globl asm_fpioa_set_function_raw
asm_fpioa_set_function_raw:
    addi sp, sp, -16
    sd ra, 8(sp)

    # TODO: validate input

    li t0, FPIOA_BASE_ADDR
    li t1, FPIOA_IO_CFG_SIZE
    mul t1, t1, a0
    add t0, t0, t1

    # TODO: support functions other than GPIO
    li t2, FPIOA_FUNC_CFG_GPIO
    or t2, t2, a1
    sw t2, 0(t0)

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# a0 - io number
# a1 - pull mode
# Returns: 0 if successful, -1 otherwise
.globl asm_fpioa_set_io_pull
asm_fpioa_set_io_pull:
    addi sp, sp, -16
    sd ra, 8(sp)

    # validate io number
    li t4, FPIOA_IO_MAX
    bgtu a0, t4, 0f

    # caluclate IO register address
    li t0, FPIOA_BASE_ADDR
    li t1, FPIOA_IO_CFG_SIZE
    mul t1, a0, t1
    add t0, t0, t1

    # read cfg from IO register
    lwu t1, 0(t0)

    li t2, FPIOA_PULL_NONE
    beq a1, t2, 1f
    li t2, FPIOA_PULL_DOWN
    beq a1, t2, 2f
    li t2, FPIOA_PULL_UP
    beq a1, t2, 3f

0:  # error, invalid arguments
    li a0, -1
    j 0f

1:  # set pull none
    li t2, FPIOA_IO_CFG_PU
    not t2, t2
    and t1, t1, t2 # disable pull up
    li t2, FPIOA_IO_CFG_PD
    not t2, t2
    and t1, t1, t2 # disable pull down
    j 4f

2:  # set pull down
    li t2, FPIOA_IO_CFG_PU
    not t2, t2
    and t1, t1, t2 # disable pull up
    li t2, FPIOA_IO_CFG_PD
    or t1, t1, t2 # enable pull down
    j 4f

3:  # set pull up
    li t2, FPIOA_IO_CFG_PU
    or t1, t1, t2 # enable pull up
    li t2, FPIOA_IO_CFG_PD
    not t2, t2
    and t1, t1, t2 # disable pull down

4:
    sw t1, 0(t0) # write cfg to IO register
    li a0, 0 # success

0:  # exit
    ld ra, 8(sp)
    addi sp, sp, 16
    ret
