# docker-ulogger-server
Dockerized &#x00B5;Logger Server

## Variables

The &#x00B5;logger docker container is configured with environment variables. The
variables must all begin with ULOGGER_ and then the &#x00B5;logger variable name. 
For example, `ULOGGER_lang=en`. Variables may be case sensitive.

|Key|Default|Description|
|:-|:-|:-|
|setup|`false`|Enable setup script.|
|dbdsn||PDO data source name. Ex:<br/>`mysql:host=localhost;port=3307;dbname=ulogger;charset=utf8`<br/>`mysql:unix_socket=/path/to/mysql.sock;dbname=ulogger;charset=utf8`<br/>`pgsql:host=localhost;port=5432;dbname=ulogger`<br/>`sqlite:/path/to/ulogger.db`|
|dbuser||Database user name.|
|dbpass||Database user password.|
|dbprefix||Optional table names prefix, ex: `ulogger_`.|
|mapapi|`gmaps`|Default map drawing framework. (`gmaps`, `openlayers`, `openlayers3`)|
|init_latitude|`0`|Default latitude for initial map.|
|init_longitude|`0`|Default longitude for initial map.|
|gkey||Google maps API key.|
|require_authentication||Require login/password authentication. (`0`=no, `1`=yes)|
|public_tracks|`0`|All users tracks are visible to authenticated user.|
|admin_user||Admin user who can<br/>&nbsp;- add new users<br/>&nbsp;- edit all tracks & users<br/>&nbsp;- has access to all users locations.<br/>None if empty.|
|pass_lenmin|`0`|Minimum required length of user password.|
|pass_strength|`0`|Required strength of user password.<br>&nbsp;`0` = no requirements,<br/>&nbsp;`1` = require mixed case letters (lower and upper),<br/>&nbsp;`2` = require mixed case and numbers,<br/>&nbsp;`3` = require mixed case, numbers and non-alphanumeric characters|
|interval||Default interval in seconds for live auto reload. `0` = disable|
|lang|`en`|Default language (`en`, `pl`, `de`, `hu`, `fr`, `it`).|
|units|`metric`|Default units (`metric`, `imperial`).|
