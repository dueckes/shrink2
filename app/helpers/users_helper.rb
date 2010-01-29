module UsersHelper

  def render_user_details_js(user, roles, additional_js="")
    replace_main_inner_js(render("users/show", :user => user, :roles => roles), additional_js)
  end

end
