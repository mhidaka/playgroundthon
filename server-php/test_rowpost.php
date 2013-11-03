<?php
$err = "";
function roomList()
{
echo "roomList";
}


if (isset($_GET['act'])) {
	switch($_GET['act']) {
		case "roomList":
			roomList();
			break;
	}
}

echo "hoge";
