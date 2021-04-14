#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H


#define VENDOR_ID_82540EM 0x8086
#define DEVICE_ID_82540EM 0x100E
#include <kern/pci.h>

int attach_82540EM(struct pci_func *f);

#endif  // SOL >= 6
