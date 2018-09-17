require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

ENV['RACK_ENV'] = 'production'
APP_FILE  = 'app.rb'
APP_CLASS = 'App'
require 'sinatra/assetpack/rake'

def compile_custom(path, target_file)
  response = app.assets.send(:build_get, path)
  File.open(File.join(app.settings.public_folder, target_file), 'w+') do |f|
    f.puts response.body
  end
  puts "Precompiling #{path} to #{target_file} ..."
end

task :clean do
  rm_rf 'public'
  rm_rf 'doc'
  rm_f 'CHANGELOG.md'
end

task :build => :clean do
  mkdir 'public'
  compile_custom('/', 'index.html')
  Rake::Task['assetpack:precompile:packages'].invoke
  cp_r(File.join(app.settings.root, 'app', 'fonts'), File.join(app.settings.public_folder, 'fonts'))
  cp_r(File.join(app.settings.root, 'app', 'images'), File.join(app.settings.public_folder, 'images'))
  cp(File.join(app.settings.root, 'app', 'images', 'favicons', 'favicon.ico'), File.join(app.settings.public_folder, 'favicon.ico'))
  cp(Dir[File.join(app.settings.root, 'app', 'conf', '*.default.yml')], File.join(app.settings.public_folder))
  Dir[File.join(app.settings.public_folder, '*.yml')].each do |entry|
    mv(entry, "#{entry}.txt", force: true)
  end
end

task :doc do
  File.open('CHANGELOG.md', 'w') do |f|
    f << `git-changelog`
  end
  system('codo')
  cp_r(File.join(app.settings.root, 'screenshots'), File.join(app.settings.root, 'doc', 'extra'))
end

require 'coffee-script'
require 'fileutils'
def coffee_compile(source_dir, target_dir)
  glob = File.join(source_dir, '**/*.coffee')
  Dir[glob].each do |file|
    target_file = file.
                  gsub(/^#{source_dir}/, target_dir).
                  gsub(/\.coffee$/, '.js')
    target_file_dir = File.dirname(target_file)
    puts " #{file} to #{target_file}"
    FileUtils.mkdir_p(target_file_dir)
    File.open(target_file, "w") do |f|
      f.puts CoffeeScript.compile(File.read(file))
    end
  end
end

namespace :test do
  desc "Compile app and spec coffeescripts."
  task :compile do
    puts "Compiling app coffeescripts for testing ..."
    coffee_compile('./app/js', './spec/app_js')

    puts "Compiling spec coffeescripts for testing ..."
    coffee_compile('./spec/coffeescripts', './spec/javascripts')

    puts "Copying vendored javascript for testing ..."
    cp(Dir["./app/js/vendor/*.js"], "./spec/app_js/vendor/")

    puts "Copying config files for testing ..."
    cp(Dir["./app/conf/*.default.yml"], "./spec/app_js/")
    Dir['./spec/app_js/*.yml'].each do |entry|
      mv(entry, "#{entry}.txt", force: true)
    end
  end

  desc "Run jasmine specs."
  task :run => 'jasmine:ci'

  desc "Clean all untracked and ignored files on ./spec folder."
  task :clean do
    sh 'git clean -f -d -x -- ./spec'
  end
end

desc "Compile, run and clean specs."
task :test => ['test:compile', 'test:run']
