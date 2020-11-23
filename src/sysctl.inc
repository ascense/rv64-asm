# Clocks
.equ SYSCTL_CLK_GPIO, 0x01

# Central clock enable register
.equ SYSCTL_CLK_EN_CENT, 0x28
# Central clock enable offsets
.equ SYSCTL_CLK_APB0_EN, 0x0C
.equ SYSCTL_CLK_APB1_EN, 0x10
.equ SYSCTL_CLK_APB2_EN, 0x14

# Peripheral clock enable register
.equ SYSCTL_CLK_EN_PERI, 0x2C
# Peripheral clock enable offsets
.equ SYSCTL_CLK_GPIO_EN, 0x05
