module ApplicationHelper
  def flash_messages(opts = {})
    alert_type = { success: 'alert-success', notice: 'alert-success', error: 'alert-danger', warning: 'alert-warning', info: 'alert-info'}
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "text-center alert #{alert_type[msg_type.to_sym]} fade in") do
        concat content_tag(:button, '&times;'.html_safe, class: 'close', data: {dismiss: 'alert'})
        concat message
      end)
      flash.clear
    end
    nil
  end

end
