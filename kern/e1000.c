// LAB 6: Your driver code here
#include <kern/e1000.h>
#include <kern/pmap.h>
#include <inc/string.h>

#define OFF_CTRL 0x00000 // device register

#define CTRL_RESET (0x1 << 26)

// transmit control register offset
#define OFF_TDBAL 0x03800 // R/W
#define OFF_TDBAH 0x03804 // R/W
#define OFF_TDLEN 0x03808 // R/W
#define OFF_TDH 0x03810   // R/W
#define OFF_TDT 0x03818   // R/W
#define OFF_TCTL 0x00400  // R/W
#define OFF_TIPG 0x00410  // R/W

#define TCTL_EN (0x1 << 1)
#define TCTL_PSP (0x1 << 3)
#define TCTL_CT (0x10 << 3)
#define TCTL_COLD (0x40 << 12)

#define IPGT 10
#define IPGR1 (8 << 10)
#define IPGR2 (12 << 20)

#define DESC_SIZE 64      //must be multiple of 8
volatile uint32_t *e1000;

static struct tx_legacy tx_dt[DESC_SIZE];
static char packet_buffer[DESC_SIZE][1500];

static int test_transmit();

int transmit_packet(const void *base, size_t size)
{

    // check the descriptor in ring structure
    volatile uint32_t *TDT = (uint32_t *)((char *)e1000 + OFF_TDT);

    // check ring is full
    if (tx_dt[*TDT].cmd.RS == 1 && tx_dt[*TDT].status.DD == 0)
    {
        // fail return
        return -E_NO_MEM;
    }
    // copy data
    assert(size <= 1500);

    memcpy(KADDR(tx_dt[*TDT].addr), base, size);
    tx_dt[*TDT].length = size;
    // update descriptor
    tx_dt[*TDT].cmd.RS = 1;
    tx_dt[*TDT].status.DD = 0;

    *TDT = (*TDT + 1) % DESC_SIZE;
    return 0;
}

int attach_82540EM(struct pci_func *f)
{
    pci_func_enable(f);
    //  mapping I/O
    // ex4 mapping for e1000's bar 0
    e1000 = mmio_map_region(f->reg_base[0], f->reg_size[0]);
    uint32_t *test_ptr = (uint32_t *)e1000 + 2;

    if (*test_ptr != 0x80080783)
    {
        cprintf("mmio value: 0x%08x  should be 0x80080783\n", *test_ptr);
    }
    assert(*test_ptr == 0x80080783);

    // descriptor and buffer setting
    sizeof(struct tx_legacy);
    for (int i = 0; i < DESC_SIZE; i++)
    {
        tx_dt[i].addr = PADDR(packet_buffer[i]);
    }
    //  initial 82540EM register according to 14.5

    // reset device
    //*(uint32_t*)((char *)e1000 + OFF_CTRL) |= CTRL_RESET;

    // Transmit Descriptor Base Address Low
    *(uint32_t *)((char *)e1000 + OFF_TDBAL) = PADDR(tx_dt);

    // Transmit Descriptor Base Address High (not need for 32bit address)
    // *(uint32_t*)((char*)e1000 + OFF_TDBAH) = 0x0;

    // Transmit Descriptor Length
    *(uint32_t*)((char*)e1000 + OFF_TDLEN) = sizeof(tx_dt);

    
    // Transmit Descriptor Head    
    *(uint32_t *)((char *)e1000 + OFF_TDH) = 0x0;
    // Transmit Descriptor Tail
    *(uint32_t *)((char *)e1000 + OFF_TDT) = 0x0;

    // Transmit Control Register
    volatile uint32_t *TCTL = (uint32_t *)((char *)e1000 + OFF_TCTL);


    // EN -> PSP -> CT -> COLD
    *TCTL |= TCTL_EN;
    *TCTL |= TCTL_PSP;
    *TCTL |= TCTL_CT;
    *TCTL |= TCTL_COLD;

    //This register controls the IPG (Inter Packet Gap) timer for the Ethernet controller.
    *(uint32_t *)((char *)e1000 + OFF_TIPG) = (IPGR2 | IPGR1 | IPGT);

    assert(test_transmit() == 0); 
    return 0;
}

static int test_transmit()
{
    char *string[] = {
        "123123",
        "sfsdfds",
        "dsfsdf",
    };
    int r;
    for (int i = 0; i < 2 * DESC_SIZE; i++){
        if (( r = transmit_packet(string[i%3], strlen(string[i%3]))) < 0){
            return r;
        }
    }
    return 0;
}