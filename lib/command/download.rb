# frozen_string_literal: true

require 'rainbow'

# Class method Teuton#download
class Teuton < Thor
  map ['-dc', '--dc', '--download'] => 'download'
  desc 'download', 'Download Teuton challenges from git repo'
  long_desc <<-LONGDESC
  - Download Teuton challenges from git repo.

  - Same as:
    git clone https://github.com/teuton-software/teuton-challenges.git

  Example:

  #{$PROGRAM_NAME} download

  LONGDESC
  def download
    repo = 'teuton-challenges'
    puts "[INFO] Downloading <#{repo}> repo..."
    system("git clone https://github.com/teuton-software/#{repo}.git")
    puts "[INFO] Your files are into <#{Rainbow(repo).bright}> directory..."
  end
end
