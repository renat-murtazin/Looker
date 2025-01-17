view: inventory_items {
  sql_table_name: "PUBLIC"."INVENTORY_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
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

  dimension: product_brand {
    type: string
    sql: ${TABLE}."PRODUCT_BRAND" ;;
    link: {
      label: "Look on Google"
      url: "https://www.google.com/search?q={{ value }}"
    }
    link: {
      label: "Open facebook page"
      url: "https://facebook.com/search/top/?q={{ value }}"
    }
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}."PRODUCT_CATEGORY" ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}."PRODUCT_DEPARTMENT" ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}."PRODUCT_DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}."PRODUCT_NAME" ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}."PRODUCT_RETAIL_PRICE" ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}."PRODUCT_SKU" ;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}."SOLD_AT" ;;
  }

  # ----- Measures -----
  measure: count {
    type: count
    drill_fields: [id, product_name, products.name, products.id, order_items.count]
  }

  measure: total_cost {
    type: sum
    description: "Total cost of items sold from inventory"
    sql: ${cost} ;;
    value_format_name: usd
    drill_fields: [id, product_name, products.name, products.id, order_items.count]
  }

  measure: average_cost  {
    type: average
    description: "Average cost of items sold from inventory"
    sql: ${cost} ;;
    value_format_name: usd
    drill_fields: [id, product_name, products.name, products.id, order_items.count]
  }

  # ----- Sets for joins -----
  set: fileds_for_customers_explore {
    fields: [
      id,
      cost,
      product_brand,
      product_category,
      product_id,
      product_name,
      count,
      total_cost,
      average_cost
    ]
  }
}
