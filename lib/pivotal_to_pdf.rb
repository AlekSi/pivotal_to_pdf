require 'rainbow'
require 'thor'
require 'active_resource'
require 'pivotal_to_pdf/pivotal'
require 'pivotal_to_pdf/iteration'
require 'pivotal_to_pdf/story'
require 'pivotal_to_pdf/pdf_writer'
class PivotalToPdf < Thor
  class << self
    def story(story_ids, colored_stripe=true)
      stories = []
      story_ids.split(',').each do |story_id|
        stories << Story.find(story_id)
      end
      PdfWriter.new(stories, colored_stripe).write_to
    end

    def iteration(iteration_token, colored_stripe=true)
      iteration = Iteration.find(:all, :params => {:group => iteration_token}).first
      PdfWriter.new(iteration, colored_stripe).write_to
    end
  end
end
