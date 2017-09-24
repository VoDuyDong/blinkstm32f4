#include <stdio.h>
#include <stdlib.h>
#include "diag/Trace.h"
#include "configureSystemF4.h"
#include "stm32f4xx_hal.h"

int main(void)
{
  // At this stage the system clock should have already been configured
  // at high speed.

  // Infinite loop
	HAL_Init();

	System_Clock_Config();

	GPIO_InitTypeDef GPIO_InitStruction;
	__GPIOD_CLK_ENABLE();
	__GPIOA_CLK_ENABLE();
	GPIO_InitStruction.Pin = GPIO_PIN_12 | GPIO_PIN_13 | GPIO_PIN_14 | GPIO_PIN_15;
	GPIO_InitStruction.Mode = GPIO_MODE_OUTPUT_PP;
	GPIO_InitStruction.Pull = GPIO_PULLUP;
	GPIO_InitStruction.Speed = GPIO_SPEED_MEDIUM;
	HAL_GPIO_Init(GPIOD,&GPIO_InitStruction);
	while (1)
    {
       // Add your code here.
	HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_12);
	HAL_Delay(250);
	HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_13);
	HAL_Delay(250);
	HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_14);
	HAL_Delay(250);
	HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_15);
	HAL_Delay(250);
    }
}

