#include "ns.h"

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
    int nsreq;
    while ((nsreq = ipc_recv(NULL, &nsipcbuf, NULL)) > 0){
        switch (nsreq){
            case NSREQ_OUTPUT:
                while (sys_transmit((void*)nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len) < 0)
                    ; // do nothing
                break;
            default:
                cprintf("output: Not captured nsreq : %d\n", nsreq);
        }
    }

    cprintf("output: nsreq: %d\n", nsreq);
    return 0;
}
