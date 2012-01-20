require 'digest/md5'

module ApplicationHelper
  def gravatar_url_for(email, options = {})
    options.reverse_merge!(:size => 40)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=#{options[:size]}"
  end
end
