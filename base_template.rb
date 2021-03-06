#Setting Time and Date
day, month, year = Time.now.day, Time.now.month, Time.now.year

#Adding Author and Company Info
project  = ask("What is the title of the project?(My Project) >")
project = 'My Project' if project.blank?

email  = ask("Authors Email Address?(user@gmail.com) >")
email = 'user@gmail.com' if email.blank?

full_name = ask("What is the authors full name?(Anonymous) >")
full_name = 'Anonymous' if full_name.blank?

company = ask("What is your authors company name?(Company Name) >")
company = 'Company Name' if company.blank?

company_url = ask("What is your authors company url?(http://yourdomain.com) >")
company_url = 'http://yourdomain.com' if company_url.blank?

file "README", <<-END
##
# Project: #{project}
# Author: #{full_name}
# Email: #{email}
# Company: #{company}
# Date Created: #{month}/#{day}/#{year}
##
END

#End Adding Company Info

#setting up github as source
run 'gem sources -a http://gems.github.com'
#to install gem project use
#run 'gem install username-projectname'

#end

#Setting up database
mysql_config_path = run 'which mysql_config'
run 'gem install mysql -- --with-mysql-config=' + mysql_config_path

#puts 'mysql_config_path: ' + mysql_config_path + '\n'

db_type = ask("What database type(sqlite)?\n\n[1] mysql\n[2] sqlite")
db_type = '2' if db_type.blank?

if db_type == '1' then 
  gem 'mysql', :lib => 'mysql'

  db_host = ask("What’s your db hostname?(localhost)")
  db_host = 'localhost' if db_host.blank?

  db_user = ask("What’s your db username?")
  db_user = 'root' if db_user.blank?
  
  db_pass = ask("What’s your db password?")
  db_pass = '' if db_pass.blank?

  db_prefix = ask("What’s your db prefix? (eg. \#{db_prefix}_development)")
  db_prefix = '' if db_prefix.blank?
  db_prefix = db_prefix + '_' if !db_prefix.blank?

file 'config/database.yml', <<-END
development:
  adapter: mysql
  encoding: utf8
  host: #{db_host}
  user: #{db_user}
  password: #{db_pass}
  database: #{db_prefix}_dev

test:
  adapter: mysql
  encoding: utf8
  host: #{db_host}
  user: #{db_user}
  password: #{db_pass}
  database: #{db_prefix}_test

production:
  adapter: mysql
  encoding: utf8
  host: #{db_host}
  user: #{db_user}
  password: #{db_pass}
  database: #{db_prefix}_prod
END

end

#backing up db settings
run 'cp config/database.yml config/database.yml.example'
rake 'db:create:all'

#end setting up databases

#setup env
# the gem command currently doesn't support specific environments
# so we have to edit config/environments/test.rb directly
#file 'config/environments/test.rb', <<-END
#{File.read('config/environments/test.rb')}
#config.gem 'cucumber', :lib => false, :version => '>= 0.2.2'
#END
#end env

# Testing:
test_gem  = ask("How will you test?(Rspec)\n\n[1] Shoulda\n[2] Rspec")
test_gem = '2' if test_gem.blank?

#Installing javascripts & plugins

#Download JQuery
run 'curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js'
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js > public/javascripts/jquery-1.2.6.min.js"
run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js > public/javascripts/jquery.form.js"

# Install plugins
gem 'haml', :lib => 'haml'
gem 'sqlite3-ruby', :lib => 'sqlite3'
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
gem 'RedCloth', :lib => 'redcloth'

#plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :submodule => true
#plugin 'acts_as_taggable_redux', :svn => 'http://svn.devjavu.com/geemus/rails/plugins/acts_as_taggable_redux', :submodule => true

#plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git', :submodule => true
#plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git', :submodule => true

#plugin_exception = ask("Install Exception Notifier?(Yes)\n[1] Yes\n[2] No")
#plugin_exception = '1' if plugin_exception.blank?





#plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git', :submodule => true
#plugin 'factory_girl', :git => 'git://github.com/thoughtbot/factory_girl.git', :submodule => true
#plugin 'shoulda', :git => 'git://github.com/thoughtbot/shoulda.git', :submodule => true
#plugin 'quietbacktrace', :git => 'git://github.com/thoughtbot/quietbacktrace.git', :submodule => true
#plugin 'aasm', :git => 'git://github.com/rubyist/aasm.git', :submodule => true

#plugin 'cucumber', :git => 'git://github.com/aslakhellesoy/cucumber.git', :submodule => true 
#plugin 'redgreen', :git => 'git://github.com/JackDanger/jspec_red_green.git', :submodule => true 


#Installing Authentication Plugins
use_auth  = ask("Install User Authentication?(Yes)\n\n[1] Yes\n[2] No")
use_auth = '1' if use_auth.blank?

if use_auth == '1'
  use_auth_type  = ask("Which Authentication?(Authlogic)\n\n[1] Restful\n[2] Authlogic")
  use_auth_type = '2' if use_auth_type.blank?

  if use_auth_type == '1' then
    plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git', :submodule => true
  else 
    gem 'authlogic', :lib => 'authlogic', :source => 'http://gems.github.com'
    #plugin 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git', :submodule => true
  end

  use_openid  = ask("Install OpenId?(No)\n\n[1] Yes\n[2] No")
  use_openid = '2' if use_openid.blank?

  if use_openid == '1' then
    gem 'ruby-openid', :lib => 'openid'
    plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git', :submodule => true
  end

  use_role_requirement  = ask("Install Role Requirement?(No)\n\n[1] Yes\n[2] No")
  use_role_requirement = '2' if use_role_requirement.blank?

  if use_role_requirement == '1' then
    plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git', :submodule => true
  end

end

#End Authentication Setup

#make sure all gems are installed
#run 'rake gems:install'
#rake('gems:install', :sudo => true)

#end all gem install

#Setup Git
git :init

run 'git config --global user.name "' + full_name +'"'
run 'git config --global user.email "' + email +'"'

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

# Initialize submodules
git :submodule => "init"
#rake('gems:install', :sudo => true)

 
# Set up sessions, RSpec, user model, OpenID, etc, and run migrations
#rake('db:sessions:create')
#generate("authenticated", "user session")
#generate("roles", "Role User")
#rake('open_id_authentication:db:create')

#generate("rspec")
#rake('acts_as_taggable_redux:db:create')

#rake('db:migrate')

# Set up session store initializer
#initializer 'session_store.rb', <<-END
#ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
#ActionController::Base.session_store = :active_record_store
#END


# creating articles
run 'script/generate scaffold article slug:string title:string body:text'
run 'rake db:migrate'
#

#build common controllers
generate :controller, "dashboard index show"
generate :controller, "articles index show"
#end common controllers

# Delete unnecessary files
run "rm -rf ./app/views/layouts/*"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm public/images/rails.png"
# End Delete unnecessary files

#creating pages
file "app/controllers/articles_controller.rb", <<-END
class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    render :action => params[:page]
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
end
END

file "public/stylesheets/application.css", <<-END
body{
background:lightblue;
text-align:center;
margin:0px;
padding:0px;
}
#wrapper{
width:750px;
background:white;
border:1px solid black;
margin-top:20px;
text-align:left;
margin-left:auto;
margin-right:auto;
padding:20px;
}
#navigation{
width:300px;
float:right;
text-align:right;
}
#navigation a{
color:black;
text-decoration:none;
}
END

file "app/views/layouts/_navigation.rhtml", <<-END
<div id="navigation">
	<%= link_to "Home", :controller => "/" %> | 	
  <%= link_to "Login", :controller => "/users/login" %> | 
  <%= link_to_unless_current("About Us", { :action => "about" }) %>
</div>
END

file "app/views/layouts/_footer.rhtml", <<-END
<div id="navigation">
  <%= link_to "Home", :controller => "/" %> | 	
  <%= link_to "Exceptions", :controller => "/logged_exceptions" %> | 
  <%= link_to_unless_current("About Us", { :action => "about" }) %> | 
  <%= link_to_unless_current("Privacy", { :action => "privacy" }) %>
</div>
END

file "app/views/layouts/application.html.haml", <<-END
!!! Strict
%html
  %head
    %title | #{project}
    = stylesheet_link_tag("application")
  %body
    #wrapper
      #header
        = render :partial => 'layouts/navigation'
      #content
        = yield
      #footer
        = render :partial => 'layouts/footer'
END

file "app/views/articles/home.rhtml", <<-END
<h1>Welcome to #{project}</h1>
<p>This project was created by #{full_name}</p>
END

#end pages
#setup routes
route 'map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"'
route "map.root :controller => 'articles', :action => 'show', :page => 'home'"
route "map.resources :controller => 'dashboard'"
route "map.resources :controller => 'articles'"
#end routes


#doing initial commit
git :add => ".", :commit => "-m 'initial commit'"

#Thank you for taking the time to read this!
#We love you more then you know! Moo

#run 'script/server'