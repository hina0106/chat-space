class Message < ApplicationRecord
  belongs_to :group
  belongs_to :user

  # bodyカラムが空の場合は保存しない、imageカラムが空だったら。
  validates :body, presence: true, unless: :image?
  
  mount_uploader :image, ImageUploader
end
