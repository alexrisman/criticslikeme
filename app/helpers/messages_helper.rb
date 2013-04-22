module MessagesHelper
  def any_unread?(messages)
    messages.each do |m| 
      if m.recipient == current_user && m.is_read == false
        return true
      end
    end
    return false;
  end
  
end
