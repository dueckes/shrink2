# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def sign_in_link
    controller.controller_name == "user_sessions" && controller.action_name == "new" ? "Sign In" :
            link_to("Sign In", "#", { :id => :sign_in_link, :title => "Sign In" })
  end

  def remote_form?(form_type)
    form_type == :ajax
  end

  def render_none_or_list_via_partial(array, *render_args)
    array.empty? ? "<li>None</li>".html_safe : render(*render_args)
  end

  def render_message
    flash[:message] ? %{<div class="message">#{flash[:message]}</div>} : ""
  end

  def render_account_container
    render :partial => "common/show_account_container_#{current_user ? "signed_in" : "signed_out" }"
  end

  # Similar to div_for but produces an li tag
  def li_for(record, *args, &block)
    content_tag_for(:li, record, *args, &block)
  end

  def form_builder_for(model)
    eval("#{model.class.contextless_name}FormBuilder")
  end

  def nested_dom_id(symbol, parent=nil)
    dom_id(parent || @parent, symbol)
  end

  def element_style(options)
    options[:hidden] ? "display: none;" : ""
  end

  def forgery_protection_request_parameter
    if respond_to?('protect_against_forgery?') && protect_against_forgery?
      "'#{request_forgery_protection_token}=' + encodeURIComponent('#{escape_javascript(form_authenticity_token)}')"
    else
      ""
    end
  end

  def with_default_text(string, default_text="&lt;empty&gt;")
    string.blank? ? default_text : string
  end

  def replace_html_with_default_effect_js(id, html, additional_js="")
    %{
      $('##{id}').fadeOutAndIn(function(object) {
        object.html(#{::ActiveSupport::JSON.encode(html)});
        #{additional_js}
      });
    }
  end

  def refresh_account_container_js(additional_js="")
    replace_html_with_default_effect_js(:account_container, render_account_container, additional_js)
  end

  def replace_sidebar_area_js(html, additional_js="")
    replace_html_with_default_effect_js(:sidebar_area, html, additional_js)
  end

  def replace_main_inner_js(html, additional_js="")
    replace_html_with_default_effect_js("main_inner", html, additional_js)
  end

  def remove_from_sidebar_list_and_clear_main_inner_js(model)
    replace_main_inner_js("", "$('##{dom_id(model)}').fadeOutAndRemove()")
  end

  def update_in_sidebar_list_js(model, sidebar_content)
    %{
      $('##{dom_id(model)}').fadeOutAndIn(function() {
        $('##{dom_id(model, :show_link)}').html('#{sidebar_content}')
      })
    }
  end

  def close_popup_form_js
    "$.fn.colorbox.close()"
  end

end
