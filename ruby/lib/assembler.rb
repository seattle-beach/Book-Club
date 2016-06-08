module Nand2Tetris
  module Assembler
    class ParseError < StandardError
      def initialize(line_number, line)
        super("#{line_number}: #{line}")
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

    class Parser
      def parse(input)
        input.split("\n")
          .each.with_index.with_object([]) {|(line, index), instructions|
          line.sub!(/^\s*(.*?)(?:\s*\/\/.*)?$/, '\1')
          next if line.empty?

          instructions << case line
                          when /^@(\d+)$/
                            [:a, $1.to_i]
                          when /^
                            (?:([AMD]{1,3}(?==))=)?
                            (#{COMPS.keys.map {|x| Regexp.escape(x)}.join(?|)})?
                            (?:;(#{JUMPS.keys.join(?|)}))?
                              $/x
                            [:c].concat($~.captures.map(&:to_s))
                          else
                            raise ParseError.new(index, line)
                          end
        }
      end
    end

    class Transformer
      def transform(tree)
        tree.map {|node|
          case node.first
          when :a
            node.last.to_s(2).rjust(16, ?0)
          when :c
            dest, comp, jump = node[1..-1]
            dest = %w[A D M].map {|x| dest.include?(x) ? ?1 : ?0 }.join
            jump = JUMPS.fetch(jump, 0)
            '111%07b%s%03b' % [COMPS[comp], dest, jump]
          else
            raise TransformError.new(node)
          end
        }.join("\n")
      end
    end
  end
end
