module SettingsHelper

  def setting_select(setting, choices, options={})
    if blank_text = options.delete(:blank)
      choices = [[blank_text.is_a?(Symbol) ? l(blank_text) : blank_text, '']] + choices
    end
    setting_label(setting, options) +
      select_tag("settings[#{setting}]", options_for_select(choices, Setting.send(setting).to_s), options)
  end

  def setting_multiselect(setting, choices, options={})
    setting_values = Setting.send(setting)
    setting_values = [] unless setting_values.is_a?(Array)

    setting_label(setting, options) +
      hidden_field_tag("settings[#{setting}][]", '') +
      choices.collect do |choice|
        text, value = (choice.is_a?(Array) ? choice : [choice, choice])
        content_tag('label',
          check_box_tag("settings[#{setting}][]", value, Setting.send(setting).include?(value)) + text.to_s,
          :class => 'block'
        )
      end.join
  end

  def setting_date_select(setting, options={})
    options['default'] = Setting.send(setting).to_date
    setting_label(setting, options) + '<br />' +
    date_select("date_settings", setting, :default => Setting.send(setting).to_date)
  end

  def setting_datetime_select(setting, options={})
    setting_label(setting, options) + '<br />' +
      datetime_select("datetime_settings", setting, :default => Setting.send(setting).to_datetime)
  end

  def setting_text_field(setting, options={})
    options['size'] = 43
    setting_label(setting, options) + '<br />' +
      text_field_tag("settings[#{setting}]", Setting.send(setting), options)
  end

  def setting_text_area(setting, options={})
    setting_label(setting, options) + '<br />' +
      text_area_tag("settings[#{setting}]", Setting.send(setting), options)
  end

  def setting_check_box(setting, options={})
    setting_label(setting, options) + '<br />' +
      hidden_field_tag("settings[#{setting}]", 0) +
      check_box_tag("settings[#{setting}]", 1, Setting.send("#{setting}?"), options)
  end

  def setting_label(setting, options={})
    label = options.delete(:label)
    label != false ? content_tag("label", (label || "#{setting.to_s.titleize}")) : ''
  end

end
