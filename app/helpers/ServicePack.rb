module SP
  def expired?
    Date.today > expiration_date
  end
  def used_up?
    capacity <= used
  end
  def usable?
    expired? || used_up?
  end
  def how_many_unit_used
    #todo: flesh this out
    ActiveRecord::Base.connection_pool.with_connection {
      |con| con.exec_query("")
    }
  end
end