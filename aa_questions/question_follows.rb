require_relative 'questions_database'
require_relative 'user.rb'

class QuestionFollows
attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map {|datum| QuestionFollows.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT
         *
       FROM
         replies
       WHERE
        id = ?
    SQL
      return nil if question_follow.empty?
      Replies.new(question_follow.first)
  end

  def self.followers_for_question_id(question_id)
    followers_of_question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
         users.*
        FROM
         question_follows
        JOIN users
         ON users.id = question_follows.user_id
        WHERE
          question_id = ?

    SQL
      return nil if followers_of_question.empty?
      followers_of_question.map {|datum| Users.new(datum)}
  end

end
