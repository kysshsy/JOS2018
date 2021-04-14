#include <kern/e1000.h>
#include <kern/pmap.h>

// LAB 6: Your driver code here
volatile uint32_t *e1000;


int attach_82540EM(struct pci_func *f){
    pci_func_enable(f);

    // ex4 mapping for e1000's bar 0
    e1000 = mmio_map_region(f->reg_base[0], f->reg_size[0]);
    uint32_t *test_ptr = (uint32_t *)e1000 + 2;
    
    if (*test_ptr != 0x80080783){
        cprintf("mmio value: 0x%08x  should be 0x80080783\n", *test_ptr);
    } 
    assert(*test_ptr == 0x80080783);
 
    

    return 0;
}