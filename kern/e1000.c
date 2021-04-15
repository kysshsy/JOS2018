// LAB 6: Your driver code here
#include <kern/e1000.h>
#include <kern/pmap.h>

// transmit control register offset
#define OFF_TDBAL 0x03800 // R/W
#define OFF_TDBAH 0x03804 // R/W
#define OFF_TDLEN 0x03808 // R/W
#define OFF_TDH   0x03810 // R/W
#define OFF_TDT   0x03818 // R/W
#define OFF_TCTL  0x00400 // R/W
#define OFF_TIPG  0x00410 // R/W

#define TCTL_EN   (0x1 << 1)
#define TCTL_PSP  (0x1 << 3)
#define TCTL_CT   (0x10 << 3)
#define TCTL_COLD (0x40 << 12)

#define IPGT      10
#define IPGR1     (8 << 10)
#define IPGR2     (12 << 20)

volatile uint32_t *e1000;

static struct tx_legacy tx_dt[64];
static char packet_buffer[64][1518];

int attach_82540EM(struct pci_func *f){
    pci_func_enable(f);
    //  mapping I/O
    // ex4 mapping for e1000's bar 0
    e1000 = mmio_map_region(f->reg_base[0], f->reg_size[0]);
    uint32_t *test_ptr = (uint32_t *)e1000 + 2;
    
    if (*test_ptr != 0x80080783){
        cprintf("mmio value: 0x%08x  should be 0x80080783\n", *test_ptr);
    } 
    assert(*test_ptr == 0x80080783);
 
    // descriptor and buffer setting


    for (int i = 0; i < 64; i++){
        tx_dt[i].addr = PADDR(packet_buffer[i]);
    }
    //  initial 82540EM register according to 14.5 

    // Transmit Descriptor Base Address Low
    *(uint32_t*)((char*)e1000 + OFF_TDBAL) = PADDR(tx_dt);

    // Transmit Descriptor Base Address High (not need for 32bit address)
    // *(uint32_t*)((char*)e1000 + OFF_TDBAH) = 0x0;

    // Transmit Descriptor Length
    *(uint32_t*)((char*)e1000 + OFF_TDLEN) = sizeof(tx_dt);

    // Transmit Descriptor Head
    *(uint32_t*)((char*)e1000 + OFF_TDH) = 0x0;
    // Transmit Descriptor Tail
    *(uint32_t*)((char*)e1000 + OFF_TDT) = 0x0;
    
    // Transmit Control Register
    volatile uint32_t *TCTL = (uint32_t*)((char*)e1000 + OFF_TCTL);

    // EN -> PSP -> CT -> COLD
    *TCTL |= TCTL_EN;
    *TCTL |= TCTL_PSP;
    *TCTL |= TCTL_CT;
    *TCTL |= TCTL_COLD;
    
    //This register controls the IPG (Inter Packet Gap) timer for the Ethernet controller.
    *(uint32_t*)((char*)e1000 + OFF_TIPG) = (IPGR2 | IPGR1 | IPGT); 
    
    return 0;
}