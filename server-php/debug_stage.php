<?php
require_once("ShingekiAPIBaseClass.php");
$err_msg = "";

class ShingekiAPI_Stage extends ShingekiAPIBaseClass {
	protected $shingeki_dir = "/tmp/shingeki";
	protected $stage_dir = "/tmp/shingeki/stage/";
	protected $stageData ;
	function UserName2Id($userlist, $username) {
		foreach($userlist as $key => $val) {
			if ($username == $val) {
				return $key;
			}
		}
		return -1;
	}
	
	function parseInputData() {
                $raw_data = file_get_contents($this->stage_dir . $this->pPost['roomId']);
                $this->stageData = json_decode($raw_data, true);
		if (isset($this->pPost['act'])) {
			switch($this->pPost['act']) {
				case "add":
					file_put_contents($this->filename, json_encode($this->stageData));
					break;
				default:
					$this->err_msg = "act not found.";
					header('HTTP', true, 400);
					return false;
			}
		} else {
		}
		return true;
	}
	
	public function execute() {
		$stage = 1;
		$this->convertInputJson();
		if (!$this->parseInputData()) {
			$this->outputError();
			return;
		}
		print json_encode($this->stageData);
	}
}

$shingekiAPI_Stage = new ShingekiAPI_Stage();
$shingekiAPI_Stage->execute();
