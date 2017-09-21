#include "main.h"
#include "configureSystemF4.h"
int main(void)
{
	HAL_Init();
	/* Configure the system clock to 168 MHz */
	System_Clock_Config();
	/* Infinite loop */
	GPIO_InitTypeDef GPIO_InitStruction;
	__GPIOD_CLK_ENABLE();
	__GPIOA_CLK_ENABLE();
	GPIO_InitStruction.Pin = GPIO_PIN_12 | GPIO_PIN_13 | GPIO_PIN_14 | GPIO_PIN_15;
	GPIO_InitStruction.Mode = GPIO_MODE_OUTPUT_PP;
	GPIO_InitStruction.Pull = GPIO_PULLUP;
	GPIO_InitStruction.Speed = GPIO_SPEED_MEDIUM;
	HAL_GPIO_Init(GPIOD,&GPIO_InitStruction);
	while (1)
	{		// Add your code here.
		//	  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_SET);
		//	  HAL_Delay(1000);
		//	  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_RESET);
		//	  HAL_Delay(1000);
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


