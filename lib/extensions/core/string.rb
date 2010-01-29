String.class_eval do

  def as_folder_names
    self.split("/").collect { |name| name.gsub(/\//, "") } - [""]
  end

  def fileize
    self.strip.gsub(/[^a-z0-9_\-\s]/i, "")
  end

  def underscoreize
    self.gsub(/ /, "_")
  end

  def contains_complete_word?
    !!self.match(/^[^\s]+\s/)
  end

  def preview(text_to_match, surrounding_lines_length, excluded_content_replacement="...")
    all_lines = self.split("\n")
    matching_index = all_lines.find_index { |line| line.match(/#{Regexp.escape(text_to_match)}/i) }
    non_blank_surrounding_line_positions = SurroundingElements.new(
            all_lines.collect_with_index { |element, i| i == matching_index || !element.blank? ? i : nil }.compact,
            matching_index, surrounding_lines_length)
    evaluate_preview_lines(all_lines, non_blank_surrounding_line_positions, excluded_content_replacement).join("\n")
  end

  def lpad_lines(integer, pad_str=" ")
    split("\n").collect { |line| "#{pad_str * integer}#{line}" }.join("\n")
  end

  private
  def evaluate_preview_lines(lines, surrounding_line_positions, excluded_content_replacement)
    preview_lines = lines[surrounding_line_positions.first..surrounding_line_positions.last]
    preview_lines = [excluded_content_replacement] + preview_lines if surrounding_line_positions.first > 0
    preview_lines = preview_lines + [excluded_content_replacement] if surrounding_line_positions.last < lines.length - 1
    preview_lines
  end

end
