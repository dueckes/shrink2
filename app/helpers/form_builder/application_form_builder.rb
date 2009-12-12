class ApplicationFormBuilder < ActionView::Helpers::FormBuilder

  class << self
    attr_reader :element_id_providers

    def set_element_id_providers(options)
      @element_id_providers ||= {}
      options.each do |key, value|
        provider_factory_class = value.is_a?(Class) ? ClassElementIdProviderFactory : CallbackElementIdProviderFactory
        @element_id_providers[key] = provider_factory_class.new(value)
      end
    end
    
    def inherited(subclass)
      subclass.set_element_id_providers :add => AddFormElementIdProvider, :edit => EditFormElementIdProvider
    end

  end

  def initialize(*args, &block)
    super
    @element_id_provider = self.class.element_id_providers[@object.new_record? ? :add : :edit].create(self)
  end

  def commit_button(options={})
    submit_button_for(@object.new_record? ? :add : :update, options)
  end

  def cancel_button
    @template.button_to_function("Cancel", standard_tag_options(:cancel))
  end

  def text_field_for(field_as_symbol, options={})
    tag_options = text_field_tag_options(field_as_symbol, options)
    %{
      #{text_field(field_as_symbol, tag_options)}
      #{options[:autocomplete_url] ?
              @template.javascript_tag("$('##{tag_options[:id]}').autocomplete('#{options[:autocomplete_url]}')") : "" }
    }
  end

  def hidden_field_for(field_as_symbol)
    hidden_field(field_as_symbol, standard_tag_options(field_as_symbol))
  end

  def hidden_field_tag(name, value)
    @template.hidden_field_tag(name, value, standard_tag_options(name))
  end

  private
  def id_for(name)
    @element_id_provider.id_for(name)
  end

  def submit_button_for(verb, options={})
    submit(verb.to_s.capitalize, { :id => id_for(verb) }.merge(options))
  end

  def text_field_tag_options(field_as_symbol, options)
    { :size => 80, :maxlength => 256 }.merge(standard_tag_options(field_as_symbol)).merge(options)
  end

  def standard_tag_options(field_as_symbol)
    { :id => id_for(field_as_symbol) }
  end

end
