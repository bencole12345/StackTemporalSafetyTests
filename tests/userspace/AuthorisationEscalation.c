#include <assert.h>
#include <stdio.h>
#include <string.h>

#define NAME_LENGTH 32

/**
 * A basic data structure representing a user.
 */
typedef struct user {
    char name[NAME_LENGTH];
    // uint64_t id;  for example
} user_t;

/**
 * Sets the user's name to some arbitrary value. We can assume that this
 * function does not incur any spatial safety violations.
 */
void setUserName(user_t *user) {
    memset(&user->name, 1, NAME_LENGTH);  // No spatial violation!
}

/**
 * A dummy function representing some kind of authentication lookup. Here, the
 * user is unambiguously not authenticated.
 */
int lookupIsAdminFromDatabase(user_t *user) {
    return 0;
}

/**
 * A plausible-looking non-malicious login function. What it doesn't realise is
 * that it will be passed a temporally-invalid stack pointer to an object that
 * overlaps with its own stack frame.
 */
void attemptLogin(user_t *user) {
    int isAuthenticated = lookupIsAdminFromDatabase(user);
    assert(!isAuthenticated);
    setUserName(user);
    if (isAuthenticated) {
        printf("Authenticated\n");
    } else {
        printf("Not authenticated\n");
    }
}

/**
 * Sets up a user_t object. This is where the error occurs: the pointer
 * &newUser is invalid as soon as the function terminates.
 *
 * TODO: Make the mistake less obvious.
 *
 * One idea is that the caller could pass in some kind of structure to which
 * the callee adds a pointer to a user_t object, which happens to be
 * heap-allocated. The callee could reasonably believe that the value won't
 * ever be used again by the caller.
 */
void setupUser(user_t **user) {
    user_t newUser;
    strcpy(newUser.name, "Ben");
    *user = &newUser;
}

int main(int argc, char **argv) {
    user_t *user;
    setupUser(&user);
    attemptLogin(user);

    return 0;
}
