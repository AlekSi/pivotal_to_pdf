class Story < Pivotal
  def label_text
    return "" if !self.respond_to?(:labels) || self.labels.nil? || self.labels.empty?
    labels.split(',').join(', ')
  end

  def points
    return nil unless self.feature?
    "Points: " + (self.respond_to?(:estimate) && !self.estimate.eql?(-1) ? self.estimate.to_s : "Not yet estimated")
  end

  def owner
    return "None" if !self.respond_to?(:owned_by) || self.owned_by.nil? || self.owned_by.empty?
    owned_by
  end

  def story_color
    return "52D017" if feature?
    return "FF0000" if bug?
    return "FFFF00" if chore?
    raise "Unknown story type: #{story_type}"
  end

  private

  ["feature", "bug", "chore"].each do |type_str|
    class_eval <<-EOS
      def #{type_str}?
      self.story_type == "#{type_str}"
    end
    EOS
  end
end
