require_relative 'questions_database'
require_relative 'questions'

class Users
  attr_accessor :fname, :lname, :user_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| Users.new( datum) }
  end

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
     SELECT
       *
     FROM
       users
     WHERE
       id = ?
   SQL
   return nil unless user.length > 0

   Users.new(user.first) # play is stored in an array!
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
     SELECT
       *
     FROM
       users
     WHERE
       fname = ? OR lname = ?
   SQL
   return nil unless user.length > 0

   Users.new(user.first) # play is stored in an array!

  end

  def initialize(options)
   @id = options['id']
   @fname = options['fname']
   @lname = options['lname']
 end

 def user_questions
    Questions.find_by_user_id(@id)
 end

 def user_replies
   Replies.find_by_user_id(@id)
 end

end
