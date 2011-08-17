class Page < ActiveRecord::Base
  validates :path, :length => { :in => 1 .. 100 }
  validates :title, :length => { :in => 1 .. 100 }
  validates :body, :length => { :in => 1 .. 10000 }
  validates :editor, :length => { :in => User::NAME_LENGTH }
  validates :editor, :format => { :with => User::NAME_FORMAT }
  validates :revision, :uniqueness => { :scope => :path }
  validates :revision, :numericality => { :only_integer => true, :greater_than => 0 }
  
  def self.find_latest_by_path(path)
    readonly.where(:path => path).order(:revision).last
  end
  
  def to_s
    "/#{path}"
  end
end
