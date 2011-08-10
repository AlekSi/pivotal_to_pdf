#!/usr/bin/env ruby

require 'rubygems'
require 'prawn'
require 'rainbow'

class PdfWriter
  attr_reader :filename, :stories
  def initialize(stories_or_iteration, colored_stripe = true)
    if stories_or_iteration.is_a?(Iteration)
      @filename = "#{stories_or_iteration.id}.pdf"
      @stories = stories_or_iteration.stories.reject { |story| story.story_type == 'release' }
    else
      @filename = "#{stories_or_iteration.map(&:id).join('-')}.pdf"
      @stories = stories_or_iteration
    end
    puts "Stories: #{stories.size}"
  end

  def write_to
    Prawn::Document.generate(filename,
                             :page_layout => :landscape,
                             :margin      => 15,
                             :page_size   => 'A6') do |pdf|

      pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
      pdf.line_width = 6
      padding = 10
      width = pdf.bounds.width - padding * 2
      height = pdf.bounds.height - padding * 2

      stories.each_with_index do |story, index|
        pdf.start_new_page unless index == 0

        pdf.bounding_box [pdf.bounds.left+padding, pdf.bounds.top-padding], :width => width, :height => height do
          # pdf.stroke_bounds

          pdf.fill_color "000000"
          pdf.text story.name, :size => 24

          pdf.fill_color "52D017"
          pdf.text story.label_text, :size => 8

          pdf.fill_color "000000"
          pdf.text "\n", :size => 14
          pdf.text story.description || "", :size => 10

          pdf.text_box story.points, :size => 12, :at => [0, 30], :width => width unless story.points.nil?
          pdf.text_box "Owner: " + story.owner, :size => 8, :at => [0, 15], :width => width

          pdf.fill_color "999999"
          pdf.text_box "#{story.story_type.capitalize} ##{story.id}", :size => 8, :align => :right, :at => [0, 15], :width => width
        end

        pdf.stroke_color = story.story_color
        pdf.stroke_bounds
      end

      puts ">>> Generated PDF file in '#{filename}'".foreground(:green)
  end
  rescue Exception
    puts "[!] There was an error while generating the PDF file... What happened was:".foreground(:red)
    raise
  end
end
