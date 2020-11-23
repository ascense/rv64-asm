.section .text
.balign 8
.global gpio_setup, asm_gpio_set_drive_mode, asm_gpio_set_pin, asm_gpio_set_bit

.include "mmap.inc"
.include "gpio.inc"
.include "fpioa.inc"
.include "sysctl.inc"

gpio_setup:
    addi sp, sp, -16
    sd ra, 8(sp)

    # configure FPIOA for led
    li a0, FPIOA_RGB_RED
    li a1, FPIOA_FUNC_GPIO0
    addi a1, a1, GPIO_RGB_RED
    call asm_fpioa_set_function_raw

    li a0, FPIOA_RGB_GREEN
    li a1, FPIOA_FUNC_GPIO0
    addi a1, a1, GPIO_RGB_GREEN
    call asm_fpioa_set_function_raw

    li a0, FPIOA_RGB_BLUE
    li a1, FPIOA_FUNC_GPIO0
    addi a1, a1, GPIO_RGB_BLUE
    call asm_fpioa_set_function_raw

    # enable GPIO clock
    li a0, SYSCTL_CLK_GPIO
    call asm_sysctl_clk_enable

    # setup GPIO outputs for led
    li a0, GPIO_RGB_RED
    li a1, GPIO_DM_OUTPUT
    call asm_gpio_set_drive_mode

    li a0, GPIO_RGB_GREEN
    li a1, GPIO_DM_OUTPUT
    call asm_gpio_set_drive_mode

    li a0, GPIO_RGB_BLUE
    li a1, GPIO_DM_OUTPUT
    call asm_gpio_set_drive_mode

    mv a0, zero

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# a0 - pin
# a1 - drive mode
asm_gpio_set_drive_mode:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1, a1

    li t0, GPIO_PIN_MAX
    bgtu a0, t0, 10f

    addi a0, a0, FPIOA_FUNC_GPIO0
    call asm_fpioa_get_io_by_function
    bltz a0, 10f

    li t1, GPIO_DM_INPUT
    beq s1, t1, 1f
    li t1, GPIO_DM_OUTPUT
    beq s1, t1, 2f
    j 10f

1:  # input mode
    li a1, FPIOA_PULL_NONE
    li s1, 0
    j 3f

2:  # output mode
    li a1, FPIOA_PULL_DOWN
    li s1, 1

3:  # a0 = io_number, a1 = pull mode
    call asm_fpioa_set_io_pull
    bltz a0, 10f

    # apply value to GPIO direction register
    li t0, GPIO_BASE_ADDR
    addi a0, t0, GPIO_CFG_DIRECTION
    mv a1, s0
    mv a2, s1
    call asm_gpio_set_bit
    j 0f

10: # error
    li a0, -1

0:  # exit
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret

# a0 - pin
# a1 - value
asm_gpio_set_pin:
    addi sp, sp, -16
    sd ra, 8(sp)

    # TODO: validate pin direction & value

    li t0, GPIO_PIN_MAX
    bgtu a0, t0, 1f

    mv a2, a1
    mv a1, a0

    li t0, GPIO_BASE_ADDR
    addi a0, t0, GPIO_CFG_OUTPUT

    call asm_gpio_set_bit

    mv a0, zero
    j 0f

1:  # error
    li a0, -1

0:  # exit
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# a0 - register address
# a1 - bit
# a2 - value
asm_gpio_set_bit:
    addi sp, sp, -16
    sd ra, 8(sp)

    # calculate masks for GPIO register bit
    li t1, 1
    sll t1, t1, a1 # bitmask
    sll t2, a2, a1 # value

    # load register
    lwu t0, 0(a0)

    # apply bit
    not t1, t1
    and t0, t0, t1
    or t0, t0, t2

    # write back new register value
    sw t0, 0(a0)

    ld ra, 8(sp)
    addi sp, sp, 16
    ret
