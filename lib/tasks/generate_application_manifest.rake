task :generate_appcache_file => ['deploy:precompile_assets', 'html5_manifest']

desc "Create html5 manifest.appcache"
task :html5_manifest => :environment do
  puts 'Creating appcache manifest file...'

  File.open("public/manifest.appcache", "w") do |f|
    f.write("CACHE MANIFEST\n")
    f.write("# Version #{Time.now.to_i}\n\n")


    action_view = ActionView::Base.new
    action_view.stylesheet_link_tag("application").split("\n").collect{|a|       f.puts  a.match(/href=\"(.*)\"/)[1].to_s }
    action_view.javascript_include_tag("application").split("\n").collect{|a|     f.puts a.match(/src=\"(.*)\"/)[1].to_s }


    f.write("\nNETWORK:\n")
    f.write("*\n")
    f.write("http://*\n")
    f.write("https://*\n")
  end
  puts 'Done.'
end

namespace :deploy do
  task :precompile_assets do
    require 'fileutils'
    if File.directory?("#{Rails.root.to_s}/public/assets")
      FileUtils.rm_r "#{Rails.root.to_s}/public/assets"
    end

    puts 'Precompiling assets...'
    puts `RAILS_ENV=production bundle exec rake assets:precompile`
    puts 'Done.'
  end
end
