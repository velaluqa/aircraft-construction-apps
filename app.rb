Bundler.require

require "stylus"
require "stylus/tilt"

class App < Sinatra::Base
  register Sinatra::JstPages
  serve_jst '/js/templates.js'

  register Sinatra::AssetPack

  assets do
    serve '/js',     from: 'app/js'
    serve '/css',    from: 'app/css'
    serve '/images', from: 'app/images'
    serve '/fonts',  from: 'app/fonts'

    # Make sure to include assets relatively to the including file
    asset_hosts ['.']

    js :app, '/js/app.js', [
                            '/js/vendor/modernizr-*.js',
                            '/js/vendor/three-*.js',
                            '/js/vendor/jquery-*.js',
                            '/js/vendor/hammer-*.js',
                            '/js/vendor/underscore-*.js',
                            '/js/vendor/backbone-*.js',
                            '/js/vendor/jquery.backbone-hammer.js',
                            '/js/vendor/jquery.keyboard-modifiers.js',
                            '/js/vendor/request_animation_frame.js',
                            '/js/vendor/jquery.scrollTo-*.js',
                            '/js/vendor/jquery.after-transition.js',
                            '/js/vendor/Markdown.Converter.js',
                            '/js/vendor/Markdown.Extra.js',
                            '/js/vendor/Markdown.Toc.js',
                            '/js/vendor/persistjs-*.js',
                            '/js/vendor/js-yaml-*.js',
                            '/js/vendor/jquery.mark-*.js',
                            '/js/vendor/poised/*.js',
                            '/js/vendor/markup_text.js',
                            '/js/vendor/backbone.poised/underscore_ext.js',
                            '/js/vendor/backbone.poised/patches.js',
                            '/js/vendor/backbone.poised/view.js',
                            '/js/vendor/backbone.poised/**/*.js',
                            '/js/vendor/gaussianElimination.js',
                            '/js/templates.js',
                            '/js/lib/application.js',
                            '/js/lib/bootstrap_data.js',
                            '/js/lib/models/base_app_model.js',
                            '/js/lib/models/**/*.js',
                            '/js/lib/views/canvas.js',
                            '/js/lib/views/**/*.js',
                            '/js/lib/collections/**/*.js',
                            '/js/lib/apps/*/models/**/*.js',
                            '/js/lib/apps/*/views/**/*.js',
                            '/js/lib/apps/*/collections/**/*.js',
                            '/js/lib/router.js',
                            '/js/lib/mathjaxConfig.js'
                           ]
    css :app, '/css/app.css', ['/css/screen.css']

    js_compression :yui
    css_compression :simple
  end

  set :root,          File.expand_path('.', File.dirname(__FILE__))
  set :views,         File.expand_path('./app/views', File.dirname(__FILE__))
  set :public_folder, File.expand_path('./public', File.dirname(__FILE__))

  configure do
    # TODO: make sure nib and stylus node modules are installed
    Stylus.use :nib
    Stylus.use :poised
    enable :raise_errors, :logging
  end

  configure :development do
    enable :show_exceptions
    Stylus.debug = true
  end

  get '/' do
    haml :index
  end

  # Use .txt extension to avoid issues with the ILR IIS
  get '/:file_name.yml.txt' do |file_name|
    path = File.expand_path(File.join('./app/conf/', "#{file_name}.yml"), File.dirname(__FILE__))
    if File.exists?(path)
      File.read(path)
    else
      status 404
    end
  end

  get '/help/:file_name.txt' do |file_name|
    path = File.expand_path(File.join('./app/help/', "#{file_name}"), File.dirname(__FILE__))
    if File.exists?(path)
      File.read(path)
    else
      status 404
    end
  end
end
