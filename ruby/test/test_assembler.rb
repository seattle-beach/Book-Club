require 'minitest/autorun'

require 'assembler'

module Nand2Tetris::Assembler
  class TestParser < Minitest::Test
    def setup
      @parser = Parser.new
    end

    def test_comments
      instructions = @parser.parse('  // Comments are cool')
      assert_equal [], instructions

      instructions = @parser.parse('// Multiple // Comments')
      assert_equal [], instructions

      instructions = @parser.parse(<<-INPUT)
// Multi
// Line
// Comments
      INPUT
      assert_equal [], instructions
    end

    def test_a_instructions
      instructions = @parser.parse('@2')
      assert_equal [Instructions::A.new(2)], instructions
    end

    def test_c_instructions
      instructions = @parser.parse('D=A')
      assert_equal [Instructions::C.new(?D, ?A, nil)], instructions

      instructions = @parser.parse('D=D+A')
      assert_equal [Instructions::C.new(?D, 'D+A', nil)], instructions

      instructions = @parser.parse('M=D')
      assert_equal [Instructions::C.new(?M, ?D, nil)], instructions
    end
  end

  class TestInstructions < Minitest::Test
    def test_a_instruction
      instruction = Instructions::A.new(2)
      assert_equal 0b0000_0000_0000_0010, instruction.to_binary

      instruction = Instructions::A.new(3)
      assert_equal 0b0000_0000_0000_0011, instruction.to_binary

      instruction = Instructions::A.new(0)
      assert_equal 0b0000_0000_0000_0000, instruction.to_binary
    end

    def test_c_instruction
      instruction = Instructions::C.new(?D, ?A, nil)
      assert_equal 0b1110_1100_0001_0000, instruction.to_binary

      instruction = Instructions::C.new(?D, 'D+A', nil)
      assert_equal 0b1110_0000_1001_0000, instruction.to_binary

      instruction = Instructions::C.new(?M, ?D, nil)
      assert_equal 0b1110_0001_1000_1000, instruction.to_binary
    end
  end
end
