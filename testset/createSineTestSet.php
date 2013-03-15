<?php

    $fp=fopen("testset.h","w");
    fprintf($fp,"#define TESTSET @\"");
    $facx=3.1415926*3.0;
    $facy=3.1415926*5.0;
    $scale=0.9;
    $yscale=0.0;
    $step=0.1;
    for ($a=-1.0; $a <= 1.0; $a+=$step)
    {
        $x=(sin($a * $facx)+$yscale)/($scale*2.0);
        $y=(cos($a * $facy)+$yscale)/($scale*2.0);
        fprintf($fp,"%f,%f,%f\\n",$a,$x,$y);
    }
    $a=1.0;
    $x=(sin($a * $facx)+$yscale)/($scale*2.0);
    $y=(cos($a * $facy)+$yscale)/($scale*2.0);
    fprintf($fp,"%f,%f,%f\\n",$a,$x,$y);
    fprintf($fp,"\"");
?>