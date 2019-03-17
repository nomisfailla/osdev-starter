#include <types.h>

void kmain(uint32_t mbootptr, uint32_t magic)
{
    char* msg = "Hello, world!";
    char* video = (char*)0xB8000;
    while(*msg)
    {
        *video++ = *msg++;
        *video++ = 0x03;
    }
    for(;;);
}
