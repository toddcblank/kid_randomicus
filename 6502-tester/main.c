#include "MCS6502.h"
#include <stdio.h>

#define MEM_SIZE 0xFFFF

uint8 memory[MEM_SIZE];


void printResult(uint8 lb, uint8 hb) {
    printf("%02x%02x:\t", lb, hb);
    for (int i = 0; i < 0x8; i++) {
            printf("%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",                
                memory[i * 0x10 + 0x4000],
                memory[i * 0x10 + 0x4001],
                memory[i * 0x10 + 0x4002],
                memory[i * 0x10 + 0x4003],
                memory[i * 0x10 + 0x4004],
                memory[i * 0x10 + 0x4005],
                memory[i * 0x10 + 0x4006],
                memory[i * 0x10 + 0x4007],
                memory[i * 0x10 + 0x4008],
                memory[i * 0x10 + 0x4009],
                memory[i * 0x10 + 0x400a],
                memory[i * 0x10 + 0x400b],
                memory[i * 0x10 + 0x400c],
                memory[i * 0x10 + 0x400d],
                memory[i * 0x10 + 0x400e],
                memory[i * 0x10 + 0x400f]
            );
        }
        printf("\n");
}
//ffff ffa9 01ff ffff 8d1e 01ff ffff 8d1f 01ff ffff ad1e 01ff ffff 8dff ffff 9701 ffff ffad 1f
void printRawBytes(uint8* mem) {
    for (int i = 0x300; i < 0x326; i++) {
        printf("%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\n",
            mem[i * 0x10 + 0x0],
            mem[i * 0x10 + 0x1],
            mem[i * 0x10 + 0x2],
            mem[i * 0x10 + 0x3],
            mem[i * 0x10 + 0x4],
            mem[i * 0x10 + 0x5],
            mem[i * 0x10 + 0x6],
            mem[i * 0x10 + 0x7],
            mem[i * 0x10 + 0x8],
            mem[i * 0x10 + 0x9],
            mem[i * 0x10 + 0xa],
            mem[i * 0x10 + 0xb],
            mem[i * 0x10 + 0xc],
            mem[i * 0x10 + 0xd],
            mem[i * 0x10 + 0xe],
            mem[i * 0x10 + 0xf]
        );
    }
}

void initializeMemory() {
    FILE *fp;
    fp = fopen("existing.bin", "r");
    uint8 buffer[1024];
    int bytesRead = fread(buffer, sizeof(uint8), MEM_SIZE, (FILE*)fp);
    fclose(fp);
    //printf("Read %d into Memory\n", bytesRead);
    for (int i = 0; i < MEM_SIZE; i++) {memory[i] = 0x0;}
    for (int i = 0; i < 1024; i++) {
        memory[0x3000 + i] = buffer[i];
    }
    memory[0xFFFD] = 0x30;
    //printRawBytes(memory);
}

uint8 readBytesFunction(uint16 address, void * readWriteContext) {
    
    uint8 value = memory[address];
    //printf("Reading Byte %d: %02x\n", address, value);
    return value;
}

void writeBytesFunction(uint16 address, uint8 value, void * readWriteContext) {
    //printf("Writing Byte %d\n", address);
    if(address > (sizeof(memory)/sizeof(memory[0]))) {
        printf("WRITE OUT OF BOUNDS\n");
        return;
    }
    //if (address == 0x0070) {printf("Room Count: %02x\n", value);}

    memory[address] = value;
    return;
}


int generateDungeon(uint8 seed_lb, uint8 seed_hb) {
     
   initializeMemory();
   memory[0x011E] = seed_lb;
   memory[0x011F] = seed_hb;

   MCS6502ExecutionContext context;
   MCS6502Init(&context, readBytesFunction, writeBytesFunction, NULL);  // Final param is optional context.
   MCS6502Reset(&context);

   MCS6502ExecResult result = MCS6502Tick(&context);
   while(result == MCS6502ExecResultRunning) {
       result = MCS6502Tick(&context);
   }

   printResult(seed_lb, seed_hb);
   return 0;
}

int main() {
    //setbuf(stdout, NULL);
    for (uint8 lb = 0x00; lb < 0xFF; lb++) {
        for (uint8 hb = 0x00; hb < 0xFF; hb++) {
            generateDungeon(lb + 1, hb + 1);
        }
    }
}

