SET FOREIGN_KEY_CHECKS=0;

TRUNCATE TABLE IDN_AUTH_SESSION_STORE;
TRUNCATE TABLE IDN_OAUTH2_AUTHORIZATION_CODE;
TRUNCATE TABLE IDN_OAUTH2_ACCESS_TOKEN_SCOPE;
TRUNCATE TABLE IDN_OAUTH2_ACCESS_TOKEN;

SET FOREIGN_KEY_CHECKS=1;
