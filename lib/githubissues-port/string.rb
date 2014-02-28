class String
  def category
    if (self =~ /type*/) or (%w(bug duplicate enhancement invalid question wontfix patch).include? self)
      'type'
    elsif (self =~ /priority*/) or (%w(high medium low critical).include? self)
      'priority'
    elsif self =~ /module*/
      'module'
    elsif self =~ /status*/
      'status'
    else
      'module'
    end
  end
end