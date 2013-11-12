Rake::TaskManager.class_eval do
  def alias_task(new_name, old_name)
    @tasks[new_name] = @tasks[old_name]
  end
end

def alias_task(*args)
  Rake.application.alias_task(*args)
end

