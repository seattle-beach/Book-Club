require 'minitest/autorun'

require_relative 'nfa'

class TestNFA < Minitest::Test
  def setup
    @rulebook = NFARulebook.new([
      FARule.new(1, nil, 2), FARule.new(1, nil, 4),
      FARule.new(2, 'a', 3),
      FARule.new(3, 'a', 2),
      FARule.new(4, 'a', 5),
      FARule.new(5, 'a', 6),
      FARule.new(6, 'a', 4)
    ])
  end

  def test_rulebook
    assert_equal Set[2, 4], @rulebook.next_states(Set[1], nil)
    assert_equal Set[1, 2, 4], @rulebook.follow_free_moves(Set[1])
  end

  def test_accepts
    nfa_design = NFADesign.new(1, [2, 4], @rulebook)
    assert nfa_design.accepts?('aa')
    assert nfa_design.accepts?('aaa')
    refute nfa_design.accepts?('aaaaa')
    assert nfa_design.accepts?('aaaaaa')
  end
end
