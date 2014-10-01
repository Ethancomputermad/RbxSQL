<?php
	$rest_json = file_get_contents("php://input");
	$_POST = json_decode($rest_json, true);
	ini_set('html_errors', false);

	#error_reporting(0);
	if ($_POST['host']=='localhost' or $_POST['host']=='54.72.38.203'){
		die('Access denied');
	}
	function reserved_ip($ip)
{
    $reserved_ips = array( // not an exhaustive list
    '167772160'  => 184549375,  /*    10.0.0.0 -  10.255.255.255 */
    '3232235520' => 3232301055, /* 192.168.0.0 - 192.168.255.255 */
    '2130706432' => 2147483647, /*   127.0.0.0 - 127.255.255.255 */
    '2851995648' => 2852061183, /* 169.254.0.0 - 169.254.255.255 */
    '2886729728' => 2887778303, /*  172.16.0.0 -  172.31.255.255 */
    '3758096384' => 4026531839, /*   224.0.0.0 - 239.255.255.255 */
    );

    $ip_long = sprintf('%u', ip2long($ip));

    foreach ($reserved_ips as $ip_start => $ip_end)
    {
        if (($ip_long >= $ip_start) && ($ip_long <= $ip_end))
        {
            return TRUE;
        }
    }
    return FALSE;
}
	function bail($link){
		$err=mysqli_error($link);
		mysqli_close($link);
		die($err);
	}
	if (reserved_ip($_POST['host'])==FALSE){} else { die('Access denied');}
	if (!isset($_POST['port'])){
		$_POST['port']=NULL;
	}
	if (!isset($_POST['socket'])){
		$_POST['socket']=NULL;
	}
	if (!isset($_POST['db'])){
		$_POST['db']=NULL;	
	}
	$sql = mysqli_connect($_POST['host'],$_POST['username'],$_POST['password'],$_POST['db'],$_POST['port'],$_POST['socket']) or bail($sql);
	$res=mysqli_query($sql,$_POST['query']) or bail($sql);
	mysqli_close($sql);
	if (gettype($res)=='boolean'){$rows=array();} else {
	$rows = array();
	while($r = mysqli_fetch_assoc($res)) {
  	  $rows[] = $r;
	}
	}
	die(json_encode($rows));
?>
