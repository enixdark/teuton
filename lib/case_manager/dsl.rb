require_relative '../application'
require_relative 'case_manager'

def use(filename)
  filename += '.rb'
  app = Application.instance
  rbfiles = File.join(app.project_path, "**", filename)
  files = Dir.glob(rbfiles)
  use = []
  files.sort.each { |f| use << f if f.include?(filename) }
  require_relative use[0]
end

def group(name, &block)
  Application.instance.groups << { name: name, block: block }
end
alias task group

def play(&block)
  CaseManager.instance.play(&block)
end
alias start play
