require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
          CREATE TABLE IF NOT EXISTS students
          (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
          SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id != nil
      self.update
    else
      sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?,?)
          SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = <<-SQL
          UPDATE students SET name = ?, genre = ? WHERE id = ?
          SQL
    DB[:conn].execute(sql, self.name, self.genre, self.id)
  end
end
