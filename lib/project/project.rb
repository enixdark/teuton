# frozen_string_literal: true

require_relative '../application'
require_relative 'name_file_finder.rb'

# Project functions invoked by CLI project tool
# * test
# * play
# * process_input_case_option
# * readme
# * require_dsl_and_script
module Project
  def self.test(pathtofile, options)
    Application.instance.options.merge! options
    NameFileFinder.find_filenames_for(pathtofile)
    NameFileFinder.puts_input_info_on_screen
    require_dsl_and_script('laboratory/laboratory') # Define DSL keywords

    app = Application.instance
    lab = Laboratory.new(app.script_path, app.config_path)
    # lab.show_requests if options[:r]
    lab.show_config if options[:c]
    lab.show_dsl unless options[:r] || options[:c]
  end

  def self.play(pathtofile, options)
    Application.instance.options.merge! options
    process_input_case_option
    NameFileFinder.find_filenames_for(pathtofile)
    NameFileFinder.puts_input_info_on_screen
    require_dsl_and_script('../case_manager/dsl') # Define DSL keywords
  end

  def self.process_input_case_option
    options = Application.instance.options
    unless options['case'].nil?
      a = options['case'].split(',')
      options['case'] = a.collect! { |i| i.to_i }
    end
  end

  def self.readme(pathtofile, options)
    Application.instance.options.merge! options
    NameFileFinder.find_filenames_for(pathtofile)
    require_dsl_and_script('readme/readme') # Define DSL keywords

    app = Application.instance
    readme = Readme.new(app.script_path, app.config_path)
    readme.show
  end

  def self.require_dsl_and_script(dslpath)
    app = Application.instance
    require_relative dslpath
    begin
      require_relative app.script_path
    rescue SyntaxError => e
      puts e.to_s
      puts Rainbow.new("[ERROR] SyntaxError into file #{app.script_path}").red
    end
  end
end
