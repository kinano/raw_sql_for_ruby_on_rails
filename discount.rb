class Discount < ActiveRecord::Base

  def self.get_all_by_user(user_id)
    """
    @param user_id int
    @returns [{}]
    """
      sql = "
        SELECT
            *
        FROM
            discounts d
        WHERE
          d.user_id = $1
      "

      return Helpers::RawSql.exec_prepared_statement(
        sql=sql,
        query_params=[user_id.to_i],
        name='get_user_discounts'
      )

    end