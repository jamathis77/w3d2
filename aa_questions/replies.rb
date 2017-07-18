require 'byebug'
require_relative 'questions_database'

class Replies
attr_accessor :id, :user_id, :question_id, :reply, :reply_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map {|datum| Replies.new(datum)}
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT
         *
       FROM
         replies
       WHERE
        id = ?
    SQL
      return nil if reply.empty?
      Replies.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
      return nil if reply.empty?
      Replies.new(reply.first)
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
      return nil if reply.empty?
      reply.map {|datum| Replies.new(datum)}
  end


  def initialize(options)
    @reply = options['reply']
    @id = options['id']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @user_id = options['user_id']
  end

  def user
    Users.find_by_id(@user_id)
  end

  def question
    Questions.find_by_id(@question_id)
  end

  def parent_reply
    Replies.find_by_id(self.reply_id)
  end

  def child_replies
    # debugger
     parent_id = self.id
    children = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL
      return nil if children.empty?
      children.map {|datum| Replies.new(datum)}
  end
end
