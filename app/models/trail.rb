class Trail < ActiveRecord::Base
  extend FriendlyId

  include PgSearch
  multisearchable against: [:name, :description], if: :published?

  validates :name, :description, :topic, presence: true

  belongs_to :topic
  has_many :repositories, dependent: :destroy
  has_many :statuses, as: :completeable, dependent: :destroy
  has_many :users, through: :statuses
  has_many \
    :steps,
    -> { order "steps.position ASC" },
    dependent: :destroy,
    inverse_of: :trail
  has_many :exercises,
    through: :steps,
    source: :completeable,
    source_type: "Exercise"
  has_many :videos, through: :steps, source: :completeable, source_type: "Video"

  friendly_id :name, use: [:slugged, :finders]

  def self.published
    where(published: true)
  end

  def self.by_topic
    includes(:topic).order("topics.name")
  end

  def self.completed_for(user)
    all.
      map { |trail| TrailWithProgress.new(trail, user: user) }.
      select(&:complete?)
  end

  def to_s
    name
  end

  # Override setters so it preserves the order
  def step_ids=(new_step_ids)
    super
    new_step_ids = new_step_ids.reject(&:blank?).map(&:to_i)

    new_step_ids.each_with_index do |step_id, index|
      steps.where(id: step_id).update_all(position: index + 1)
    end
  end

  def completeables
    steps.includes(:completeable).map(&:completeable)
  end

  def steps_remaining_for(user)
    CompleteableWithProgressQuery.
      new(user: user, completeables: completeables).
      count { |completeable| completeable.state != Status::COMPLETE }
  end

  def update_state_for(user)
    TrailWithProgress.new(self, user: user).update_status
  end

  def self.most_recent_published
    order(created_at: :desc).published
  end

  def teachers
    Teacher.joins(:video).merge(videos).to_a.uniq(&:user_id)
  end

  def included_in_plan?(plan)
    plan.has_feature?(:trails)
  end

  def topic_name
    topic.name
  end

  def first_completeable
    steps.order(:position).first.completeable
  end
end
