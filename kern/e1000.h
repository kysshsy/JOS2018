#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H


#define VENDOR_ID_82540EM 0x8086
#define DEVICE_ID_82540EM 0x100E
#include <kern/pci.h>



union TDesc{
    struct tx_legacy
    {
        uint64_t addr;
        uint16_t length;
        uint8_t cso;
        
        union {
            struct {
                uint8_t EOP  : 1;
                uint8_t IFCS : 1;
                uint8_t IC   : 1;
                uint8_t RS   : 1;
                uint8_t RSV  : 1;
                uint8_t DEXT : 1;
                uint8_t VLE  : 1;
                uint8_t IDE  : 1;
            };
            uint8_t value; 
        }cmd;

        union {
            struct {
                uint8_t DD   : 1;
                uint8_t EC   : 1;
                uint8_t LC   : 1;
                uint8_t RSV  : 5;
            };
            uint8_t value;
        }status;
        uint8_t css;
        uint16_t special;
    }legacy;
};

struct rx{
    uint64_t addr;
    uint16_t length;
    uint16_t RSV1;

    union {
        struct {
            uint8_t DD    : 1;
            uint8_t EOP   : 1;
            uint8_t IXSM  : 1;
            uint8_t VP    : 1;
            uint8_t RSV   : 1;
            uint8_t TCPCS : 1;
            uint8_t IPCS  : 1;
            uint8_t PIF   : 1;
        };
        uint8_t value;
    }status;

    union {
        struct {
            uint8_t CE       : 1;
            uint8_t RSV_SE   : 1;
            uint8_t RSV_SEQ  : 1;
            uint8_t RSV      : 1;
            uint8_t RSV2     : 1;
            uint8_t TCPE     : 1;
            uint8_t IPE      : 1;
            uint8_t RXE      : 1;
        };
        uint8_t value;
    }error;
    uint16_t RSV2;
};
int attach_82540EM(struct pci_func *f);

int transmit_packet(const void *base, size_t size);
int receive_packet(void *base, size_t size);
#endif  // SOL >= 6
