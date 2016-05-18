class Tst
  attr_reader :path, :raw
  attr_reader :load, :output_file, :compare_to
  attr_reader :line

  def initialize(path)
    @path = path.pathmap('%X.tst')
    @raw = File.read(@path)

    dir = path.pathmap('%d')
    @load = File.join(dir, raw[/load ([.\w]+),/, 1])
    @output_file = File.join(dir, raw[/output-file ([.\w]+),/, 1])
    @compare_to = File.join(dir, raw[/compare-to ([.\w]+),/, 1])
  end

  def run!
    script = case @load.pathmap('%x')
             when '.hdl'
               'HardwareSimulator'
             when '.hack'
               'CPUEmulator'
             end
    cmd = File.expand_path("../tools/#{script}.sh", __FILE__)

    require 'open3'
    _, stdout, stderr = Open3.popen3(cmd, self.path)

    out = stdout.read
    err = stderr.read
    puts out unless out.empty?
    puts err unless err.empty?

    line = err[/Comparison failure at line (\d+)/, 1]
    exit if line.nil?
    @line = line.to_i - 1
  end

  def results
    expected = File.readlines(compare_to).map(&:chomp)
    actual = File.readlines(output_file).map(&:chomp)
    <<-PUTS
  #{expected[0]}
Expected:
  #{expected[line]}
Actual:
  #{actual[line]}
    PUTS
  end
end

desc 'Run a .tst file'
task :test, [:tst] do |t, args|
  tst = Tst.new(File.join('projects', args[:tst]))
  tst.run!
  puts tst.results
end

FileList['**/*.asm'].each do |asm|
  hack = asm.pathmap('%X.hack')
  file hack => asm do
    cmd = File.expand_path('../tools/Assembler.sh', __FILE__)
    sh cmd, asm
    mv File.expand_path('~/Dropbox/src/github.hack'), hack
  end
end
