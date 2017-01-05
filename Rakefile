require 'tempfile'
require 'chef/cookbook/metadata'
require 'json'

metadata_file = 'metadata.rb'
metadata = Chef::Cookbook::Metadata.new
metadata.from_file(metadata_file)

repository_name = metadata.name
# cookbook_version = metadata.version

branch = ENV['BRANCH_NAME']

task :test do
  require 'foodcritic'
  require 'rubocop/rake_task'
  puts 'Running foodcritic'
  result = FoodCritic::Linter.new.check cookbook_paths: '.'
  if result.failed? || !result.warnings.empty?
    puts 'foodcritic failed:'
    puts result
    raise
  end
  puts 'Running rubocop'
  task = RuboCop::RakeTask.new
  # We probably should catch this error
  task.fail_on_error = true
  result = task.run_main_task(false)
  puts result
end

task :build_environment do
  puts "building branch #{branch} in #{repository_name}"
  environment_name = case branch
                     when 'prod'
                       repository_name
                     else
                       "#{repository_name}-#{branch}"
                     end

  puts 'updating berksfile'
  sh %(berks update)

  puts 'installing berksfile'
  sh %(berks install)

  puts 'building environment file'
  environment_file = Tempfile.new([environment_name, '.json'])
  puts "writing to #{environment_file.path}"
  environment_attrs = {}

  puts '... setting name and description'
  environment_attrs['name'] = environment_name
  environment_attrs['description'] = metadata.description
  environment_attrs['json_class'] = 'Chef::Environment'
  environment_attrs['chef_type'] = 'environment'
  environment_attrs['cookbook_versions'] = {}
  environment_attrs['default_attributes'] = {}
  environment_attrs['override_attributes'] = {}

  puts '... adding environment attributes (later- feature not ready)'

  puts 'writing environment file'
  environment_file.write(environment_attrs.to_json)
  environment_file.close

  puts 'installing version pins'
  sh %(berks apply #{environment_name} -f #{environment_file.path})

  puts 'uploading cookbooks to chef server'
  sh %(berks upload)

  puts "applying branch to environment #{environment_name}"
  sh %(knife environment from file #{environment_file.path})
end
