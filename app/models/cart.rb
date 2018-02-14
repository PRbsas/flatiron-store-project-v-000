class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :line_items
  has_many :items, through: :line_items
  has_many :orders

  def total
    self.line_items.inject(0) { |sum, line_item| sum + line_item.total }
  end

  def add_item(item_id)
    line_item = self.line_items.find_by(item_id: item_id)
    if line_item
      line_item.quantity += 1
    else
      line_item = self.line_items.build(item_id: item_id)
    end

    line_item
  end

  def checkout
    update(status: 'submitted')
    update_inventory
    user.remove_cart
  end

  private
  def update_inventory
    if self.status == 'submitted'
      self.line_items.each do |line_item|
        line_item.item.inventory -= line_item.quantity
        line_item.item.save
      end
    end
  end
end
