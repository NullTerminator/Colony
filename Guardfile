guard 'rspec', spec_paths: ["spec"], cmd: "bundle exec rspec --color --format documentation", all_after_pass: false, all_on_start: true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
end
