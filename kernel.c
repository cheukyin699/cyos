#include <stddef.h>
#include <stdint.h>

uint16_t mk_vgaentry(char c, uint8_t color)
{
	uint16_t c16 = c;
	uint16_t col16 = color;
	return c16 | col16 << 8;
}

size_t strlen(const char* str)
{
	size_t ret=0;
	while(str[ret] != 0)
		ret++;
	return ret;
}

static const size_t VGA_W = 80;
static const size_t VGA_H = 24;

size_t t_row;
size_t t_col;
uint8_t t_color;
uint16_t* t_buf;

void t_init()
{
	t_row = 0;
	t_col = 0;
	t_color = 0;
	t_buf = (uint16_t*) 0xB8000;		/* This is where the terminal is */
	for(size_t y=0; y<VGA_H; y++)
	{
		for(size_t x=0; x<VGA_W; x++)
		{
			const size_t index = y*VGA_W + x;
			t_buf[index] = mk_vgaentry(' ', t_color);
		}
	}
}

void t_setcolor(uint8_t color)
{
	t_color = color;
}

void t_putentat(char c, uint8_t color, size_t x, size_t y)
{
	const size_t index = y*VGA_W + x;
	t_buf[index] = mk_vgaentry(c, color);
}

void t_putchar(char c)
{
	t_putentat(c, t_color, t_col, t_row);
	if(++t_col == VGA_W)
	{
		t_col = 0;
		if(++t_row == VGA_H)
			t_row = 0;
	}
}

void t_printstr(const char* str)
{
	size_t len = strlen(str);
	for(size_t i=0; i<len; i++)
		t_putchar(str[i]);
}

void kernel_main()
{
	t_init();
	t_printstr("Welcome to CYOS!");
	while(1)
	{
		;
	}
}
