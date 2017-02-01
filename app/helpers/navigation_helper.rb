module NavigationHelper
  def admin_links
    items = [home_link, admin_home_link, libraries_link, departments_link, users_link, normal_hours_link, special_hours_link]
    content_tag :ul, :class => 'menu' do
       items.collect {|item| concat(content_tag(:li, item))}
    end
  end

  def home_link
    link_to 'Home', root_path
  end

  def admin_home_link
    link_to 'Admin', admin_path
  end

  def libraries_link
    link_to 'Libraries', libraries_path
  end

  def departments_link
    link_to 'Departments', departments_path
  end

  def users_link
    link_to 'Users', users_path
  end

  def normal_hours_link
    link_to 'Normal Hours', normal_hours_path
  end

  def special_hours_link
    link_to 'Special Hours', special_hours_path
  end
end
