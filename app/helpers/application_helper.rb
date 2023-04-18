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
      { title: 'General', subpaths: [
        { name: 'Home', path: root_path, icon: 'home' }
      ] },
      { title: 'Contracts', subpaths: [
        { name: 'View Contracts', path: contracts_path, icon: 'file-contract' },
        { name: 'Create a Contract', path: new_contract_path, icon: 'pencil' }
      ] },
      { title: 'Reports', subpaths: [
        { name: 'Create a Report', path: new_report_path, icon: 'file-alt' }
      ] },
      { title: "Vendors", subpaths: [
        { name: "View Vendors", path: vendors_path, icon: "address-book" },
      ] },
      { title: 'Users', subpaths: [
        { name: 'View Users', path: users_path, icon: 'users' },
        { name: 'Invite a User', path: new_user_path, icon: 'user-plus' }
      ] },
      { title: 'Admin', subpaths: [
        { name: 'Platform Settings', path: '#', icon: 'cog' }
      ] },
      { title: 'Profile', subpaths: [
        { name: 'Sign Out', path: destroy_user_session_path, icon: 'cog' }
      ] }
    ]
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
