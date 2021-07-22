class User < ApplicationRecord
  has_secure_password
  has_many :orders, dependent: :delete_all
  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :address, presence: true, length: { maximum: 1000 }
  validates :phone, uniqueness: true, presence: true, length: { is: 10 }

  def self.owners
    order(:id).where(role: "owner")
  end

  def self.clerks
    order(:id).where(role: "clerk")
  end

  def self.customers
    order(:id).where(role: "customer")
  end

  def self.category(role)
    if role == "owner"
      owners
    elsif role == "clerk"
      clerks
    else
      customers
    end
  end

  def orderBelongsToCurrentUser?(order)
    orders.include?(order)
  end
end
