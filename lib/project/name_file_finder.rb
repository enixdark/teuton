# frozen_string_literal: true

require 'rainbow'
require_relative '../application'

# Project#find
module NameFileFinder
  def self.find_filenames_for(relpathtofile)
    pathtofile = File.join(Application.instance.running_basedir, relpathtofile)

    # Define:
    #   script_path, must contain fullpath to DSL script file
    #   config_path, must contain fullpath to YAML config file

    if File.directory?(pathtofile)
      # COMPLEX MODE: We use start.rb as main RB file
      find_filenames_from_directory(pathtofile)
    else
      # SIMPLE MODE: We use pathtofile as main RB file
      find_filenames_from_rb(pathtofile)
    end
    true
  end

  def self.find_filenames_from_directory(pathtodir)
    # COMPLEX MODE: We use start.rb as main RB file
    script_path = File.join(pathtodir, 'start.rb')
    unless File.exist? script_path
      print Rainbow('[ERROR] File ').red
      print Rainbow(script_path).bright.red
      puts Rainbow(' not found!').red
      exit 1
    end

    app = Application.instance
    app.project_path = pathtodir
    app.script_path = script_path
    app.test_name = pathtodir.split(File::SEPARATOR)[-1]

    config_path = ''
    if app.options['cpath'].nil?
      config_name = 'config'
      # Config name file is introduced by cname arg option from teuton command
      config_name = app.options['cname'] unless app.options['cname'].nil?
      config_path = File.join(pathtodir, "#{config_name}.json")
      unless File.exist? config_path
        config_path = File.join(pathtodir, "#{config_name}.yaml")
      end
    else
      # Config path file is introduced by cpath arg option from teuton command
      config_path = app.options['cpath']
    end
    app.config_path = config_path
  end

  def self.find_filenames_from_rb(script_path)
    # SIMPLE MODE: We use script_path as main RB file
    # This must be fullpath to DSL script file
    if File.extname(script_path) != '.rb'
      print Rainbow('[ERROR] Script ').red
      print Rainbow(script_path).bright.red
      puts Rainbow(' must have rb extension').red
      exit 1
    end

    app = Application.instance
    app.project_path = File.dirname(script_path)
    app.script_path = script_path
    app.test_name = File.basename(script_path, '.rb')

    config_path = ''
    if app.options['cpath'].nil?
      config_name = File.basename(script_path, '.rb')
      # Config name file is introduced by cname arg option from teuton command
      config_name = app.options['cname'] unless app.options['cname'].nil?

      config_path = File.join(app.project_path, config_name + '.json')
      unless File.exist? config_path
        config_path = File.join(app.project_path, config_name + '.yaml')
      end
    else
      # Config path file is introduced by cpath arg option from teuton command
      config_path = app.options['cpath']
    end
    app.config_path = config_path
  end

  def self.puts_input_info_on_screen
    app = Application.instance

    verbose Rainbow('[INFO] ScriptPath => ').blue
    verboseln Rainbow(app.script_path).blue.bright
    verbose Rainbow('[INFO] ConfigPath => ').blue
    verboseln Rainbow(app.config_path).blue.bright
    verbose Rainbow('[INFO] TestName   => ').blue
    verboseln Rainbow(app.test_name).blue.bright
  end

  def self.verboseln(text)
    verbose(text + "\n")
  end

  def self.verbose(text)
    print text if Application.instance.verbose
  end
end
