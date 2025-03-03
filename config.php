<?php
// Dynamically configure ulogger variables from environment variables.

foreach (preg_grep("/^ULOGGER_/", array_keys(getenv()) as $key) {
  ${$key} = getenv($key);
  if ($ULOGGER_DEBUG) echo "$key=" . ${$key} . "\n";
}

?>
