view: distribution_centers {
  sql_table_name: "PUBLIC"."DISTRIBUTION_CENTERS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
    hidden: yes
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
    hidden: yes
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  # ----- Custom Dimensions -----
  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, products.count]
  }
}
