class Promiscuous::Publisher::Transport::Persistence::ActiveRecord
  def save(batch)
    check_schema

    query = "INSERT INTO #{table} (batch) VALUES ('#{batch.dump}')"

    batch.id = connection.insert_sql(query, 'Promiscuous Recovery Save')
  end

  def expired
    check_schema

    query = "SELECT id, p.batch FROM #{table} p " \
            'WHERE at < CURRENT_TIMESTAMP - INTERVAL ' \
            "'#{Promiscuous::Config.recovery_timeout}' second"

    connection.exec_query(query, 'Promiscuous Recovery Expired').rows
  end

  def delete(batch)
    check_schema

    q = "DELETE FROM #{table} WHERE id = #{batch.id}"

    connection.exec_delete(q, 'Promiscuous Recovery Delete', [])
  end

  private

  def check_schema
    true
  end

  def connection
    ActiveRecord::Base.connection
  end

  def table
    Promiscuous::Config.transport_collection
  end
end
