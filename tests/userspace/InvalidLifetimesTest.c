/**
 * This should cause an exception: the caller's pointer is set to point to a
 * shorter-lifetime value in the callee's scope.
 */

void callee(int **p)
{
    int x = 10;
    *p = &x;
}

int main(int argc, char **argv)
{
    int *p;
    callee(&p);

    return 0;
}
