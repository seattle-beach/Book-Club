desc 'Run a .tst file'
task :test, [:file, :type] do |t, args|
  tst_file = "projects/#{args[:file]}.tst"
  script = case args[:type]
           when 'hs'
             'HardwareSimulator'
           when 'ce'
             'CPUEmulator'
           end
  cmd = File.expand_path("../tools/#{script}.sh", __FILE__)

  require 'open3'
  _, stdout, stderr = Open3.popen3(cmd, tst_file)

  out = stdout.read
  err = stderr.read
  puts out unless out.empty?
  puts err unless err.empty?

  line = err[/Comparison failure at line (\d+)/, 1]
  exit if line.nil?
  line = line.to_i - 1

  tst = File.read(tst_file)

  output_file = tst[/output-file ([.\w]+),/, 1]
  compare_to = tst[/compare-to ([.\w]+),/, 1]

  Dir.chdir(File.dirname(tst_file))
  puts <<-PUTS
Expected:
  #{File.readlines(compare_to)[line].chomp}
Actual:
  #{File.readlines(output_file)[line].chomp}
  PUTS
end

desc 'Translate ASM to Hack'
task :assemble, [:file] do |t, args|
  asm = "projects/#{args[:file]}.asm"
  cmd = File.expand_path('../tools/Assembler.sh', __FILE__)
  sh cmd, asm
  mv File.expand_path('~/Dropbox/src/github.hack'), asm.pathmap('%X.hack')
end
