module Rake

  module TaskManager

    def redefine_task(task_class, *args, &block)
      task_name, deps = resolve_args(args)
      task_name = task_class.scope_name(@scope, task_name)
      deps = [deps] unless deps.respond_to?(:to_ary)
      deps = deps.collect {|d| d.to_s }
      task = @tasks[task_name.to_s] = task_class.new(task_name, self)
      task.application = self
      task.comment = @last_comment
      @last_comment = nil
      task.enhance(deps, &block)
      task
    end

  end

  class Task

    def self.redefine_task(args, &block)
      Rake.application.redefine_task(self, args, &block)
    end

  end

end

def redefine_task(args, &block)
  Rake::Task.redefine_task(args, &block)
end