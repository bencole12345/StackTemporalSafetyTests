#include "_preamble.S"

.text

.global _start
_start:

    # Set up capability registers ca0 and ca1 where ca1 is of
    # a shorter lifetime than ca0.
    cmove ca0, csp
    # TODO: Work out the operand format
    # csub ca1, ca0, 4
    # cmove ca1, csp-4

    # Issue the check instruction (this should succeed fine)
    c.sc.cap ca1, (ca0)

    # Signal to tohost that it's time to exit
    li t0, 1
    la t1, tohost
    sw t0, 0(t1)

    # Spin until exit
1:  j 1b
