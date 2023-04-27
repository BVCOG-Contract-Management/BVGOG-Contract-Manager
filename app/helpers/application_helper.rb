module ApplicationHelper
  # These are the pages of the application that are present in the main sidebar
  # Each page follows a format of:
  # Header
  #  - Subpath
  #  - Subpath
  # Each subpath has a name, path, and icon
  # This does not replace the routes.rb file, but is used to generate the sidebar
  def page_list
    pages = [
      { title: 'General', subpaths: [
        { name: 'Home', path: root_path, icon: 'home' }
      ] }
    ]
    # Level 3 users can only view contracts
    if current_user.level == UserLevel::THREE
      pages << { title: 'Contracts', subpaths: [
        { name: 'View Contracts', path: contracts_path, icon: 'file-contract' },
      ] }
    else
      pages << { title: 'Contracts', subpaths: [
        { name: 'View Contracts', path: contracts_path, icon: 'file-contract' },
        { name: 'Create a Contract', path: new_contract_path, icon: 'pencil' }
      ] }
    end
    # All users can view reports
    pages << { title: 'Reports', subpaths: [
      { name: 'Create a Report', path: new_report_path, icon: 'file-alt' }
    ] }
    # All users can view vendors
    pages << { title: "Vendors", subpaths: [
      { name: "View Vendors", path: vendors_path, icon: "address-book" },
    ] }
    # Level 2 and 3 users can only view users
    if current_user.level == UserLevel::TWO || current_user.level == UserLevel::THREE
      pages << { title: 'Users', subpaths: [
        { name: 'View Users', path: users_path, icon: 'users' },
      ] }
    else
      pages << { title: 'Users', subpaths: [
        { name: 'View Users', path: users_path, icon: 'users' },
        { name: 'Invite a User', path: new_user_invitation_path, icon: 'user-plus' }
      ] }
    end
    if current_user.level == UserLevel::ONE
      pages << { title: 'Admin', subpaths: [
        { name: 'Administration', path: admin_path, icon: 'lock' }
      ] }
    end
    # Sign out is always present
    pages << { title: 'Profile', subpaths: [
      { name: 'Sign Out', path: destroy_user_session_path, icon: 'sign-out-alt', method: :delete }
    ] }
    # Return the pages
    pages
  end
end

def flash_type_to_bulma_class(type)
  case type
  when 'alert'
    'is-danger'
  when 'notice'
    'is-success'
  else
    'is-info'
  end
end
