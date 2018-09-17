require './app'

ignore(/\/\./)

group :development do
  guard 'livereload' do
    watch(/app\/.+/)
    watch(/views\/.+\.haml/)
    watch(/spec\/.+\.js$/)
  end

  guard :rack, port: 9292 do
    watch('Gemfile.lock')
    watch('app.rb')
    watch(/.+\.yml/)
  end
end

group :test do
  options = {
    input: 'app/js',
    output: 'spec/app_js',
    all_on_start: true,
    patterns: [/^app\/js\/(.*\.coffee)$/]
  }
  guard 'coffeescript', options do
    options[:patterns].each { |pattern| watch(pattern) }
  end

  options = {
    input: 'spec/coffeescripts',
    output: 'spec/javascripts',
    all_on_start: true,
    patterns: [/^spec\/coffeescripts\/(.*\.coffee)$/]
  }
  guard 'coffeescript', options do
    options[:patterns].each { |pattern| watch(pattern) }
  end

  guard :copy3, from: 'app/js/vendor', to: 'spec/app_js/vendor'
  guard :copy3, from: 'app/conf/settings.default.yml', to: 'spec/app_js/settings.default.yml.txt', rename: true
  guard :copy3, from: 'app/conf/labels.default.yml', to: 'spec/app_js/labels.default.yml.txt', rename: true
end
