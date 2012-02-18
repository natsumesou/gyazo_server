require 'digest/md5'

class Image
  require 'filemagic'
  IMAGE_DIR = Padrino.root('public')

  attr_reader :filename, :path

  def initialize(tempfile)
    @tempfile = tempfile
    @mime = FileMagic.new.file(@tempfile.path)
  end

  def save
    if isPng?
      @filename = "#{hash}.png"
      @path = File.join(IMAGE_DIR, @filename)
      FileUtils.copy(@tempfile, @path)
      FileUtils.chmod(0664 ,@path)
      true
    else
      false
    end
  end

  def delete
    File.delete(File.join(IMAGE_DIR, @filename))
  end

  private
  def isImage?
    if @mime.include?('image')
      true
    else
      false
    end
  end

  def isPng?
    if isImage? && @mime.include?('PNG')
      true
    else
      false
    end
  end

  def hash
    Digest::MD5.hexdigest(@tempfile.read)
  end
end
