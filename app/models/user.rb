class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :first_name, :last_name, :email, :phone, :password, :password_confirmation

  belongs_to :account
  has_many :incivents,  foreign_key: "raised_user_id", dependent: :destroy
  has_many :priorities, through: :incivents
  has_many :types, through: :incivents
  has_many :statuses, through: :incivents
  has_many :groups, through: :memberships
  has_many :memberships, dependent: :destroy
  has_many :tasks, foreign_key: "assigned_user_id", dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :invitations

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, presence: true,
                  length: { maximum: 50 }

  validates :last_name, presence: true,
                  length: { maximum: 50 }

  validates :email, presence: true,
                  format: { with: email_regex },
                  uniqueness: { case_sensitive: false }, on: :create
  validates :password, presence: true,
                  confirmation: true,
                  length: { within: 6..40 }, on: :create

  before_save :encrypt_password
  before_create { generate_token(:auth_token) }
  before_create :sanitize_phone

  def send_password_reset
    generate_token(:password_reset_token)
    password_reset_sent_at = Time.zone.now
    save
    Notification.password_reset(self).deliver rescue logger.error 'Unable to deliver the password reset email.'
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def sanitize_phone
    if phone.present?
      self[:phone] = self[:phone].gsub(/\D/, '')
    end
  end

  # Find out if a user has registered.
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.encrypted_password == BCrypt::Engine.hash_secret(password, user.salt)
      user
    end
  end

  # Returns a full name
  def full_name
    "#{first_name} #{last_name}"
  end

  # Call to find out if the current_user has joined a group, using model associations
  def member?(group)
    memberships.find_by_group_id(group)
  end

  # Call to find out if the current_user is the creator of a specific group.
  def creator?(group)
    id == group.creator_id
  end

  # Call to return all the main incivents in the groups for which current_user is a member
  def relevant_incivents(search)
    Incivent.unarchived.search(self, search)
  end

  # Call to return all the stories in the groups for which current_user is a member
  def relevant_stories
    Story.unarchived.stories_from_groups_joined_by(self)
  end

  # Call to return all the tasks in the groups for which current_user is a member
  def relevant_tasks
    Task.unarchived.tasks_from_groups_joined_by(self)
  end

  # Call to return all users in the groups for which current_user is a member
  def relevant_members
    group_ids = self.group_ids
    user_ids = Membership.select("user_id").where(group_id: group_ids).map(&:user_id).uniq
    User.find(user_ids)
  end

  # Call to return all the groups for which a user is a member
  def member_groups
    group_ids = self.group_ids
    Group.select("name").where(id: group_ids).map(&:name).join(", ")
  end

  private

  # Make a secure hash with the time, some characters and password and then again with the password,
  # then save this in the encrypted password field

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

end
