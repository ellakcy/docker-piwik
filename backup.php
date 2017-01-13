#!/usr/bin/env php

<?php

$config_file="/var/www/html/config/config.ini.php";

if(!file_exists($config_file))
{
  echo "Could not Open piwik config file located in \"$config_file\"";
  exit(-1);
}

$config=parse_ini_file($config_file);

var_dump($config);

?>
