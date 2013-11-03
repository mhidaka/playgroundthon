<?php
class ShingekiAPIBaseClass2 {
	protected $err_msg = "";
	protected $pPost = "";

	public function outputError() {
		$ary = array();
		$ary['status'] = "error";
		$ary['message'] = $this->err_msg;
		print(json_encode($ary));
	}
	
	public function convertInputJson() {
		$raw_post = $_POST['request_data'];
		$this->pPost = json_decode($raw_post, true);
	}
}

