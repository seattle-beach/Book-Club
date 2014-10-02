require 'minitest/autorun'

require_relative 'nfa'

class TestNFA < Minitest::Test
  def test_rulebook
    rulebook = NFARulebook.new([
      FARule.new(1, nil, 2), FARule.new(1, nil, 4),
      FARule.new(2, 'a', 3),
      FARule.new(3, 'a', 2),
      FARule.new(4, 'a', 5),
      FARule.new(5, 'a', 6),
      FARule.new(6, 'a', 4)
    ])

    assert_equal Set[2, 4], rulebook.next_states(Set[1], nil)
    assert_equal Set[1, 2, 4], rulebook.follow_free_moves(Set[1])
  end
end

class TestNFADesign < Minitest::Test
  def test_accepts
    rulebook = NFARulebook.new([
      FARule.new(1, nil, 2), FARule.new(1, nil, 4),
      FARule.new(2, 'a', 3),
      FARule.new(3, 'a', 2),
      FARule.new(4, 'a', 5),
      FARule.new(5, 'a', 6),
      FARule.new(6, 'a', 4)
    ])
    nfa_design = NFADesign.new(1, [2, 4], rulebook)

    assert nfa_design.accepts?('aa')
    assert nfa_design.accepts?('aaa')
    refute nfa_design.accepts?('aaaaa')
    assert nfa_design.accepts?('aaaaaa')
  end

  def test_to_nfa
    rulebook = NFARulebook.new([
      FARule.new(1, 'a', 1), FARule.new(1, 'a', 2),FARule.new(1, nil, 2),
      FARule.new(2, 'b', 3),
      FARule.new(3, 'b', 1), FARule.new(3, nil, 2)
    ])
    nfa_design = NFADesign.new(1, [3], rulebook)

    assert_equal Set[1, 2], nfa_design.to_nfa.current_states
    assert_equal Set[2], nfa_design.to_nfa(Set[2]).current_states
    assert_equal Set[3, 2], nfa_design.to_nfa(Set[3]).current_states
  end
end

class TestNFASimulation < Minitest::Test
  def setup
    rulebook = NFARulebook.new([
      FARule.new(1, 'a', 1), FARule.new(1, 'a', 2),FARule.new(1, nil, 2),
      FARule.new(2, 'b', 3),
      FARule.new(3, 'b', 1), FARule.new(3, nil, 2)
    ])
    nfa_design = NFADesign.new(1, [3], rulebook)
    @simulation = NFASimulation.new(nfa_design)
  end

  def test_next_state
    assert_equal Set[1, 2], @simulation.next_state(Set[1, 2], 'a')
    assert_equal Set[2, 3], @simulation.next_state(Set[1, 2], 'b')
    assert_equal Set[1, 2, 3], @simulation.next_state(Set[3, 2], 'b')
    assert_equal Set[1, 2, 3], @simulation.next_state(Set[1, 3, 2], 'b')
    assert_equal Set[1, 2], @simulation.next_state(Set[1, 3, 2], 'a')
  end

  def test_to_dfa_design
    dfa_design = @simulation.to_dfa_design

    refute dfa_design.accepts?('aaa')
    assert dfa_design.accepts?('aab') => true
    assert dfa_design.accepts?('bbbabb')
  end
end
