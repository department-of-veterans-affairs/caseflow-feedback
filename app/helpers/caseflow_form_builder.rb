class CaseflowFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, options = {})
    options["aria-disabled"] = true if options[:readonly]

    wrapped_text_field(attribute, options, super(attribute, trim_options(options)))
  end

  def text_area(attribute, options = {})
    options[:rows] = 6
    options["aria-disabled"] = true if options[:readonly]

    @template.content_tag :div, id: question_id(options),
                                class: "cf-form-textarea" do
      question_label(attribute, options) + error_container + super(attribute, trim_options(options))
    end
  end

  private

  def question_id(options)
    "question#{options[:question_number]}#{options[:part]}#{options[:question_name]}"
  end

  def wrapped_text_field(attribute, options, input)
    readonly_class = options[:readonly] ? "cf-form-disabled" : ""

    @template.content_tag :div, id: question_id(options),
                                class: "cf-form-textinput #{readonly_class}" do
      question_label(attribute, options) + error_container + input
    end
  end

  def question_label(attribute, options)
    label(attribute, label_content(options), class: "question-label")
  end

  def label_content(options)
    "<strong>#{options[:question_number]}</strong> #{options[:label]}".html_safe
  end

  def trim_options(options)
    options.except(:question_number, :label, :secondary, :part, :question_name)
  end

  def error_container
    @template.content_tag(:span, class: "usa-input-error-message") {}
  end
end
