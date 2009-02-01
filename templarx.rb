require 'erb'

class Templarx  
  TEMPLATE_PATH = File.expand_path(File.dirname(__FILE__)) + "/drum_definition.erb"

  attr_accessor :probabilities
  attr_accessor :default_probability
  
  def initialize opts={}
    @ddpath = opts[:definition_path]
    @default_probability = opts[:probability] 
  end

  # 10x16 hash of 0.0-1.0
  # rows represent midi channels, columns sixteenth notes
  def initialize_probabilities
    @probabilities = {}
    (0..9).each{|i| @probabilities[i] = {}}
    (0..9).each{|i| k={}; (0..15).each{|j| k[j] = @default_probability || 0.5}; @probabilities[i] = k }
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