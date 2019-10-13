# frozen_string_literal: true

# DSL#missing_method
module DSL
  # If a method call is missing, then delegate to concept parent.
  def method_missing(method, args = {})
    a = method.to_s
    return instance_eval("get(:#{a[0, a.size - 1]})") if a[a.size - 1] == '?'
    call a[5, a.size], args if a[0,5]=='call_'
  end
end