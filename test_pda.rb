require 'minitest/autorun'

require_relative 'pda'

class TestStack < Minitest::Test
  def test_stack
    stack = Stack.new(['a', 'b', 'c', 'd', 'e'])

    assert_equal ?a, stack.top
    assert_equal ?c, stack.pop.pop.top
    assert_equal ?y, stack.push(?x).push(?y).top
    assert_equal ?x, stack.push(?x).push(?y).pop.top
  end
end

class TestPDARule < Minitest::Test
  def test_pda_rule
    rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
    configuration = PDAConfiguration.new(1, Stack.new(['$']))

    assert rule.applies_to?(configuration, '(')
  end
end
