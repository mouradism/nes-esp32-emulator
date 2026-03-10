#ifndef CPU_6502_H
#define CPU_6502_H

#include <stdint.h>

// CPU Status flags
#define FLAG_CARRY     0x01
#define FLAG_ZERO      0x02
#define FLAG_INTERRUPT 0x04
#define FLAG_DECIMAL   0x08
#define FLAG_BREAK     0x10
#define FLAG_UNUSED    0x20
#define FLAG_OVERFLOW  0x40
#define FLAG_NEGATIVE  0x80

class CPU6502 {
public:
    CPU6502();
    void reset();
    void clock();
    bool isComplete();
    
    // Registers
    uint8_t A;      // Accumulator
    uint8_t X;      // X Register
    uint8_t Y;      // Y Register
    uint8_t SP;     // Stack Pointer
    uint16_t PC;    // Program Counter
    uint8_t status; // Status Register
    
    // Cycle counter
    uint32_t cycles;
    
private:
    uint8_t fetch();
    uint8_t read(uint16_t addr);
    void write(uint16_t addr, uint8_t data);
    
    // Addressing modes
    uint8_t IMP(); uint8_t IMM(); uint8_t ZP0(); uint8_t ZPX();
    uint8_t ZPY(); uint8_t REL(); uint8_t ABS(); uint8_t ABX();
    uint8_t ABY(); uint8_t IND(); uint8_t IZX(); uint8_t IZY();
    
    // Opcodes (renamed to avoid ESP32 macro conflicts)
    uint8_t OP_ADC(); uint8_t OP_AND(); uint8_t OP_ASL(); uint8_t OP_BCC();
    uint8_t OP_BCS(); uint8_t OP_BEQ(); uint8_t OP_BIT(); uint8_t OP_BMI();
    uint8_t OP_BNE(); uint8_t OP_BPL(); uint8_t OP_BRK(); uint8_t OP_BVC();
    uint8_t OP_BVS(); uint8_t OP_CLC(); uint8_t OP_CLD(); uint8_t OP_CLI();
    uint8_t OP_CLV(); uint8_t OP_CMP(); uint8_t OP_CPX(); uint8_t OP_CPY();
    uint8_t OP_DEC(); uint8_t OP_DEX(); uint8_t OP_DEY(); uint8_t OP_EOR();
    uint8_t OP_INC(); uint8_t OP_INX(); uint8_t OP_INY(); uint8_t OP_JMP();
    uint8_t OP_JSR(); uint8_t OP_LDA(); uint8_t OP_LDX(); uint8_t OP_LDY();
    uint8_t OP_LSR(); uint8_t OP_NOP(); uint8_t OP_ORA(); uint8_t OP_PHA();
    uint8_t OP_PHP(); uint8_t OP_PLA(); uint8_t OP_PLP(); uint8_t OP_ROL();
    uint8_t OP_ROR(); uint8_t OP_RTI(); uint8_t OP_RTS(); uint8_t OP_SBC();
    uint8_t OP_SEC(); uint8_t OP_SED(); uint8_t OP_SEI(); uint8_t OP_STA();
    uint8_t OP_STX(); uint8_t OP_STY(); uint8_t OP_TAX(); uint8_t OP_TAY();
    uint8_t OP_TSX(); uint8_t OP_TXA(); uint8_t OP_TXS(); uint8_t OP_TYA();
    uint8_t OP_XXX(); // Illegal opcode
    
    uint8_t fetched;
    uint16_t addr_abs;
    uint16_t addr_rel;
    uint8_t opcode;
    uint8_t remaining_cycles;
};

#endif // CPU_6502_H
