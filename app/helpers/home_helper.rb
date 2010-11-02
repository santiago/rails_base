module HomeHelper
  def remove_public_from_path(path)
    path = path.gsub('public', '')
    path
  end
end
