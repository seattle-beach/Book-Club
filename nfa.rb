require 'set'

require_relative 'fa'

class NFARulebook < Struct.new(:rules)
  def next_states(states, character)
    states.flat_map {|state| follow_rules_for(state, character) }.to_set
  end

  def follow_rules_for(state, character)
    rules_for(state, character).map(&:follow)
  end

  def rules_for(state, character)
    rules.select {|rule| rule.applies_to?(state, character) }
  end
end

class NFA < Struct.new(:current_states, :accept_states, :rulebook)
  def accepting?
    !(current_states & accept_states).empty?
  end

  def read_character(character)
    self.current_states = rulebook.next_states(current_states, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end
end

class NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
  def accepts?(string)
    to_nfa.tap {|nfa| nfa.read_string(string) }.accepting?
  end

  def to_nfa
    NFA.new(Set[start_state], accept_states, rulebook)
  end
end
