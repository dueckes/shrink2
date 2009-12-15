module PhraseHighlightHelper

  def highlight_phrase_in_text(phrase, text)
    text.gsub(/#{Regexp.escape(phrase)}/i, "<b>\\0</b>")
  end

end
