class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :carts
  has_many :orders
  belongs_to :current_cart, class_name: 'Cart', foreign_key: 'current_cart_id'

  def create_current_cart
    cart = self.carts.create
    self.current_cart_id = cart.id
    save
  end

  def remove_cart
    self.current_cart_id = nil
    save
  end
end
