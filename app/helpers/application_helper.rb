module ApplicationHelper
  
  # These are the pages of the application that are present in the main sidebar
  # Each page follows a format of:
  # Header
  #  - Subpath
  #  - Subpath
  # Each subpath has a name, path, and icon
  # This does not replace the routes.rb file, but is used to generate the sidebar
  def page_list
    [
      { title: "General", subpaths: [
        { name: "Home", path: root_path, icon: "home" },
      ]
      },
      { title: "Contracts", subpaths: [
        { name: "View Contracts", path: "#", icon: "file-contract" },
        { name: "Create a Contract", path: "#" , icon: "pencil" },
      ]
      },
      { title: "Vendors", subpaths: [
        { name: "View Vendors", path: "#", icon: "address-book" },
        { name: "Review a Vendor", path: "#", icon: "star" },
      ]
      },
      { title: "Users", subpaths: [
        { name: "View Users", path: "#", icon: "users" },
        { name: "Invite a User", path: "#", icon: "user-plus" },
      ]
      },
      { title: "Admin", subpaths: [
        { name: "Platform Settings", path: "#", icon: "cog" },
      ]
      }
    ]
  end
end
