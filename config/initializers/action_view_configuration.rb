ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_fragment = Nokogiri::HTML.fragment(html_tag)
  node = html_fragment.children[0]
  node["class"] = node["class"].blank? ? "fieldWithErrors" : "#{node["class"]} fieldWithErrors" 
  html_fragment.to_html
end
