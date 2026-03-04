class Todo
  attr_reader :id, :title, :completed, :created_at

  def initialize(row)
    @id        = row["id"].to_i
    @title     = row["title"]
    @completed = row["completed"] == "t"
    @created_at = row["created_at"]
  end

  def self.all
    DB.exec("SELECT * FROM todos ORDER BY completed ASC, position ASC, created_at ASC").map { |row| new(row) }
  end

  def self.create(title)
    DB.exec_params(
      "INSERT INTO todos (title, position) VALUES ($1, (SELECT COALESCE(MAX(position) + 1, 0) FROM todos))",
      [title]
    )
  end

  def self.toggle(id)
    DB.exec_params(
      "UPDATE todos SET completed = NOT completed WHERE id = $1",
      [id]
    )
  end

  def self.delete(id)
    DB.exec_params("DELETE FROM todos WHERE id = $1", [id])
  end

  def self.reorder(ids)
    ids.each_with_index do |id, index|
      DB.exec_params("UPDATE todos SET position = $1 WHERE id = $2", [index, id])
    end
  end
end
