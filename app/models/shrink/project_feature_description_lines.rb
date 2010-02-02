module Shrink

  class ProjectFeatureDescriptionLines

    def initialize(project)
      @project = project
    end

    def find_similar_texts(text, limit)
      # TODO Script injection protection, find() approach?
      Shrink::FeatureDescriptionLine.find_by_sql(%{select distinct(fdl.text)
                                                   from #{Shrink::FeatureDescriptionLine.table_name} fdl
                                                   inner join #{Shrink::Feature.table_name} f ON (fdl.feature_id = f.id)
                                                   where f.project_id = #{@project.id}
                                                   and lower(fdl.text) like lower('#{text}%')
                                                   order by fdl.text asc
                                                   limit #{limit}} ).collect(&:text)
    end

  end

end
