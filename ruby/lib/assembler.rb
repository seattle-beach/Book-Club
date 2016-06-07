module Nand2Tetris
  module Assembler
    COMPS = {
      '0'   => 0b0101010,
      '1'   => 0b0111111,
      '-1'  => 0b0111010,
      'D'   => 0b0000110,
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
        input.split("\n").each.with_object([]) {|line, instructions|
          line.gsub!(/^\s*(.*?)(?:\/\/.*)$/, '\1')
          next if line.empty?

          instructions << case line
                          when /^@(\d+)$/
                            Instructions::A.new($1.to_i)
                          when /^
                            (?:([AMD]{1,3}(?==))=)?
                            (#{COMPS.keys.map {|x| Regexp.escape(x)}.join(?|)})?
                            (?:;(#{JUMPS.keys.join(?|)}))?
                              $/x
                            Instructions::C.new(*$~.captures.map(&:to_s))
                          end
        }
      end
    end

    module Instructions
      A = Struct.new(:value) do
        def to_binary
          value
        end
      end

      C = Struct.new(:dest, :comp, :jump) do
        def to_binary
          dest_bin = %w[A D M].map {|x| dest.include?(x) ? ?1 : ?0 }.join
          jump_bin = JUMPS.fetch(jump, 0)
          ('111%07b%s%03b' % [COMPS[comp], dest_bin, jump_bin]).to_i(2)
        end
      end
    end
  end
end
