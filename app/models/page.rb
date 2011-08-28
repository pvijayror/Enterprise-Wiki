class Page < ActiveRecord::Base
  belongs_to :editor, :class_name => "User", :foreign_key => "editor_id"
  belongs_to :markup
  belongs_to :theme

  validates :path,  :length => { :in => 1 .. 100 }
  validates :title, :length => { :in => 1 .. 100 }
  validates :body,  :length => { :in => 1 .. 100000 }
  validates :editor_id, :presence => true
  validates :markup_id, :presence => true
  validates :revision, :uniqueness => { :scope => :path }
  validates :revision, :numericality => { :only_integer => true, :greater_than => 0 }
  
  def self.find_latest_by_path (path)
    readonly.where(:path => path).order(:revision).last
  end
  
  def self.get_history (path)
    readonly.where(:path => path).order("revision DESC").all
  end
  
  def to_s
    "/#{path}"
  end
  
  def path
    self[:path].to_s.strip.downcase
  end
  
  def plain?
    markup and markup.is? :plain_text
  end
  
  def file?
    markup and markup.is? :uploaded_file
  end
  
  def file_size
    File.new(body).size
  end
  
  def content_length
    if file?
      file_size
    else
      body.length
    end
  end
  
  def has_history?
    if revision
      if new_record? and revision == 1
        false
      else
        true
      end
    else
      false
    end
  end
  
  def has_content?
    has_history? and not file?
  end
end