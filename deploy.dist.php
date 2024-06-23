<?php
namespace Deployer;

require 'drupal10.deploy.php';

/**
 * Copy this file to 'deploy.php' and customize all settings marked by '#!'.
 */

// Config

set('repository', ''); #!
#set('bin/php', '/opt/plesk/php/8.1/bin/php');
#set('bin/composer', '/usr/bin/composer');

// Hosts

host('production')
  ->setHostname('') #!
  ->setPort(22)
  ->set('branch', 'main')
  ->set('http_user', '') #!
  ->set('remote_user', '') #!
  ->set('deploy_path', ''); #!

host('stage')
  ->setHostname('') #!
  ->setPort(22)
  ->set('branch', 'develop')
  ->set('http_user', '') #!
  ->set('remote_user', '') #!
  ->set('deploy_path', ''); #!
