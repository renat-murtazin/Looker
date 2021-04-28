view: events {
  sql_table_name: "PUBLIC"."EVENTS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}."BROWSER" ;;
    group_label: "System info"
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

  dimension: event_type {
    type: string
    sql: ${TABLE}."EVENT_TYPE" ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}."IP_ADDRESS" ;;
    group_label: "System info"
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

  dimension: os {
    type: string
    sql: ${TABLE}."OS" ;;
    group_label: "System info"
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}."SEQUENCE_NUMBER" ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}."SESSION_ID" ;;
    group_label: "System info"
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
    group_label: "Address"
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
    group_label: "System info"
  }

  dimension: uri {
    type: string
    sql: ${TABLE}."URI" ;;
    group_label: "System info"
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
    group_label: "Address"
  }

   # ----- Custom dimensions -----
  dimension: city_state {
    type: string
    description: "Combines City and State into a single Field"
    sql: ${city} || ', ' || ${state} ;;
    group_label: "Address"
  }

  dimension: location {
    type: location
    description: "latidute and longitude of the event"
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
    group_label: "Address"
  }

  # ----- Measures -----
  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.id, users.first_name]
  }
}
