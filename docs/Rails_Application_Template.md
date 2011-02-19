## Rails Application Template

Rails 3.0 introduced a new way to build generators by using [Thor](https://github.com/wycats/thor) a Ruby based replacement for Rake. Thor is closer to a Ruby than Rake which is more influenced by Make, yet it stills got some make like stuff.

A use of Thor in Rails 3.0 is application templating. The idea is to be able to pass a template to the `rails new` command :

    rails new appname -m the_template.rb

There is some options good to know :

    % rails --help
    [...]
    -d, [--database=DATABASE]   # Preconfigure for selected database (options: mysql/oracle/postgresql/sqlite3/frontbase/ibm_db)
                               # Default: sqlite3
    -b, [--builder=BUILDER]     # Path to an application builder (can be a filesystem path or URL)
    -m, [--template=TEMPLATE]   # Path to an application template (can be a filesystem path or URL)
       [--dev]                 # Setup the application with Gemfile pointing to your Rails checkout
       [--edge]                # Setup the application with Gemfile pointing to Rails repository
       [--skip-gemfile]        # Don't create a Gemfile
    -O, [--skip-active-record]  # Skip Active Record files
    -T, [--skip-test-unit]      # Skip Test::Unit files
    -J, [--skip-prototype]      # Skip Prototype files
    -G, [--skip-git]            # Skip Git ignores and keeps
    [...]
    %

Some stuff has been cut out but the options relevant to us are all here. Pay a special attention to _-T_, and _-J_. Those two options could be helpfull to you if you plan to replace _Test::Unit_ by _rspec_ and _Prototype.js_ by _jQuery_. This is gonna be the case for us here.

How does it work ? It's quite simple : we provide Rails with a kindda script to run after he created the app. Usually you probably want to keep it clean and organized. In a matter of sense I've chosen to follow some ideas from [leshill app template example](https://github.com/leshill/rails3-app/blob/master/app.rb) : first the gems, then get some files from the internets (css, rake tasks, ...), then create some files using inline templates (layout and such), then init git, then install RVM rc file, then install most needed gems (bundler, etc), then go on some tests to finish building the Gemfile then run the `bundle install` command and display a log message.

### Gemfile

    ## first the gems
    # test stuff
    gem "factory_girl_rails", ">= 1.0.0", :group => :test
    gem "rspec-rails", ">= 2.2.1", :group => [:development, :test]
    # shiny markup stuff
    gem "haml-rails", ">= 0.3.4"
    # wooot vars in css
    gem 'hassle', :git => 'git://github.com/koppen/hassle.git'
    # replacement for prototype.js
    gem "jquery-rails"
    # http server
    gem "thin"
    # mostly for heroku
    gem "pg", :group => [:production]
    # doc goodness
    gem "yard"

Nothing fancy here as you can see. Just the use of the `gem` command with the same syntax as in the _Gemfile_ file.

### File creation

    # getting 960.gs css files
    nsmith_960_gs = "https://github.com/nathansmith/960-Grid-System/raw/master/code/css"
    get "#{nsmith_960_gs}/960.css", "public/stylesheets/960.css"
    get "#{nsmith_960_gs}/reset.css", "public/stylesheets/reset.css"
    get "#{nsmith_960_gs}/text.css", "public/stylesheets/text.css"
    # get the base sass file
    github_home = "https://github.com/mcansky/arbousier_scripts/raw/master"
    get "#{github_home}/sass/style.sass", "public/stylesheets/sass/style.sass"
    # get rake tasks
    get "#{github_home}/rake_tasks/undies.rb", "lib/tasks/undies.rake"

Simple again : we `get` some files from outside. The syntax is `get <origin> <destination>`.

    # taking care of the layout
    log "Generating layout"
    layout = <<-LAYOUT
    !!!
    %html
    %head
    %title #{app_name.humanize}
    %link{:href => "http://fonts.googleapis.com/css?family=OFL+Sorts+Mill+Goudy+TT", :rel => "stylesheet", :type => "text/css"}
    %link{:href => "http://fonts.googleapis.com/css?family=Molengo", :rel => "stylesheet", :type => "text/css"}
    = stylesheet_link_tag "reset.css"
    = stylesheet_link_tag "text.css"
    = stylesheet_link_tag "960.css"
    = stylesheet_link_tag "style"
    = javascript_include_tag :defaults
    = csrf_meta_tag
    %body
    %div.container_16{:id => "main"}
      = yield
    LAYOUT

    remove_file "public/index.html"
    remove_file "app/views/layouts/application.html.erb"
    create_file "app/views/layouts/application.html.haml", layout

Here we are _removing_ files and _creating_ the layout. As you can guess we are using what has been put in the _layout_ var into the template file when creating it. If we didn't have added the _layout_ at the end of the `create_file` command a simply blank file would have been created.

Those familiar with Perl or shell script have probably recognized that old style to create a multiline var, it's pretty easy to understand but just to be sure I'm gonna explain it a bit. The idea is to first declare a stop flag, put the multiline value you want to see assigned to the variable and then put the stop flag. Ruby will see the `<<-FLAG` as a signal saying "_pass the following stuff into the var until you see FLAG again_".

    # adding yardoc opts file
    yardopts = <<-YARDOPTS
    'lib/**/*.rb' 'app/**/*.rb' README CHANGELOG LICENSE
    YARDOPTS
    create_file ".yardopts", yardopts

Again same thing. Here we are creating a yardopts file to tell *Yardoc* what to do.

### Git

Simple git initializer.

    # git stuff
    create_file "log/.gitkeep"
    create_file "tmp/.gitkeep"
    log "Initializing git repository"
    git :init
    git :add => "."

### RVM & Bundler

    # rvm rc creation
    log "Running rvm"
    run "rvm use --create --rvmrc ruby-1.9.2-p0@#{app_name}"

We can see here the use of the `run` command, just like the `system` method. We also meet the `log` command, that will output the param to the console.

    log "Installing bundler"
    run "gem install bundler"

Oh my, diffiiiicult.

### Devise and some trouble

The following part can be simplified (and I will later) but it's a good example of what you can do :

    if yes?("Would you like to install Devise?")
      gem("devise")
      log "Running bundle install"
      run "bundle install --path bundler --without production"
      generate("devise:install")
      model_name = ask("What would you like the user model to be called? [user]")
      model_name = "user" if model_name.blank?
      generate("devise", model_name)
      log <<-DOCS

      Congratulations #{app_name.humanize} is generated with :
        * factory girl
        * rspec
        * haml
        * jquery
        * 960.gs
        * thin
        * devise

      Now simply go in your app
      % cd #{app_name}
      DOCS

So you see three new things here : `yes?`, `generate` and `ask`. `yes?` and `ask` are ways to ask the user for some stuff, `generate` let you call some generators. `yes?` directly test simple question "yes/no" and allow you to quickly split the code around that. `ask` is more simple : you ask a question and you will get the answer entered by the user.

I'll save you the else part here as it's just the same thing.

### How to run ?

So now we can run this. We are supposed to be able to get the file directly using the url but, for some reason, maybe the ssl, I'm not able to. So here is what I do :

    % curl -O https://github.com/mcansky/arbousier_scripts/raw/master/rails_templates/basic.rb
    % rails new -JTm basic.rb
    ...

And we are done here, happy coding.