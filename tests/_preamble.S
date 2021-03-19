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
