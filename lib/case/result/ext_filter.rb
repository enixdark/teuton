
# This is an extension of Result class
class Result
  # TODO: Error line 102 undefined include? method for 0 Fixnum...
  def find!(p_filter)
    case p_filter.class.to_s
    when 'Array'
      p_filter.each { |item| find!(item) }
      return self
    when 'String'
      @alterations << "find!(#{p_filter})"
      @content.select! { |i| i.include?(p_filter.to_s) }
    when 'Regexp'
      @alterations << "find!(#{p_filter})"
      temp = @content.clone
      @content = temp.grep p_filter
    end
    self
  end

  def not_find!(p_filter)
    @alterations << "grep_v!(#{p_filter})"
    return self if @content.size.zero?

    @content.reject! { |i| i.include?(p_filter) }
    self
  end

  def since!(p_filter)
    @alterations << "since!(#{p_filter})"
    return self if @content.size.zero?
    if p_filter.class == String
      flag = false
      @content.select! do |i|
        flag = true if i.include?(p_filter.to_s)
        flag
      end
    end
    self
  end

  def until!(p_filter)
    @alterations << "until!(#{p_filter})"
    return self if @content.size.zero?
    if p_filter.class == String
      flag = true
      @content.select! do |i|
        flag = false if i.include?(p_filter.to_s)
        flag
      end
    end
    self
  end

  alias grep!      find!
  alias grep_v!    not_find!
end
