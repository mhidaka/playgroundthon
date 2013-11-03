<?php
$err = "";
function roomList()
{
echo "roomList";
}

echo $_GET['act'];
if (isset($_GET['act'])) {
	switch($_GET['act']) {
		case "roomList":
			roomList();
			break;
	}
}