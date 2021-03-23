/**
 * This should be fine: the callee stores a pointer to the caller.
 */

void callee(int *p)
{
    int *q = p;
}

int main(int argc, char **argv)
{
    int x = 10;
    callee(&x);

    return 0;
}
