require File.expand_path("../lib/cucumber/ast/feature", __FILE__)
require File.expand_path("../lib/cucumber/ast/scenario", __FILE__)
require File.expand_path("../lib/cucumber/ast/tags", __FILE__)

::Cucumber::Ast::Feature.send(:include, ::Shrink::Cucumber::Ast::Feature)
::Cucumber::Ast::Scenario.send(:include, ::Shrink::Cucumber::Ast::Scenario)
::Cucumber::Ast::Tags.send(:include, ::Shrink::Cucumber::Ast::Tags)
