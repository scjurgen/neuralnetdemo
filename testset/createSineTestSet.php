<?php

    $fp=fopen("testset.h","w");
    fprintf($fp,"#define TESTSET @\"");
    $facx=3.1415926*3.0;
    $facy=3.1415926*5.0;
    $scale=0.9;
    for ($a=-1.0; $a <= 1.0; $a+=0.025)
    {
        $x=(sin($a * $facx)+$scale)/($scale*2.0);
        $y=(cos($a * $facy)+$scale)/($scale*2.0);
        fprintf($fp,"%f,%f,%f\\n",$a,$x,$y);
    }
    $a=1.0;
    $x=(sin($a * $facx)+$scale)/($scale*2.0);
    $y=(cos($a * $facy)+$scale)/($scale*2.0);
    fprintf($fp,"%f,%f,%f\\n",$a,$x,$y);
    fprintf($fp,"#\"");
?>
