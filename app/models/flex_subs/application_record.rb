module FlexSubs
  class ApplicationRecord < FlexSubs.model_parent_class.constantize
    self.abstract_class = true
    self.table_name_prefix = 'flex_subs_'
  end
end