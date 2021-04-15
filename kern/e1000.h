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

int attach_82540EM(struct pci_func *f);

int transmit_packet(const void *base, size_t size);
#endif  // SOL >= 6
