module Shrink
  module ActiveRecord

    module OptionManipulation

      def merge_options_including_conditions(options, other_options)
        combined_conditions = if options[:conditions] && other_options[:conditions]
          merge_conditions_including_values(options[:conditions], other_options[:conditions])
        else
          options[:conditions] || other_options[:conditions]
        end
        conditions_options = combined_conditions ? { :conditions => combined_conditions } : {}
        other_options.merge(options).merge(conditions_options)
      end

      def merge_conditions_including_values(conditions, other_conditions)
        (conditions[1..-1] + other_conditions[1..-1]).unshift("#{conditions[0]} and (#{other_conditions[0]})")
      end

    end

  end
end
