<?php

// Задание 3
// Написать рассчет количества вторников между двумя датами на PHP.

$tuesdays = 0;
$start = new DateTime('2022-09-01');
$end = new DateTime('2022-09-20');
// если первый и/или последний день приходится на вторник и его надо считать, то нужно добавить по одному дню, из условия следует, скорее, что считать не надо

$interval = DateInterval::createFromDateString('1 day');
$period = new DatePeriod($start, $interval, $end);
foreach ($period as $day) {
    if ($day->format('N') == 2) {
        $tuesdays++;
    }
}
echo $tuesdays;