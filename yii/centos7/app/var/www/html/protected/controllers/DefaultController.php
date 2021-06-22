<?php

// To access these actions, point your browser to
//   http://localhost/index.php?r=default/vardump
//   http://localhost/index.php?r=default/helloworld

class DefaultController extends CController
{
    public function actionVarDump()
    {
        $request = Yii::app()->request;
        echo '<pre>';
        echo '$request = ';
        var_dump($request);
        echo '<br>$_SERVER = ';
        var_dump($_SERVER);
        echo '</pre>';
    }

    public function actionHelloWorld()
    {
        // Render in /var/www/html/protected/views/another.php
        return $this->render("/another", ['title' => 'This is the Title', 'message' => 'Hello, World!']);
    }
}
