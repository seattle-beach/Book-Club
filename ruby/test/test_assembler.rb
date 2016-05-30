require 'minitest/autorun'

require 'assembler'

module Nand2Tetris::Assembler
  class TestParser < Minitest::Test
    def test_empty
      p = Parser.new('')
      assert_equal [], p.commands.to_a
    end

    def test_whitespace
      p = Parser.new("  \n\t")
      assert_equal [], p.commands.to_a
    end

    def test_comments
      p = Parser.new("  // la la la\n@123")
      assert_equal [Commands::Address.new('123')], p.commands.to_a
    end

    def test_a_command
      p = Parser.new('@123')
      assert_equal [Commands::Address.new('123')], p.commands.to_a
    end

    def test_c_command
      p = Parser.new('D=0')
      assert_equal [Commands::Compute.new(?D, ?0)], p.commands.to_a

      p = Parser.new('M=1')
      assert_equal [Commands::Compute.new(?M, ?1)], p.commands.to_a

      p = Parser.new('M=-A')
      assert_equal [Commands::Compute.new(?M, '-A')], p.commands.to_a

      p = Parser.new('D=A-1')
      assert_equal [Commands::Compute.new(?D, 'A-1')], p.commands.to_a

      p = Parser.new('M=D&A')
      assert_equal [Commands::Compute.new(?M, 'D&A')], p.commands.to_a

      p = Parser.new('0;JGT')
      assert_equal [Commands::Jump.new(?0, 'JGT')], p.commands.to_a

      p = Parser.new('D-A;JGT')
      assert_equal [Commands::Jump.new('D-A', 'JGT')], p.commands.to_a
    end

    def test_errors
      assert_raises { Parser.new('M=-0').commands.to_a }
    end
  end
end
