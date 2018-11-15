<?php
$f = file_get_contents("/Users/idevz/Desktop/a.png");
print_r(gettype($f));
// bool settype (mixed &$var,string $type)
echo PHP_EOL;var_export(is_array($f));
echo PHP_EOL;var_export(is_double($f));
echo PHP_EOL;var_export(is_float($f));
echo PHP_EOL;var_export(is_real($f));
echo PHP_EOL;var_export(is_long($f));
echo PHP_EOL;var_export(is_int($f));
echo PHP_EOL;var_export(is_integer($f));
echo PHP_EOL;var_export(is_string($f));
echo PHP_EOL;var_export(is_bool($f));
echo PHP_EOL;var_export(is_object($f));
echo PHP_EOL;var_export(is_resource($f));
echo PHP_EOL;var_export(is_null($f));
echo PHP_EOL;var_export(is_scalar($f));
echo PHP_EOL;var_export(is_numeric($f));
echo PHP_EOL;var_export(is_callable($f));
