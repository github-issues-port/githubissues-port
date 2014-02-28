  class Array
    def filter_by_category cat
      self.select{|i| i.category.eql? cat}
    end
  end