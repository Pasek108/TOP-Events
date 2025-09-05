module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :success then "bg-green-700"
    when :notice then "bg-blue-700"
    when :alert  then "bg-red-700"
    when :error then "bg-red-700"
    end
  end

  def flash_icon(type)
    case type.to_sym
    when :success then '<i class="fa-solid fa-circle-check"></i>'.html_safe
    when :notice then '<i class="fa-solid fa-circle-info"></i>'.html_safe
    when :alert then '<i class="fa-solid fa-circle-xmark"></i>'.html_safe
    when :error then '<i class="fa-solid fa-circle-xmark"></i>'.html_safe
    end
  end
end
