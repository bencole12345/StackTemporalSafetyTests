#include <cassert>
#include <cstring>
#include <iostream>
#include <string>

#define NAME_LENGTH 32

/**
 * Contains typical attributes for the user of some system.
 */
struct User {
    char name[NAME_LENGTH];
    // Example: uint64_t id;
};

/**
 * A stateful class that performs important actions for users.
 */
class UserProcessor {
private:
    User *activeUser;
public:
    void setActiveUser(User *user);
    User *getActiveUser();
    void doSomethingMeaningfulWithActiveUser();
};

/**
 * A collection of utilities for working with users.
 */
struct UserManagerUtils {
public:
    static void createAndProcessExampleUser(UserProcessor *processor);
    static void updateUsername(User *user);
    static bool userIsAdmin(User *user);
    static void performLogin(User *user);
};

void UserProcessor::setActiveUser(User *user) {
    activeUser = user;
}

User *UserProcessor::getActiveUser() {
    return activeUser;
}

void UserProcessor::doSomethingMeaningfulWithActiveUser() {
    std::cout << "Doing something meaningful with user: "
              << activeUser->name << std::endl;
}

void UserManagerUtils::createAndProcessExampleUser(UserProcessor *processor) {
    User newUser{"Ben"};
    processor->setActiveUser(&newUser);
    processor->doSomethingMeaningfulWithActiveUser();
}

void UserManagerUtils::updateUsername(User *user) {
    // Pretend this loaded a user-controlled value, e.g. from a UI textbox or
    // from a file.
    memset(&user->name, 1, NAME_LENGTH);  // No spatial violation!
}

bool UserManagerUtils::userIsAdmin(User *user) {
    // Pretend this is looked up the from a database or something like that.
    return false;
}

void UserManagerUtils::performLogin(User *user) {
    bool isAdmin = userIsAdmin(user);
    assert(!isAdmin);
    updateUsername(user);
    if (isAdmin) {
        std::cout << "User is admin" << std::endl;
    } else {
        std::cout << "User is not an admin" << std::endl;
    }
}

int main(int argc, char **argv) {

    // Earlier:
    UserProcessor uploader;
    UserManagerUtils::createAndProcessExampleUser(&uploader);

    // Then, later on:
    User *lastUploaded = uploader.getActiveUser();
    UserManagerUtils::performLogin(lastUploaded);

    return 0;
}
