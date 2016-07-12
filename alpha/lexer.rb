require 'minitest/autorun'

module Lexer
  KEYWORDS = %w[ def class if true false nil ]

  def self.tokenize(code)
    tokens = []
    current_indent = 0
    indent_stack = []

    ss = StringScanner.new(code.chomp)
    until ss.eos?
      case
      when identifier = ss.scan(/[a-z]\w*/)
        token_type = if KEYWORDS.include?(identifier)
                       identifier.upcase.to_sym
                     else
                       :IDENTIFIER
                     end
        tokens << [ token_type, identifier ]
      when constant = ss.scan(/[A-Z]\w*/)
        tokens << [ :CONSTANT, constant ]
      when number = ss.scan(/[0-9]+/)
        tokens << [ :NUMBER, number.to_i ]
      when string = ss.scan(/"[^"]*"/)
        tokens << [ :STRING, string.gsub(/\A"|"\z/, '') ]
      when indent = ss.scan(/:\n +/)
        indent_size = indent.size - 2
        raise "Bad indent level: got #{indent_size} indents, expected > #{current_indent}" if indent_size <= current_indent
        current_indent = indent_size
        indent_stack << current_indent
        tokens << [ :INDENT, indent_size ]
      when ss.scan(/\n {#{current_indent}}/)
        tokens << [ :NEWLINE, "\n" ]
      when indent = ss.scan(/\n */)
        indent_size = indent.size - 1
        while indent_size < current_indent
          indent_stack.pop
          current_indent = indent_stack.last || 0
          tokens << [ :DEDENT, indent_size ]
        end
        tokens << [ :NEWLINE, "\n" ]
      when operator = ss.scan(/\|\||&&|[=!<>]=/)
        tokens << [ operator, operator ]
      when ss.scan(/ +/)
        # Ignore whitespace
      when value = ss.scan(/./)
        tokens << [ value, value ]
      else
        raise 'omg'
      end
    end

    while indent = indent_stack.pop
      tokens << [ :DEDENT, indent_stack.first || 0 ]
    end

    tokens
  end
end

class TestLexer < Minitest::Test
  def test_lexer
    code = <<-CODE
if 1:
  if 2:
    print("...")
    if false:
      pass
    print("done!")
  2

print "The End"
    CODE

    tokens = [
      [:IF, 'if'], [:NUMBER, 1],
        [:INDENT, 2],
          [:IF, 'if'], [:NUMBER, 2],
            [:INDENT, 4],
              [:IDENTIFIER, 'print'], [?(, ?(],
                                        [:STRING, '...'],
                                      [?), ?)],
                                      [:NEWLINE, "\n"],
              [:IF, 'if'], [:FALSE, 'false'],
                [:INDENT, 6],
                  [:IDENTIFIER, 'pass'],
                [:DEDENT, 4], [:NEWLINE, "\n"],
                [:IDENTIFIER, 'print'], [?(, ?(],
                                          [:STRING, 'done!'],
                                        [?), ?)],
            [:DEDENT, 2], [:NEWLINE, "\n"],
            [:NUMBER, 2],
        [:DEDENT, 0], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
      [:IDENTIFIER, 'print'], [:STRING, "The End"],
    ]

    assert_equal tokens, Lexer.tokenize(code)
  end
end
