<?php
    $data = $GLOBALS['HTTP_RAW_POST_DATA'];
    if (is_null($data)) {   
        echo "No data was sent";
    } else {
                //������ ���ϸ��� �����մϴ�.
        $filename = mktime().".jpg";  
                //������ 777�� ������ �ִ� data��� ���� ���丮�� �����մϴ�.
        $file = fopen("data/".$filename, "w") or die("Can't open file");   
        if(!fwrite($file, $data)){  
            echo "Error writing to file";
        }   
        print "\n";   
        fclose($file);
    }
    //������ ��θ� ������ ����ϴ�.
    $image = "http://".$_SERVER["HTTP_HOST"]."/data/".$filename; 
?>
