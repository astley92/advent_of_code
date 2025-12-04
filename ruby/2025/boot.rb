require("bundler")
Bundler.require(:default)

loader = Zeitwerk::Loader.new
loader.push_dir("lib")
loader.setup 
