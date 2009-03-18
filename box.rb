%w[
  app/definitions
  app/maruku
  app/tasks
].each { |f| require File.join(File.dirname(__FILE__), f) }