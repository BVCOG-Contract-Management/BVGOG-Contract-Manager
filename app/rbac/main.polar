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

actor User {}

resource Contract {
    permissions = ["read", "write", "edit"];
}