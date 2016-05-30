module Nand2Tetris
  module Assembler
    class ParseError < StandardError
      def initialize(ss)
        super(ss.check_until(/\n/) || ss.rest)
      end
    end

    class Parser
      COMP = / 0
             | -?1
             | [!-][DA]
             | [DA][-+]1
             | D[-+&|]A
             | A-D
             /x

      attr_reader :input

      def initialize(input)
        @input = input
      end

      def commands
        return enum_for(__method__) unless block_given?

        ss = StringScanner.new(input)
        until ss.eos?
          case
          when ss.scan(/@/)
            if symbol = ss.scan(/\w+/)
              yield Commands::Address.new(symbol)
            else
              raise ParseError.new(ss)
            end
          when comp = ss.scan(COMP)
            if ss.scan(/;/) && jmp = jmp = ss.scan(/J(GT|EQ|GE|LT|NE|LE|MP)/)
              yield Commands::Jump.new(comp, jmp)
            else
              raise ParseError.new(ss)
            end
          when dest = ss.scan(/(D|M)/)
            if ss.scan(/=/) && comp = ss.scan(COMP)
              yield Commands::Compute.new(dest, comp)
            else
              raise ParseError.new(ss)
            end
          when ss.scan(%r(//[^\n]*\n))
          when ss.scan(/\s+/)
          else
            raise ParseError.new(ss)
          end
        end
      end
    end

    module Commands
      Address = Struct.new(:symbol)
      Compute = Struct.new(:dest, :comp)
      Jump = Struct.new(:comp, :jmp)
    end
  end
end
