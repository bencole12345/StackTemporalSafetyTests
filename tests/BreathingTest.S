/**
 * Super simple minimal example that just exits with a "success" code.
 */


/**
 * Text section: Where the code goes
 */
 .text

 /**
  * _start is the entry point to this binary.
  */
 .global _start
 _start:

    # Write the value 1 to tohost
    # (This tells Spike/Sail to exit with a success code (0))
    li t0, 1
    la t1, tohost
    sw t0, 0(t1)

    # Spin until exit
1:  j 1b
    
/**
 * Data section: Where non-const data goes
 */
.data

/**
 * We need to specify tohost and fromhost as interfaces to the simulator.
 * To do this, we simply reserve a dword of memory for each, and label
 * them so that the linker can... do its thing... and wire them up so
 * that the host can see them.
 */
.align 6
.global tohost
tohost:
    .dword 0

.align 6
.global fromhost
fromhost:
    .dword 0
