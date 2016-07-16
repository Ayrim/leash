module MessagingHelper
	def IsLastMessageRead(user_1_id, user_2_id)
		if(Message.where(is_read:false).where("(from_user_id = ? AND to_user_id = ?)", user_2_id, user_1_id).count) > 0
			return false
		else
			return true
		end
	end

	def GetLastMessageContent(user_1_id, user_2_id)
		id = Message.order(created_at: :desc).where("(from_user_id = ? AND to_user_id = ?) OR (from_user_id = ? AND to_user_id = ?)", user_1_id, user_2_id, user_2_id, user_1_id).limit(1).pluck(:id)
		if !(defined?(id)).nil?
			if !Message.find_by(id: id).nil?
				return Message.find_by(id: id).content
			end
		end
	end

	def GetLastMessageNotification()
		lastMessageId = Message.where(is_read:false).where("to_user_id = ?", current_user.id).order(created_at: :desc).limit(1).pluck(:id)
		if !(defined?(lastMessageId)).nil?
			if !Message.find_by(id: lastMessageId).nil?
				#Retrieve name of the user sending you a message
				username = User.find_by(:id => Message.find_by(id: lastMessageId).from_user_id).firstname
				return username + " has sent you a new message."
			end
		end
	end

	def GetLastMessageNotificationFromUserId()
		lastMessageId = Message.where(is_read:false).where("to_user_id = ?", current_user.id).where("created_at > (now() at time zone 'utc') - INTERVAL '30 seconds'").order(created_at: :desc).limit(1).pluck(:id)
		if !(defined?(lastMessageId)).nil?
			if !Message.find_by(id: lastMessageId).nil?
				#Retrieve name of the user sending you a message
				return Message.find_by(id: lastMessageId).from_user_id;
			end
		end
	end

	def HasUnreadMessages()
		return Message.where(is_read:false).where("(to_user_id = ?)", current_user.id).count
	end

	def HasUnreadMessagesWithinTimespan()
		return Message.where(is_read:false).where("(to_user_id = ?)", current_user.id).where("created_at > (now() at time zone 'utc') - INTERVAL '30 seconds'").count
	end
end
