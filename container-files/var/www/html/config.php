<?php
// Dynamically configure ulogger variables from environment variables.

$DEBUG = getenv("ULOGGER_DEBUG");

foreach (preg_grep("/^ULOGGER_/", array_keys(getenv())) as $key) {
  $var = str_replace("ULOGGER_", "", $key);
  ${$var} = getenv($key);
  if ($DEBUG) echo  "$var=" . ${$var} . "\n";
}

?>
