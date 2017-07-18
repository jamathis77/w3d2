DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT,
  lname TEXT
);
DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT,
  body TEXT,
  user_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id)
);
DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);
DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
  reply TEXT,
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  reply_id  INTEGER,
  user_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Chiam', 'Wilmowsky'),
  ('Johnny', 'Trouble');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('coding', 'what is coding', (SELECT id FROM users WHERE fname = 'Johnny'));

INSERT INTO
  question_follows(user_id, question_id)
VALUES  (
  (SELECT id FROM users WHERE fname = 'Johnny'),
  (SELECT id FROM questions WHERE title = 'coding')
);


INSERT INTO
  replies (reply, question_id, reply_id, user_id)
VALUES  (
 'Good Q!',
 (SELECT id FROM questions WHERE title = 'coding'),
 null,
 (SELECT id FROM users WHERE fname = 'Johnny')
);

INSERT INTO
  replies (reply, question_id, reply_id, user_id)
VALUES  (
 'Bad Q!',
 (SELECT id FROM questions WHERE title = 'coding'),
 (SELECT id FROM replies WHERE reply = 'Good Q!'),
 (SELECT id FROM users WHERE fname = 'Chiam')
);


INSERT INTO
  question_likes(user_id, question_id)
VALUES  (
  (SELECT id FROM users WHERE fname = 'Johnny'),
  (SELECT id FROM questions WHERE title = 'coding')
);
