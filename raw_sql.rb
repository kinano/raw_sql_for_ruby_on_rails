module Helpers
    class RawSql
        def self.exec_prepared_statement(sql, query_params, name)
            """
            Runs a raw SQL query against the DB
            @param sql string
            @param query_params array
            @param name str
            @returns []
            """
            # Make sure the prepared statement does not exist
            statement_count_sql = "SELECT COUNT(1) FROM pg_prepared_statements WHERE name = #{ActiveRecord::Base.sanitize(name)}"
            statement_count_rs = ActiveRecord::Base.connection.execute(statement_count_sql).to_a.first

            connection = ActiveRecord::Base.connection.raw_connection
            if statement_count_rs["count"].to_i == 0 then
                connection.prepare(name, sql)
            end
            return connection.exec_prepared(name, query_params)
        end

        def self.convert_int_list_to_sql_list(list)
            # Converts a [] of ints to a postgres list e.g. {1, 2, 3}
            # @returns postgres []
            if list.blank? then
              return "{NULL}"
            end
            return "{#{list.join(",")}}"
        end

        def self.get_nextval_by_sequence(sequence_name)
            """
            @param sequence_name str
            @returns int
            """
            return ActiveRecord::Base.connection.execute(
                "select nextval('#{sequence_name}') AS result"
            ).to_a.first["result"].to_i
        end

    end
end