require 'parslet'

module Nand2Tetris
  module Assembler
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

    class Parser < Parslet::Parser
      root(:lines)

      rule(:lines) { (line >> str("\n")).repeat >>
                     (line >> eof).maybe }
      rule(:line) { str(' ').repeat >>
                    instruction.maybe >>
                    str(' ').repeat >> comment.maybe }

      rule(:instruction) { (label | address | dest_comp_jump.as(:computation)) }

      rule(:label) { str(?() >> symbol.as(:label) >> str(?)) }
      rule(:address) { str(?@) >> (match['\d'].repeat(1).as(:a_constant) |
                                   symbol.as(:a_symbol)) }
      rule(:symbol) { (match['\d'].absent? >> any) >> match['\w.$:'].repeat }

      rule(:dest_comp_jump) { (dest >> str(?=)).maybe >>
                              comp >>
                              (str(?;) >> jump).maybe }
      rule(:dest) { match['AMD'].repeat(1,3).as(:dest) }
      rule(:comp) { COMPS.keys.reverse.map {|x| str(x) }.reduce(&:|).as(:comp) }
      rule(:jump) { JUMPS.keys.map {|x| str(x) }.reduce(&:|).as(:jump) }

      rule(:comment) { str('//') >> ( str("\n").absent? >> any ).repeat }
      rule(:eof) { any.absent? }
    end

    class Transform < Parslet::Transform
      rule(label: simple(:x)) { Node.new(:label, x) }
      rule(a_constant: simple(:x)) { Node.new(:a_constant, x.to_i) }
      rule(a_symbol: simple(:x)) { Node.new(:a_symbol, x) }
      rule(computation: subtree(:computation)) {
        Node.new(:c, computation.values_at(*%i[ dest comp jump ]).map(&:to_s))
      }
    end

    Node = Struct.new(*%i[ type data ])
  end
end