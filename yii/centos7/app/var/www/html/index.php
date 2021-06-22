<?php

define(YII_DEBUG) or define('YII_DEBUG',true);
require_once('/var/www/cgi-bin/yii/framework/yii.php');
$config = '/var/www/config/main.php';
Yii::createWebApplication($config)->run();
