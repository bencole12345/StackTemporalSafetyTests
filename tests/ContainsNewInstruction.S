/**
 * Contains a call to the new instruction.
 */

#include "_preamble.S"

.text
.global _start
_start:

    # Store the stack pointer in ca0 (doesn't really matter where that is
    # right now because it's currently a no-op)
    c.sc.cap csp, (ca0)

    # Write the value 1 to tohost
    # (This tells Spike/Sail to exit with a success code (0))
    li t0, 1
    la t1, tohost
    sw t0, 0(t1)

    # Spin until exit
1:  j 1b


.data

/**
 * Used because we need a capability to something.
 */
some_data:
    .dword 0