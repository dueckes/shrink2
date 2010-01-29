module Shrink

  class ProjectSteps

    def initialize(project)
      @project = project
    end

    def find_similar_texts(text, limit)
      # TODO Script injection protection, find() approach?
      Shrink::Step.find_by_sql(%{select distinct(text)
                                 from #{Shrink::Step.table_name} sp
                                 inner join #{Shrink::Scenario.table_name} so ON (sp.scenario_id = so.id)
                                 inner join #{Shrink::Feature.table_name} fe ON (so.feature_id = fe.id)
                                 where fe.project_id = #{@project.id}
                                 and lower(sp.text) like lower('#{text}%')
                                 order by text asc
                                 limit #{limit}} ).collect(&:text)
    end

  end

end
