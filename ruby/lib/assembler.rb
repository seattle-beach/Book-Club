module Nand2Tetris
  module Assembler
    class ParseError < StandardError
      def initialize(line_number, line)
        super("Line #{line_number}: #{line}")
      end
    end

    class TransformError < StandardError; end

    COMPS = {
      '0'   => 0b0101010,
      '1'   => 0b0111111,
      '-1'  => 0b0111010,
      'D'   => 0b0001100,
      'A'   => 0b0110000, 'M'   => 0b1110000,
      '!D'  => 0b0001101,
      '!A'  => 0b0110001, '!M'  => 0b1110001,
      '-D'  => 0b0001111,
      '-A'  => 0b0110011, '-M'  => 0b1110011,
      'D+1' => 0b0011111,
      'A+1' => 0b0110111, 'M+1' => 0b1110111,
      'D-1' => 0b0001110,
      'A-1' => 0b0110010, 'M-1' => 0b1110010,
      'D+A' => 0b0000010, 'D+M' => 0b1000010,
      'D-A' => 0b0010011, 'D-M' => 0b1010011,
      'A-D' => 0b0000111, 'M-D' => 0b1000111,
      'D&A' => 0b0000000, 'D&M' => 0b1000000,
      'D|A' => 0b0010101, 'D|M' => 0b1010101,
    }

    JUMPS = Hash[
      %w[ JGT JEQ JGE JLT JNE JLE JMP ].map.with_index {|j,i| [j, i+1] }
    ]

    # A user-defined symbol can be any sequence of letters, digits, underscore (_),
    # dot (.), dollar sign ($), and colon (:) that does not begin with a digit
    VALID_SYMBOL = /(?!\d)[\w.$:]+/

    class Parser
      def parse(input)
        input.split("\n")
          .each.with_index.with_object([]) {|(line, index), instructions|
          line.sub!(/^\s*(.*?)\s*(?:\/\/.*)?$/, '\1')
          next if line.empty?

          instructions << case line
                          when /^@(\d+)$/
                            Node.new(:a_constant, $1.to_i)
                          when /^@(#{VALID_SYMBOL})$/
                            Node.new(:a_symbol, $1)
                          when /^\((#{VALID_SYMBOL})\)$/
                            Node.new(:label, $1)
                          when /^
                            (?:([AMD]{1,3}(?==))=)?
                            (#{COMPS.keys.map {|x| Regexp.escape(x)}.join(?|)})?
                            (?:;(#{JUMPS.keys.join(?|)}))?
                              $/x
                            Node.new(:c, $~.captures.map(&:to_s))
                          else
                            raise ParseError.new(index, line)
                          end
        }
      end
    end

    class Transformer
      def transform(tree)
        symbol_table = SymbolTable.new(tree)

        tree.reject {|node|
          node.type == :label
        }.map {|node|
          case node.type
          when :a_constant
            node.data
          when :a_symbol
            symbol_table[node.data]
          when :c
            dest, comp, jump = node.data
            dest = %w[A D M].map {|x| dest.include?(x) ? ?1 : ?0 }.join
            jump = JUMPS.fetch(jump, 0)
            ('111%07b%s%03b' % [COMPS[comp], dest, jump]).to_i(2)
          else
            raise TransformError.new(node)
          end
        }.map {|code|
          code.to_s(2).rjust(16, ?0)
        }.join("\n")
      end
    end

    class SymbolTable < SimpleDelegator
      PREDEFINED_SYMBOLS =
        Hash[%w[ SP LCL ARG THIS THAT ].map.with_index.to_a]
        .merge(Hash[(0..15).map {|i| ["R#{i}", i] }])
        .merge('SCREEN' => 0x4000, 'KBD' => 0x6000)

      def initialize(tree)
        symbols = PREDEFINED_SYMBOLS.dup
        address = 0
        tree.each do |node|
          if node.type == :label
            symbols[node.data] = address
          else
            address += 1
          end
        end

        symbol_mem_location = 0x0010
        symbols.default_proc = ->(h,k) do
          h[k] = symbol_mem_location
          symbol_mem_location += 1
          h[k]
        end

        super(symbols)
      end
    end

    Node = Struct.new(*%i[ type data ])
  end
end
