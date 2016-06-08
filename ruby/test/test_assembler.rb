require 'minitest/autorun'

require 'assembler'

module Nand2Tetris::Assembler
  class TestParser < Minitest::Test
    def setup
      @parser = Parser.new
    end

    def test_comments
      tree = @parser.parse('  // Comments are cool')
      assert_equal [], tree

      tree = @parser.parse('// Multiple // Comments')
      assert_equal [], tree

      tree = @parser.parse(<<-INPUT)
// Multi
// Line
// Comments
      INPUT
      assert_equal [], tree

      tree = @parser.parse(' @0 // Foo bar baz')
      assert_equal [[:a, 0]], tree
    end

    def test_addresses
      tree = @parser.parse('@2')
      assert_equal [[:a, 2]], tree
    end

    def test_computations
      tree = @parser.parse('D=A')
      assert_equal [[:c, ?D, ?A, '']], tree

      tree = @parser.parse('D=D+A')
      assert_equal [[:c, ?D, 'D+A', '']], tree

      tree = @parser.parse('M=D')
      assert_equal [[:c, ?M, ?D, '']], tree

      tree = @parser.parse('D;JGT')
      assert_equal [[:c, '', ?D, 'JGT']], tree

      tree = @parser.parse('0;JMP')
      assert_equal [[:c, '', ?0, 'JMP']], tree
    end
  end

  class TestTransformer < Minitest::Test
    def setup
      @transformer = Transformer.new
    end

    def test_addresses
      tree = [[:a, 2]]
      assert_equal '0000000000000010', @transformer.transform(tree)

      tree = [[:a, 3]]
      assert_equal '0000000000000011', @transformer.transform(tree)

      tree = [[:a, 0]]
      assert_equal '0000000000000000', @transformer.transform(tree)
    end

    def test_computations
      tree = [[:c, ?D, ?A, '']]
      assert_equal '1110110000010000', @transformer.transform(tree)

      tree = [[:c, ?D, 'D+A', '']]
      assert_equal '1110000010010000', @transformer.transform(tree)

      tree = [[:c, ?M, ?D, '']]
      assert_equal '1110001100001000', @transformer.transform(tree)

      tree = [[:c, '', ?D, 'JGT']]
      assert_equal '1110001100000001', @transformer.transform(tree)

      tree = [[:c, '', ?0, 'JMP']]
      assert_equal '1110101010000111', @transformer.transform(tree)
    end
  end
end
