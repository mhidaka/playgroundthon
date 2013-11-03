<?php
require_once("ShingekiAPIBaseClass2.php");
$err_msg = "";

class ShingekiAPI_Room extends ShingekiAPIBaseClass2 {
	protected $room_dir = "/tmp/shingeki/room";
	
	public function execute() {
		$file_path = $this->room_dir."/0";
		$fp = fopen($file_path, "w");
		if ($fp) {
			fwrite($fp, "owner"."\t"."hoge"."\n");
			fwrite($fp, "user"."\t"."fuga"."\n");
			fclose($fp);
		} else {
			die("fopen err");
		}
	}
}

$shingekiAPI_Room = new ShingekiAPI_Room();
$shingekiAPI_Room->execute();