module UsersHelper

  def render_user_details_js(user, roles, additional_js="")
    html = render(:partial => "users/show", :locals => { :user => user, :roles => roles })
    replace_main_inner_js(html, additional_js)
  end

  def replace_user_message_js(message)
    replace_html_with_default_effect_js(:user_message, message)
  end

  def refresh_account_container_and_user_sidebar_and_user_details_js(user, roles)
    refresh_account_container_js(
      replace_html_with_default_effect_js(:sidebar, "&nbsp;",
        render_user_details_js(user, roles,
          replace_user_message_js("Role changed"))))
  end

end
