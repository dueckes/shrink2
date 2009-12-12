module Platter::Cucumber
  describe FeatureFileNamer do

    context "#name_for"  do

      describe "when provided a feature" do

        it "should return a filename whose basename is the features title" do
          file_name_for("some_title").should match(/^some_title\./)
        end

        it "should return a filename with underscores replacing spaces in the features title" do
          file_name_for("title with spaces").should match(/^title_with_spaces\./)
        end

        it "should return a filename with the features title in lower case" do
          file_name_for("TitleWithMixedCase").should match(/^titlewithmixedcase\./)
        end

        it "should return a filename that excluded non alpha-numeric characters in the feature title" do
          file_name_for('T1tle !@#$%with n0n alph4 numeric +)(*&^characters and numb3rs').should match(/^t1tle_with_n0n_alph4_numeric_characters_and_numb3rs\./)
        end

        it "should return a filename having a '.feature' extension" do
          file_name_for("some_title").should match(/\.feature$/)
        end

      end

      def file_name_for(title)
        FeatureFileNamer.name_for(mock("Feature", :title => title))
      end

    end

  end
end
