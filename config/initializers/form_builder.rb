
module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    

    def initialize(object_name, object, template, options, block)
      @layout = options[:layout]
      @label_col = options[:label_col] || default_label_col
      @control_col = options[:control_col] || default_control_col
      @inline_errors = options[:inline_errors] != false
      @acts_like_form_tag = options[:acts_like_form_tag]

      super
    end
  end
end