#include <stdint.h>

#define GPIO_RGB_RED (5)
#define GPIO_RGB_GREEN (4)
#define GPIO_RGB_BLUE (6)

int64_t gpio_setup(void);

int64_t asm_gpio_set_pin(uint8_t pin, uint8_t val);

void asm_fpioa_set_function(uint8_t io_num, uint8_t func);
