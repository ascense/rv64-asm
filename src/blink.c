#include <stdio.h>
#include <unistd.h>

#include "blink.h"

int main()
{
    int64_t result = 0;

    result = gpio_setup();

    result |= asm_gpio_set_pin(GPIO_RGB_RED, 1u);
    result |= asm_gpio_set_pin(GPIO_RGB_GREEN, 1u);
    result |= asm_gpio_set_pin(GPIO_RGB_BLUE, 1u);

    if (result != 0)
    {
        printf("Failure: %lx\n", result);
    }
    printf("Setup done\n");

    uint8_t value = 1;
    while(1)
    {
        sleep(1);
        asm_gpio_set_pin(GPIO_RGB_GREEN, value = !value);
    }

    return 0;
}
