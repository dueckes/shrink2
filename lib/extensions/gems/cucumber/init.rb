require File.expand_path(File.dirname(__FILE__) + "/lib/cucumber/ast/feature")
require File.expand_path(File.dirname(__FILE__) + "/lib/cucumber/ast/scneario")

::Cucumber::Ast::Feature.send(:include, ::Shrink::Cucumber::Ast::Feature)
::Cucumber::Ast::Scenario.send(:include, ::Shrink::Cucumber::Ast::Scenario)
