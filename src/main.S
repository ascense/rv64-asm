.section .text
.balign 8
.global main

.include "gpio.inc"

main:
    call gpio_setup

    li s1, 1

    li a0, GPIO_RGB_RED
    mv a1, s1
    call asm_gpio_set_pin

    li a0, GPIO_RGB_GREEN
    mv a1, s1
    call asm_gpio_set_pin

    li a0, GPIO_RGB_BLUE
    mv a1, s1
    call asm_gpio_set_pin

1:  # blink led forever
    # sleep 1 second
    li a0, 1000000
    call delay

    # toggle value
    not s1, s1
    andi s1, s1, 1

    # set led
    li a0, GPIO_RGB_GREEN
    mv a1, s1
    call asm_gpio_set_pin

    j 1b
