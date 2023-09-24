allow(actor, action, resource) if
    has_permission(actor, action, resource) or
    has_permission(actor, action, resource);

# ----------- Contract Permissions ----------- #
is_zero(lvl) if lvl == "zero";
is_one(lvl) if lvl == "one";
is_two(lvl) if lvl == "two";
is_three(lvl) if lvl == "three";

# Can a user read a contract?
has_permission(user: User, "read", contract: Contract) if
    contract matches Contract and
    (not is_two(user.level) or
    user.has_entity?(contract.entity_id) or
    contract.point_of_contact_id == user.id);  # Use '==' for equality check

# Can a user create a contract?
has_permission(user: User, "write", contract: Contract) if
    contract matches Contract and
    (not is_two(user.level));

# Can a user edit a contract
has_permission(user: User, "edit", contract: Contract) if
    contract matches Contract and
    (not is_two(user.level));

# --------------------------------------------- #

# ----------- User Permissions ----------- #

# Can a user see other users?
has_permission(user: User, "read", user_resource: User) if
    user_resource matches User and (
    is_three(user.level) or
    is_two(user.level) or
    is_one(user.level) or
    is_zero(user.level));

# Can a user invite a user
has_permission(user: User, "write", user_resource: User) if
    user_resource matches User and
    is_one(user.level);

# Can a user edit a user
has_permission(user: User, "edit", user_resource: User) if
    user_resource matches User and
    is_one(user.level);

# --------------------------------------------- #

actor User {}

resource Contract {
    permissions = ["read", "write", "edit"];
}

resource User {
    permissions = ["read", "write", "edit"];
}