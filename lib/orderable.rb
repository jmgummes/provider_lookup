module Orderable
  def move_to_top!
    return if self.class.count <= 1
    update(order: ((self.class.minimum(:order) || 1) - 1))
  end
end
