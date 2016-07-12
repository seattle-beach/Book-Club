require 'minitest/autorun'

require_relative 'regex'

class TestRegex < Minitest::Test
  def test_empty
    nfa_design = Empty.new.to_nfa_design

    assert nfa_design.accepts?('')
    refute nfa_design.accepts?('a')
  end

  def test_literal
    nfa_design = Literal.new('a').to_nfa_design

    refute nfa_design.accepts?('')
    assert nfa_design.accepts?('a')
    refute nfa_design.accepts?('b')
  end

  def test_matches
    refute Empty.new.matches?('a')
    assert Literal.new('a').matches?('a')
  end

  def test_concatenate
    pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))

    refute pattern.matches?('a')
    assert pattern.matches?('ab')
    refute pattern.matches?('abc')

    pattern = Concatenate.new(
      Literal.new('a'),
      Concatenate.new(Literal.new('b'), Literal.new('c'))
    )

    refute pattern.matches?('a')
    refute pattern.matches?('ab')
    assert pattern.matches?('abc')
  end

  def test_choose
    pattern = Choose.new(Literal.new('a'), Literal.new('b'))

    assert pattern.matches?('a')
    assert pattern.matches?('b')
    refute pattern.matches?('c')
  end

  def test_repeat
    pattern = Repeat.new(Literal.new('a'))

    assert pattern.matches?('')
    assert pattern.matches?('a')
    assert pattern.matches?('aaaa')
    refute pattern.matches?('b')
  end

  def test_pattern
    pattern = Repeat.new(Concatenate.new(Literal.new('a'),
                                         Choose.new(Empty.new, Literal.new('b'))))

    assert pattern.matches?('')
    assert pattern.matches?('a')
    assert pattern.matches?('ab')
    assert pattern.matches?('aba')
    assert pattern.matches?('abab')
    assert pattern.matches?('abaab')
    refute pattern.matches?('abba')
  end

  def test_treetop
    require 'treetop'
    Treetop.load('pattern')
    parse_tree = PatternParser.new.parse('(a(|b))*')
    pattern = parse_tree.to_ast

    assert pattern.matches?('abaab')
    refute pattern.matches?('abba')
  end
end
