require "sinatra"

configure do
  # Format options
  {:Markdown => 'maruku', :Textile => 'RedCloth'}.each do |name, gem|
    begin
      require "#{gem}"
    rescue LoadError => e
      puts <<-MSG
To format #{name} as well:
$ gem install #{gem}
It is not needed though.
MSG
    end
  end

  Dir.chdir ARGV[0] if ARGV[0]
end

helpers do
  def title
    File.basename(Dir.getwd).gsub(/_/, ' ')
  end

  def pages
    (Dir["*.md"] + Dir["*.markdown"]).sort
  end
end

get '/' do
  redirect '/pages/'
end

get '/pages/' do
  @pages = pages.sort
  haml :pages
end

get '/pages/:page.:ext' do
  begin
    filename = "#{params[:page]}.#{params[:ext]}"
    File.open(filename) do |file|
      @output = case params[:ext]
                when "markdown", "md"
                  Maruku.new(file.read).to_html
                when "textile"
                  RedCloth.new(file.read).to_html
                else
                  file.read
                end
    end
    haml :page
  rescue
    raise Sinatra::NotFound
  end
end

__END__

@@layout
!!! XML
!!!
%html
  %head
    %link{:rel => 'stylesheet', :href => 'http://fonts.googleapis.com/css?family=Molengo', :type => 'text/css'}
    %link{:rel => 'stylesheet', :href => 'http://fonts.googleapis.com/css?family=OFL+Sorts+Mill+Goudy+TT', :type => 'text/css'}
    %link{:rel => 'stylesheet', :href => "/stylesheets/reset.css", :type => 'text/css'}
    %link{:rel => 'stylesheet', :href => "/stylesheets/960.css", :type => 'text/css'}
    %link{:rel => 'stylesheet', :href => "/stylesheets/style.css", :type => 'text/css'}
    %meta{'http-equiv' => "Content-Type", :content => "text/html; charset=utf-8"}/
    
  %body
    %div#main.container_16
      %h1 Arbousier.info docs
      #container= yield
      %div.clear
      %div.grid_16
        #footer
          powered by
          %a{:href => 'http://github.com/mcansky/gaze'} mcansky/gaze
          fork of
          %a{:href => 'http://github.com/ichverstehe/gaze'} ichverstehe/gaze
      %div.clear

@@pages
%div.grid_16
  %div#content
    %h2 Pages
    %ul
      - @pages.each do |page|
        %li.page
          %a{:href => "/pages/#{page}"}= page.split(".").first.gsub(/[_-]/,' ').capitalize
          %span.date= File.mtime(page).strftime("%d/%m/%Y %H:%M")
%div.clear

@@page
%div.grid_16
  %div#content
    %div.root
      %a{:href => "/pages/"} Index
    ~ @output
%div.clear