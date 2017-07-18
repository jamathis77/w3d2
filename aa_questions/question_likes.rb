require_relative 'questions_database'

class QuestionLikes
attr_accessor :user_id, :question_id
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map {|datum| QuestionLikes.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    question_likes = QuestionsDatabase.instance.execute(<<-SQL, id)
       SELECT
         *
       FROM
         replies
       WHERE
        id = ?
    SQL
    return nil if question_likes.empty?
    Replies.new(question_likes.first)
  end


end
