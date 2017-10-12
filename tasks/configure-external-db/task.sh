#!/bin/bash

set -eu




cf_properties=$(
  jq -n \
      --arg system_database "$SYSTEM_DATABASE" \
      --arg external_mysql_host "$EXTERNAL_MYSQL_HOST" \
      --arg external_mysql_port "$EXTERNAL_MYSQL_PORT" \
      --arg external_mysql_account_username "$EXTERNAL_MYSQL_ACCOUNT_USERNAME" \
      --arg external_mysql_account_password "$EXTERNAL_MYSQL_ACCOUNT_PASSWORD" \
      --arg external_mysql_app_usage_service_username "$EXTERNAL_MYSQL_APP_USAGE_SERVICE_USERNAME" \
      --arg external_mysql_app_usage_service_password "$EXTERNAL_MYSQL_APP_USAGE_SERVICE_PASSWORD" \
      --arg external_mysql_autoscale_username "$EXTERNAL_MYSQL_AUTOSCALE_USERNAME" \
      --arg external_mysql_autoscale_password "$EXTERNAL_MYSQL_AUTOSCALE_PASSWORD" \
      --arg external_mysql_ccdb_username "$EXTERNAL_MYSQL_CCDB_USERNAME" \
      --arg external_mysql_ccdb_password "$EXTERNAL_MYSQL_CCDB_PASSWORD" \
      --arg external_mysql_diego_username "$EXTERNAL_MYSQL_DIEGO_USERNAME" \
      --arg external_mysql_diego_password "$EXTERNAL_MYSQL_DIEGO_PASSWORD" \
      --arg external_mysql_locket_username "$EXTERNAL_MYSQL_LOCKET_USERNAME" \
      --arg external_mysql_locket_password "$EXTERNAL_MYSQL_LOCKET_PASSWORD" \
      --arg external_mysql_networkpolicyserver_username "$EXTERNAL_MYSQL_NETWORKPOLICYSERVER_USERNAME" \
      --arg external_mysql_networkpolicyserver_password "$EXTERNAL_MYSQL_NETWORKPOLICYSERVER_PASSWORD" \
      --arg external_mysql_nfsvolume_username "$EXTERNAL_MYSQL_NFSVOLUME_USERNAME" \
      --arg external_mysql_nfsvolume_password "$EXTERNAL_MYSQL_NFSVOLUME_PASSWORD" \
      --arg external_mysql_notifications_username "$EXTERNAL_MYSQL_NOTIFICATIONS_USERNAME" \
      --arg external_mysql_notifications_password "$EXTERNAL_MYSQL_NOTIFICATIONS_PASSWORD" \
      --arg external_mysql_routing_username "$EXTERNAL_MYSQL_ROUTING_USERNAME" \
      --arg external_mysql_routing_password "$EXTERNAL_MYSQL_ROUTING_PASSWORD" \
      --arg external_mysql_silk_username "$EXTERNAL_MYSQL_SILK_USERNAME" \
      --arg external_mysql_silk_password "$EXTERNAL_MYSQL_SILK_PASSWORD" \
      --arg uaa_database "$UAA_DATABASE" \
      --arg uaa_database_host "$UAA_DATABASE_HOST" \
      --arg uaa_database_port "$UAA_DATABASE_PORT" \
      --arg uaa_database_username "$UAA_DATABASE_USERNAME" \
      --arg uaa_database_password "$UAA_DATABASE_PASSWORD" \
    '
    {

    ".properties.system_database":{"value":$system_database}
    }
    +
    if $system_database == "external" then
    {
      ".properties.system_database.external.host":{"value":$external_mysql_host},
      ".properties.system_database.external.port":{"value":$external_mysql_port},
      ".properties.system_database.external.account_username":{"value":$external_mysql_account_username},
      ".properties.system_database.external.account_password":{"value":{"secret":$external_mysql_account_password}},
      ".properties.system_database.external.app_usage_service_username":{"value":$external_mysql_app_usage_service_username},
      ".properties.system_database.external.app_usage_service_password":{"value":{"secret":$external_mysql_app_usage_service_password}},
      ".properties.system_database.external.autoscale_username":{"value":$external_mysql_autoscale_username},
      ".properties.system_database.external.autoscale_password":{"value":{"secret":$external_mysql_autoscale_password}},
      ".properties.system_database.external.ccdb_username":{"value":$external_mysql_ccdb_username},
      ".properties.system_database.external.ccdb_password":{"value":{"secret":$external_mysql_ccdb_password}},
      ".properties.system_database.external.diego_username":{"value":$external_mysql_diego_username},
      ".properties.system_database.external.diego_password":{"value":{"secret":$external_mysql_diego_password}},
      ".properties.system_database.external.locket_username":{"value":$external_mysql_locket_username},
      ".properties.system_database.external.locket_password":{"value":{"secret":$external_mysql_locket_password}},
      ".properties.system_database.external.networkpolicyserver_username":{"value":$external_mysql_networkpolicyserver_username},
      ".properties.system_database.external.networkpolicyserver_password":{"value":{"secret":$external_mysql_networkpolicyserver_password}},
      ".properties.system_database.external.nfsvolume_username":{"value":$external_mysql_nfsvolume_username},
      ".properties.system_database.external.nfsvolume_password":{"value":{"secret":$external_mysql_nfsvolume_password}},
      ".properties.system_database.external.notifications_username":{"value":$external_mysql_notifications_username},
      ".properties.system_database.external.notifications_password":{"value":{"secret":$external_mysql_notifications_password}},
      ".properties.system_database.external.routing_username":{"value":$external_mysql_routing_username},
      ".properties.system_database.external.routing_password":{"value":{"secret":$external_mysql_routing_password}},
      ".properties.system_database.external.silk_username":{"value":$external_mysql_silk_username},
      ".properties.system_database.external.silk_password":{"value":{"secret":$external_mysql_silk_password}}
    }
    else .
    end
    +
    {
      ".properties.uaa_database":{"value":$uaa_database}
    }
    +
    if $uaa_database == "external" then
    {
      ".properties.uaa_database.external.host":{"value":$uaa_database_host},
      ".properties.uaa_database.external.port":{"value":$uaa_database_port},
      ".properties.uaa_database.external.uaa_username":{"value":$uaa_database_username},
      ".properties.uaa_database.external.uaa_password":{"value":{"secret":$uaa_database_password}}
    }
    else .
    end
    '
)

om-linux \
  --target https://$OPSMAN_DOMAIN_OR_IP_ADDRESS \
  --username $OPS_MGR_USR \
  --password $OPS_MGR_PWD \
  --skip-ssl-validation \
  configure-product \
  --product-name cf \
  --product-properties "$cf_properties"
