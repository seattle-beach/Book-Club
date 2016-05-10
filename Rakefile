desc 'Test w/Hardware Simulator'
task :test, [:file] do |t, args|
  tst_file = "projects/#{args[:file]}.tst"
  cmd = File.expand_path('../tools/HardwareSimulator.sh', __FILE__)

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
  puts `diff #{compare_to} #{output_file}`
end
