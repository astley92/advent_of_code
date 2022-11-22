# Bundler and ruby gems
require("rubygems")
require("bundler/setup")
Bundler.require(:default)

# Zeitwerk
loader = Zeitwerk::Loader.new
loader.push_dir("lib")
loader.setup
