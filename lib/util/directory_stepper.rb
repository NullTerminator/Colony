class DirectoryStepper
  attr_reader :entries, :display, :parent, :path
  alias :to_s :display

  def initialize(path, parent=nil)
    @parent = parent
    @path = path
    @display = path.match(/[^\/]+$/)[0]
    @entries = dir? ? Dir.entries(path).reject {|d| d.start_with?(".") }.map { |p| DirectoryStepper.new("#{path}/#{p}", self) }.sort_by { |i| i.file? ? 1 : 0 } : []
  end

  def file
    file? ? File.new(path) : nil
  end

  def files
    entries.select(&:file?)
  end

  def directories
    entries.select(&:dir?)
  end
  alias :dirs :directories

  def file?
    File.file?(path)
  end

  def directory?
    !File.file?(path)
  end
  alias :dir? :directory?

  def depth
    return 0 unless parent
    return parent.depth + 1
  end

  def print
    str = ""
    str += "#{path}\n" unless parent
    entries.each do |entry|
      str += "#{"  " * depth}#{entry.display}\n"
      str += "#{entry.print}" if entry.dir?
    end
    return str
  end
end
