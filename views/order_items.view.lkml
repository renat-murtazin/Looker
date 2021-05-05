view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  # ----- Custom dimensions -----
  dimension: is_returned {
    type: yesno
    description: "Calculates whether the order was returned or not"
    sql: not ${returned_date} is null;;
  }

  dimension_group: shipping_days {
    type: duration
    description: "Calculates the number of days between the order ship date and the order delivered date"
    intervals: [
      day
    ]
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date};;
  }

  dimension: is_completed {
    type:  yesno
    description: "flag for completed orders only"
    sql: UPPER(${status}) not in ('CANCELLED','RETURNED') ;;
  }

  # ----- Measures -----
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sales_price {
    type: sum
    description: "Total sales from items sold"
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_sales_price {
    type: average
    description: "Average sales from items sold"
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: cumulative_total_sales {
    type: running_total
    description: "Cumulative total sales from items sold (running total)"
    sql: ${total_sales_price} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: total_gross_revenue {
    type: sum
    description: "Total revenue from completed sales"
    sql: ${sale_price} ;;
    filters: [is_completed: "Yes"]
    value_format_name: usd
    drill_fields: [inventory_items.product_category, total_gross_revenue,gross_margin_percent]
  }

  measure: total_gross_margin  {
    label: "Total Gross Margin Amount"
    type: sum
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    sql: ${sale_price}-${inventory_items.cost} ;;
    filters: [is_completed: "Yes"]
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: average_gross_margin {
    type: average
    description: "Average Gross Margin  Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    sql: ${sale_price}-${inventory_items.cost} ;;
    filters: [is_completed: "Yes"]
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: gross_margin_percent {
    label: "Gross Margin %"
    type: number
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: ${total_gross_margin}/nullif(${total_gross_revenue},0) ;;
    value_format_name: percent_2
    drill_fields: [detail*]
  }

  measure: count_returned_items {
    label: "Number of Items Returned"
    type: count
    description: "Number of items that were returned by dissatisfied customers"
    filters: [is_returned: "Yes"]
    drill_fields: [detail*]
  }

  measure: item_returned_rate {
    label: "Returned items %"
    type: number
    description: "Number of Items Returned / total number of items sold"
    sql: ${count_returned_items}/nullif(${count},0) ;;
    value_format_name: percent_2
    drill_fields: [detail*]
  }

  measure: count_customres_with_returns {
    type: count_distinct
    description: "Number of users who have returned an item at some point"
    sql: ${user_id} ;;
    filters: [is_returned: "Yes"]
    drill_fields: [detail*]
  }

  measure: customers_with_returns_rate {
    label: "Customers with Returns %"
    type: number
    description: "Number of Customer Returning Items / total number of customers"
    sql: ${count_customres_with_returns}/nullif(${users.count},0) ;;
    value_format_name: percent_2
    drill_fields: [detail*]
  }

  measure: average_spend_per_customer {
    type: number
    description: "Total Sale Price / total number of customers"
    sql: ${total_sales_price}/nullif(${users.count},0) ;;
    value_format_name: usd
    drill_fields: [customer_groups*]
  }

  # ----- Sets of fields for drilling and joins ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.id,
      users.first_name
    ]
  }
  set: fields_for_customers_explore{
    fields: [
      id,
      inventory_item_id,
      order_id,
      sale_price,
      status,
      user_id,
      is_returned,
      is_completed,
      count,
      total_sales_price,
      average_sales_price,
      cumulative_total_sales,
      count_returned_items,
      item_returned_rate,
      count_customres_with_returns,
      customers_with_returns_rate,
      average_spend_per_customer
    ]
  }

  set: customer_groups  {
    fields: [
      users.age_tier,
      users.gender,
      average_spend_per_customer,
      total_gross_revenue,
      total_gross_margin
    ]
  }
}
