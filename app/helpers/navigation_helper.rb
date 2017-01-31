module NavigationHelper
  def admin_links
    items = [libraries_link, departments_link]
    content_tag :ul, :class => 'menu' do
       items.collect {|item| concat(content_tag(:li, item))}
    end
  end

  def libraries_link(html_options = {})
    link_to 'Libraries', libraries_path
  end

  def departments_link(html_options = {})
    link_to 'Departments', departments_path
  end
end
