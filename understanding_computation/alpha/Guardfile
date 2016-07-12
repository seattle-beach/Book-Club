guard :minitest, test_folders: %w[.] do
  watch(%r{^test_(.*)\.rb$})
  watch(%r{^([^/]+)\.rb$})     { |m| "test_#{m[1]}.rb" }
end
