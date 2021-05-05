#include <assert.h>
#include <stdio.h>
#include <string.h>

#define NAME_LENGTH 32

typedef struct user {
    char name[NAME_LENGTH];
} user_t;

// Suppose this sets a user-controlled value, such as from
// a file or UI field.
void setUserName(user_t *user) {
    memset(&user->name, 1, NAME_LENGTH);  // No spatial violation!
}

// Suppose this loads the bit from a database.
int userIsAdmin(user_t *user) {
    return 0;
}

// Sets up an initial user.
void setupUser(user_t **user) {
    user_t newUser;
    strcpy(newUser.name, "Ben");
    *user = &newUser;
}

void attemptAdminLogin(user_t *user) {
    int isAuthenticated = userIsAdmin(user);
    assert(!isAuthenticated);
    setUserName(user);
    if (isAuthenticated) {
        printf("Authenticated\n");
    } else {
        printf("Not authenticated\n");
    }
}

int main(int argc, char **argv) {
    user_t *user;
    setupUser(&user);
    attemptAdminLogin(user);
    return 0;
}
