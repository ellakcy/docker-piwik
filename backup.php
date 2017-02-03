#!/usr/bin/env php

<?php

$config_file="/var/www/html/config/config.ini.php";
$plugins_dir="/var/www/html/plugins";

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

$backup_dir='/var/backup/piwik';

if(!file_exists($backup_dir))
{
	mkdir($backup_dir);
}

print "Backing Up database\n";
$dump_file=$backup_dir.'/dump.sql';
exec("mysqldump --host=$db_host --user=$db_user -p$db_pass $db_name > $dump_file");

if(!file_exists($config_file))
{
  echo "Could not backup database";
  exit(-1);
}

print "Backing Up config\n";
exec("cp $config_file $backup_dir/");

print "Backing up plugins\n";
exec("cp -R $plugins_dir $backup_dir/");

print "Exporting as tarball\n";
exec("tar -czf $backup_dir/../".gmdate('Y-m-d,H_i_s').".tar.gz $backup_dir/*");
?>
