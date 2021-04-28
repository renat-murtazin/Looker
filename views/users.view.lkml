view: users {
  sql_table_name: "PUBLIC"."USERS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
    group_label: "General info"
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
    group_label: "Address"
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
    group_label: "Address"
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

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
    group_label: "General info"
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."GENDER" ;;
    group_label: "General info"
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
    group_label: "General info"
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
    group_label: "Address"
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
    group_label: "Address"
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
    group_label: "Address"
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
    group_label: "Address"
  }

  # ----- Custom dimensions ----
  dimension: full_name {
    type: string
    description: "Combines first name and last name of a user into a single field"
    sql: ${first_name} || ' ' || ${last_name} ;;
    group_label: "General info"
  }

  dimension: city_state {
    type: string
    description: "Combines City and State into a single Field"
    sql: %${city} || ', ' || ${state} ;;
    group_label: "Address"
  }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
    group_label: "Address"
  }

  dimension: age_tier {
    type: tier
    description: "Groups individual ages into the following age group"
    tiers: [18,25,35, 45, 55, 65, 75, 90]
    style: integer
    sql: ${age};;
    group_label: "General info"
  }

  # ----- Measures ------

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }

  # ------ Sets ------
  set: main_user_info {
    fields: [
      id,
      full_name,
      gender,
      age,
      age_tier,
      city,
      state,
      city_state,
      country,
      traffic_source,
      count
    ]
  }
}
