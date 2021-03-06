# frozen_string_literal: true

require 'rainbow'

# Class method Teuton#version
class Teuton < Thor
  map ['v', '-v', '--version'] => 'version'
  desc 'version', 'Show the program version'
  def version
    app = Application.instance
    print Rainbow(app.name).bright.blue
    puts  ' (version ' + Rainbow(app.version).green + ')'
  end
end
