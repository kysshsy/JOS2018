// LAB 6: Your driver code here
// https://pdos.csail.mit.edu/6.828/2018/readings/hardware/8254x_GBe_SDM.pdf
#include <kern/e1000.h>
#include <kern/pmap.h>
#include <inc/string.h>
#include <inc/error.h>

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

#define TXDESC_SIZE 64      //must be multiple of 8
#define RXDESC_SIZE 128
#define STD_PACKET_SIZE 1518

// receive control register offset
#define OFF_RAH  0x05404 //Receive Address High
#define OFF_RAL  0x05400 //Receive Address Low
#define OFF_RDBAL 0x02800 // receive descriptor base address low
#define OFF_RDBAH 0x02804 
#define OFF_RDLEN 0x02808  
#define OFF_RDH   0x02810
#define OFF_RDT   0x02818
#define OFF_RCTL  0x00100 // control register
#define OFF_IMS   0x000D0


#define RCTL_EN (0x1 << 1)
#define RCTL_LPE (0x1 << 5)
#define RCTL_BAM (0x1 << 15)
#define RCTL_SECRC (0x1 << 26)

#define RAH_AV (0x1 << 31)

#define IMS_LSC (0x1 << 2)
#define IMS_RXSEQ (0x1 << 3)
#define IMS_RXDMT0 (0x1 << 4)
#define IMS_RXO (0x1 << 6)
#define IMS_RXT0 (0x1 << 7)

// static variable
volatile uint32_t *e1000;

static struct tx_legacy tx_dt[TXDESC_SIZE];
static char tx_buffer[TXDESC_SIZE][STD_PACKET_SIZE];

static struct rx rx_dt[RXDESC_SIZE];
static char rx_buffer[RXDESC_SIZE][STD_PACKET_SIZE];


static void transmit_init();
static void receive_init();

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
    tx_dt[*TDT].cmd.EOP = 1;
    tx_dt[*TDT].status.DD = 0;


    *TDT = (*TDT + 1) % TXDESC_SIZE;
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

    transmit_init();
    //assert(test_transmit() == 0); 

    receive_init();

    return 0;
}


static void transmit_init(){
     // descriptor and buffer setting
    for (int i = 0; i < TXDESC_SIZE; i++)
    {
        tx_dt[i].addr = PADDR(tx_buffer[i]);
        tx_dt[i].cmd.value = 0;
        tx_dt[i].status.DD = 1;
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
}
void set_address(char *address, uint32_t flag);

static void receive_init(){

    // 1. program h/w address (MAC address)
    
    // hard-code 52:54:00:12:34:56, attention low-to-high
    char address[] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
    set_address(address, RAH_AV);
    
    
    // 2. initialize the MTA
    // no need for now

    // 3. set interrupt
    // no nedd for now
    uint32_t *IMS = (uint32_t *)((char *)e1000 + OFF_IMS);

    *IMS |= (IMS_RXT0 | IMS_RXO | IMS_RXSEQ | IMS_RXDMT0 | IMS_LSC);
    // 4. initialize receive descriptor
    // allocate memory and set base address
    for (int i = 0; i < RXDESC_SIZE; i++){
        rx_dt[i].addr = PADDR(rx_buffer[i]);
        
        rx_dt[i].status.IXSM = 0x1;
        rx_dt[i].status.EOP = 0;
        rx_dt[i].status.DD = 0;
    }
    
    *(uint32_t *)((char *)e1000 + OFF_RDBAL) = PADDR(rx_dt); 
    // set len
    *(uint32_t *)((char *)e1000 + OFF_RDLEN) = sizeof(rx_dt);
    // set head and tail
    *(uint32_t *)((char *)e1000 + OFF_RDH) = 0x0;
    *(uint32_t *)((char *)e1000 + OFF_RDT) = RXDESC_SIZE - 1;

    // 5. control register go ahead!
    volatile uint32_t *RCTL = (uint32_t *)((char *)e1000 + OFF_RCTL);

    *RCTL |= RCTL_EN | RCTL_BAM | RCTL_SECRC;
}


void set_address(char *address, uint32_t flag){
    
    /* e.g MAC address: AA:BB:CC:DD:EE:FF
     *      31           0
	 *  RAL: |DD|CC|BB|AA|
	 *  RAH: |flags|FF|EE|
     */
    volatile uint32_t *RAL = (uint32_t *)((char *)e1000 + OFF_RAL);
    volatile uint32_t *RAH = (uint32_t *)((char *)e1000 + OFF_RAH);

    uint32_t low = 0;
    uint32_t high = 0;
    
    low = (address[0] | address[1] << 8 | address[2] << 16 | address[3] << 24);
    high = (address[4] | address[5] << 8 | flag);
    
    *RAL = low;
    *RAH = high;
    cprintf("%x \n", *RAL);
    cprintf("%x \n", *RAH);
}

static int test_transmit()
{
    char *string[] = {
        "123123",
        "sfsdfds",
        "dsfsdf",
    };
    int r;
    for (int i = 0; i < 2 * TXDESC_SIZE; i++){
        if (( r = transmit_packet(string[i%3], strlen(string[i%3]))) < 0){
            return r;
        }
    }
    return 0;
}