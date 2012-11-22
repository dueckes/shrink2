describe ActionView::Base do

  context "#field_error_proc" do

    let(:html_tag) { %{<tag>Some Text</tag>} }

    it "should return a string which is html_safe to prevent subsequent escaping" do
      invoke_proc.should be_html_safe
    end

    describe "when the html_tag does not have a class attribute" do

      let(:html_tag) { %{<tag not_class="">Some Text</tag>} }

      it "should add a class attribute with a value of 'fieldWithErrors'" do
        invoke_proc_and_return_node["class"].should eql("fieldWithErrors")
      end

    end

    describe "when the html_tag contains a class attribute" do

      describe "that contains many values" do

        let(:html_tag) { %{<tag not_class="" class="someClass someOtherClass">Some Text</tag>} }

        it "should append 'fieldWithErrors' to the class attribute" do
          invoke_proc_and_return_node["class"].should eql("someClass someOtherClass fieldWithErrors")
        end

      end

      describe "that is empty" do

        let(:html_tag) { %{<tag not_class="" class="">Some Text</tag>} }

        it "should establish 'fieldWithErrors' in the class attribute" do
          invoke_proc_and_return_node["class"].should eql("fieldWithErrors")
        end

      end

    end

    def invoke_proc
      ActionView::Base.field_error_proc.call(html_tag, nil)
    end

    def invoke_proc_and_return_node
      Nokogiri::HTML.fragment(invoke_proc).children[0]
    end
    
  end

end
