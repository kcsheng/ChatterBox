module StaticPagesHelper
  def generate_title(page_title = '')
    base_title = 'ChatterBox'
    page_title.empty? ? base_title : (page_title + ' | ' + base_title)
  end
end
