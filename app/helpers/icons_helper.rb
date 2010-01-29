module IconsHelper

  def icon(name, color=nil)
    name_file_name_component = name.to_s.gsub(/_/, "-")
    color_file_name_component = color ? "-#{color}" : ""
    image_tag("icon-#{name_file_name_component}#{color_file_name_component}.png")
  end

end
