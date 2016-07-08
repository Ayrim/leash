module MessagingHelper
	def IsLastMessageRead(user_1_id, user_2_id)
		id = Message.order(created_at: :desc).where("(from_user_id = ? AND to_user_id = ?)", user_2_id, user_1_id).limit(1).pluck(:id)
		if !(defined?(id)).nil?
			if !Message.find_by(id: id).nil?
				return Message.find_by(id: id).is_read;
			end
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

	def HasUnreadMessages()
		return Message.where(is_read:false).where("(to_user_id = ?)", current_user.id).count
	end
end
