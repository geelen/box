%w[
  app/definitions
  app/pandoc
  app/tasks
].each { |f| require File.join(File.dirname(__FILE__), f) }