#!/usr/bin/env php

<?php

$config_file="/var/www/html/config/config.ini.php";

if(!file_exists($config_file))
{
  echo "Could not Open piwik config file located in \"$config_file\" \n Please perform a Piwik Installation First.";
  exit(-1);
}

$config=parse_ini_file($config_file);

// Load Config for Database backup
$db_host=$config['host'];
$db_user=$config['username'];
$db_pass=$config['password'];
$db_name=$config['dbname'];

$tmp_dir='/var/backup/piwik';

if(!file_exists($tmp_dir))
{
	mkdir($tmp_dir);
}

$dump_file=$tmp_dir.'/dump.sql';
exec("mysqldump --host=$db_host --user=$db_user -p$db_pass $db_name > $dump_file");

if(!file_exists($config_file))
{
  echo "Could not backup database";
  exit(-1);
}


?>
