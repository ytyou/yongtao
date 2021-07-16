<?php

class MySQLController extends CController
{
    public function actionQuery()
    {
        $connstr = 'mysql:host=localhost;dbname=yii';
        $username = 'root';
        $password = 'Podbean_123';

        $conn = new CDbConnection($connstr, $username, $password);
        $conn->active = true;  // connect
        $rows = $conn->createCommand("SELECT * FROM t1")->QueryAll();
        $conn->active = false; // disconnect

        if (empty($rows))
        {
            return $this->render("/another", ['title' => 'T1', 'message' => 'Empty']);
        }
        else
        {
            echo '<pre>';
            var_dump($rows);
            echo '</pre>';
        }
    }
}
