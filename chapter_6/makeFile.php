<?php
    $data = $GLOBALS['HTTP_RAW_POST_DATA'];
    if (is_null($data)) {   
        echo "No data was sent";
    } else {
                //저장할 파일명을 지정합니다.
        $filename = mktime().".jpg";  
                //권한이 777로 설정돼 있는 data라는 서브 디렉토리에 저장합니다.
        $file = fopen("data/".$filename, "w") or die("Can't open file");   
        if(!fwrite($file, $data)){  
            echo "Error writing to file";
        }   
        print "\n";   
        fclose($file);
    }
    //저장한 경로를 변수에 담습니다.
    $image = "http://".$_SERVER["HTTP_HOST"]."/data/".$filename; 
?>
