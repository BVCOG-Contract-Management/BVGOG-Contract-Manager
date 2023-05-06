allow(actor, action, resource) if
    has_permission(actor, action, resource) or
    has_permission(actor, action, resource);


# ----------- Contract Permissions ----------- #

# Can a user read a contract?
has_permission(user: User, "read", contract: Contract) if
    contract matches Contract and
    (user.level != "three" or
    user.has_entity?(contract.entity_id) or
    contract.point_of_contact_id = user.id);

# Can a user create a contract?
has_permission(user: User, "write", contract: Contract) if
    contract matches Contract and
    user.level != "three";

# Can a user edit a contract
has_permission(user: User, "edit", contract: Contract) if
    contract matches Contract and
    user.level != "three"; 

# --------------------------------------------- #

# ----------- User Permissions ----------- #

# Can a user read see other users?
has_permission(user: User, "read", user_resource: User) if
    user_resource matches User and
    user.level == "three" or
    user.level == "two" or
    user.level == "one" or
    user.level == "zero";

# Can a user invite a user
has_permission(user: User, "write", user_resource: User) if
    user_resource matches User and
    user.level == "one";

# Can a user edit a user
has_permission(user: User, "edit", user_resource: User) if
    user_resource matches User and
    user.level == "one";

# --------------------------------------------- #

actor User {}

resource Contract {
    permissions = ["read", "write", "edit"];
}

resource User {
    permissions = ["read", "write", "edit"];
}