String.class_eval do
  def to_class
    Object.const_get(self)
  end
end