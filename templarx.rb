require 'erb'

class Templarx  
  TEMPLATE_PATH = File.join(File.dirname(__FILE__), '/drum_definition.erb')

  attr_accessor :probabilities
  attr_accessor :default_probability
  attr_accessor :start_channel
  
  def initialize opts={}
    opts = {:probability => 0.5,
            :definition_path => File.join(File.dirname(__FILE__), 'test.rb'),
            :start_channel => 36}.merge opts
    @ddpath = opts[:definition_path]
    @default_probability = opts[:probability] 
  end

  # 10x16 array of 0.0-1.0
  # rows represent midi channels, columns sixteenth notes
  def initialize_probabilities
    @probabilities = (0..9).map{Array.new(16, @default_probability)}
  end
  
  def template
    @template ||= open(TEMPLATE_PATH).read
  end
  
  def rewrite_drum_definition
    initialize_probabilities
    e = ERB.new template
    File.open(@ddpath, "w"){|f| f << e.result(binding)}
  end
end
