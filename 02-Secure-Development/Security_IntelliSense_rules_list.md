## **Security IntelliSense Rule List**


### **Rule - appsec_xml_doc_dtdprocessing_parse**

**Message**
<br/>
Do not use Parse option in System.Xml.DtdProcessing. DTD parsing can be exploited towards various DoS and elevation of privilege attacks.
<br/>
<br/>
**Description**
<br/>
Do not use Parse option in System.Xml.DtdProcessing. DTD parsing can be exploited towards various DoS and elevation of privilege attacks.
<br/>
<br/>
***
### **Rule - appsec_xml_doc_resolver**

**Message**
<br/>
Use XmlResolver carefully in trusted document scenarios. Consider using XmlSecureResolver instead.
<br/>
<br/>
**Description**
<br/>
Use XmlResolver carefully in trusted document scenarios. Consider using XmlSecureResolver instead.
<br/>
<br/>
***
### **Rule - appsec_xml_prohibitdtd_flag**

**Message**
<br/>
Do not set ProhibitDtd property to false. This may increase exposure to DoS and elevation of privilege attacks from DTD parsing.
<br/>
<br/>
**Description**
<br/>
Do not set ProhibitDtd property to false. This may increase exposure to DoS and elevation of privilege attacks from DTD parsing.
<br/>
<br/>
***
### **Rule - authn_web_cookie_create_settings_1**

**Message**
<br/>
Set secure property to true wherever possible. Set HttpOnly to true wherever possible. Set shorter expiry time wherever possible.
<br/>
<br/>
**Description**
<br/>
Set secure property to true wherever possible. Set HttpOnly to true wherever possible. Set shorter expiry time wherever possible.
<br/>
<br/>
***
### **Rule - authn_web_cookie_create_settings_2**

**Message**
<br/>
Set secure property to true wherever possible. Set HttpOnly to true wherever possible. Set shorter expiry time wherever possible.
<br/>
<br/>
**Description**
<br/>
Set secure property to true wherever possible. Set HttpOnly to true wherever possible. Set shorter expiry time wherever possible.
<br/>
<br/>
***
### **Rule - authn_web_cookie_expiry**

**Message**
<br/>
Set cookie expiry to be as short as possible...especially if the cookie is being used for authenticated sessions.
<br/>
<br/>
**Description**
<br/>
Long cookie expiry periods increase the exposure and exploitability of a cookie in the event that it gets stolen.
<br/>
<br/>
***
### **Rule - authn_web_cookie_httponly**

**Message**
<br/>
Set httponly to true to reduce risk of JavaScript accessing the cookies
<br/>
<br/>
**Description**
<br/>
Set httponly to true to reduce risk of JavaScript accessing the cookies
<br/>
<br/>
***
### **Rule - authn_web_cookie_secure_flag**

**Message**
<br/>
Set secure to true to reduce risk of sending cookie over plain HTTP.
<br/>
<br/>
**Description**
<br/>
Setting secure flag to true for a cookie ensures that the browser will never send it over a non-HTTPS connection. This protects the cookie from network layer disclosure.
<br/>
<br/>
***
### **Rule - authn_web_formsauthticket_timeout**

**Message**
<br/>
Mindful about the expiration time. Keep it short
<br/>
<br/>
**Description**
<br/>
Mindful about the expiration time. Keep it short
<br/>
<br/>
***
### **Rule - authn_web_formsprotection_encryption**

**Message**
<br/>
FormsProtection should set to FormsProtectionEnum.All.
<br/>
<br/>
**Description**
<br/>
FormsProtection should set to FormsProtectionEnum.All for adequately protecting cookies against various crypto attacks.
<br/>
<br/>
***
### **Rule - authn_web_formsprotection_none**

**Message**
<br/>
FormsProtection should set to FormsProtectionEnum.All.
<br/>
<br/>
**Description**
<br/>
FormsProtection should set to FormsProtectionEnum.All for adequately protecting cookies against various crypto attacks.
<br/>
<br/>
***
### **Rule - authn_web_formsprotection_validation**

**Message**
<br/>
FormsProtection should set to FormsProtectionEnum.All.
<br/>
<br/>
**Description**
<br/>
FormsProtection should set to FormsProtectionEnum.All for adequately protecting cookies against various crypto attacks.
<br/>
<br/>
***
### **Rule - azure_aad_authority_validation_turned_off**

**Message**
<br/>
Authority validation should not be disabled for AAD security tokens.
<br/>
<br/>
**Description**
<br/>
Disabling authority validation implies that any well-formed token will get accepted regardless of which authority signed the token. This is rarely desirable. Do not explicitly set the validation to 'false' in the AuthenticationContext. The default value is 'true'.
<br/>
<br/>
***
### **Rule - azure_aad_avoid_custom_token_caching**

**Message**
<br/>
Custom token cache identified. Allow ADAL to transparently handle any caching needs for tokens.
<br/>
<br/>
**Description**
<br/>
Do not use custom caches for ADAL tokens. The ADAL library uses a in-memory cache for the storage of tokens when no custom tokencache is provided explicitly to its AuthenticationContext constructor.
<br/>
<br/>
***
### **Rule - azure_aad_avoid_memberof**

**Message**
<br/>
The 'memberOf' method is not transitive, i.e. it doesn't return nested groups. As a result, it might lead to security bypass in certain cases.
<br/>
<br/>
**Description**
<br/>
The 'memberOf' method is used for checking the group membership of a user. This method is not transitive, i.e. it doesn't return nested groups. As a result, it might lead to security bypass in certain cases. Review if the group membership verification logic in the code would work as intended even when the memberOf method is used. However, it is always recommended to use other API methods listed here: https://msdn.microsoft.com/en-us/library/azure/ad/graph/api/users-operations for checking the group membership.
<br/>
<br/>
***
### **Rule - azure_adal_avoid_accesstoken_in_code**

**Message**
<br/>
Explicit usage of accesstoken found in the code: access tokens should be handled securely. It is recommended not to store it separately in a persistent storage like databases or files, unless there is a compelling requirement.
<br/>
<br/>
**Description**
<br/>
It is recommended to use ADAL library for acquiring the tokens as it saves them securely in an internal in-memory cache in its default configuration.
<br/>
<br/>
***
### **Rule - azure_adal_avoid_refreshtoken_in_code**

**Message**
<br/>
Explicit usage of refreshtoken found in the code: refresh tokens should be handled securely. It is recommended not to store it separately in a persistent storage like database and files, unless there is a compelling requirement.
<br/>
<br/>
**Description**
<br/>
It is recommended to use ADAL library for acquiring the tokens as it saves them securely in a internal in-memory cache in its default configuration
<br/>
<br/>
***
### **Rule - azure_sbr_no_client_authentication**

**Message**
<br/>
It is unsafe to use 'RelayClientAuthenticationType.None' as it allows clients to connect to the relay without authentication. Use RelayClientAuthenticationType.RelayAccessToken.
<br/>
<br/>
**Description**
<br/>
When using a service bus relays, clients have to authenticate to the relay in order to use it to connect to the on-premise endpoint. If 'None' is used for RelayClientAuthenticationType, it means any client (without credentials) can connect to the relay and attempt to reach the on-premise service.
<br/>
<br/>
***
### **Rule - azure_storage_blob_public_access**

**Message**
<br/>
The chosen setting for BlobContainerPublicAccessType  will allow 'public' access of blobs within this container (without requiring an access token). This should be carefully evaluated in the context of the scenario.
<br/>
<br/>
**Description**
<br/>
The chosen setting for BlobContainerPublicAccessType  will allow 'public' access of blobs within this container (without requiring an access token). It is recommended to use BlobContainerPublicAccessType.Off unless it absolutely required. Creation of containers with unrestricted access should be carefully evaluated in the context of the scenario.
<br/>
<br/>
***
### **Rule - azure_storage_container_public_access**

**Message**
<br/>
The chosen setting for BlobContainerPublicAccessType  will allow 'public' access of blobs within this container (without requiring an access token). This should be carefully evaluated in the context of the scenario.
<br/>
<br/>
**Description**
<br/>
The chosen setting for BlobContainerPublicAccessType  will allow 'public' access of blobs within this container (without requiring an access token). It is recommended to use BlobContainerPublicAccessType.Off unless it absolutely required. Creation of containers with unrestricted access should be carefully evaluated in the context of the scenario.
<br/>
<br/>
***
### **Rule - azure_storage_sas_use_https**

**Message**
<br/>
The 'HttpsOrHttp' option is insecure as it allows use of Http (plaintext) for content request and transfer. Use SharedAccessProtocol.HttpsOnly.
<br/>
<br/>
**Description**
<br/>
Use of 'HttpsOrHttp' implies that both the request content and any headers (including SAS tokens) will get transferred over plaintext. Instead use SharedAccessProtocol.HttpsOnly to ensure the transfer is encrypted.
<br/>
<br/>
***
### **Rule - azure_storage_sastoken_validity_too_long**

**Message**
<br/>
Use shortest possible token lifetime appropriate for the scenario. See AAD default token expiration times here.
<br/>
<br/>
**Description**
<br/>
It is recommended to set appropriate and short lifetime for tokens. Typically access tokens should have a validity period of a few hours (ideally kept as small as practical).
<br/>
<br/>
***
### **Rule - crypto_certs_weak_hmac**

**Message**
<br/>
The X509Certificate2 class does not support SHA256-based signatures.
<br/>
<br/>
**Description**
<br/>
The X509Certificate2 class supports SHA1-based signature algorithms. These are considered weak and inadequate. Consider using RsaCryptoServiceProvider as that supports SHA-256-based signatures.
<br/>
<br/>
***
### **Rule - crypto_dpapi_avoid_localmachine_flag**

**Message**
<br/>
Use DataProtectionScope.CurrentUser. LocalMachine will open gates to all the processes running on the computer to unprotect the data.
<br/>
<br/>
**Description**
<br/>
Use DataProtectionScope.CurrentUser. LocalMachine will open gates to all the processes running on the computer to unprotect the data.
<br/>
<br/>
***
### **Rule - crypto_enc_aes_weak_keysize**

**Message**
<br/>
Encryption key size used for AES must be large enough.
<br/>
<br/>
**Description**
<br/>
When using AES encryption, key sizes used should be at least 256 bits. Use of 128 bits is currently allowed but only in backward compatibility scenarios.
<br/>
<br/>
***
### **Rule - crypto_enc_avoid_padding_mode_ansix923**

**Message**
<br/>
Try to use PKCS7 with AES wherever possible.
<br/>
<br/>
**Description**
<br/>
Use the PKCS7 padding mode with AES wherever possible. Other padding modes may lead to subtle crypto vulnerabilities.
<br/>
<br/>
***
### **Rule - crypto_enc_avoid_padding_mode_iso10126**

**Message**
<br/>
Try to use PKCS7 with AES wherever possible.
<br/>
<br/>
**Description**
<br/>
Use the PKCS7 padding mode with AES wherever possible. Other padding modes may lead to subtle crypto vulnerabilities.
<br/>
<br/>
***
### **Rule - crypto_enc_avoid_padding_mode_none**

**Message**
<br/>
Try to use PKCS7 with AES wherever possible.
<br/>
<br/>
**Description**
<br/>
Use the PKCS7 padding mode with AES wherever possible. Other padding modes may lead to subtle crypto vulnerabilities.
<br/>
<br/>
***
### **Rule - crypto_enc_avoid_padding_mode_zeros**

**Message**
<br/>
Try to use PKCS7 with AES wherever possible.
<br/>
<br/>
**Description**
<br/>
Use the PKCS7 padding mode with AES wherever possible. Other padding modes may lead to subtle crypto vulnerabilities.
<br/>
<br/>
***
### **Rule - crypto_enc_ciphermode_ecb**

**Message**
<br/>
Do not use ECB mode for symmetric encryption.
<br/>
<br/>
**Description**
<br/>
The ECB mode is prone to various crypto attacks. Use a stronger mode such as CBC instead.
<br/>
<br/>
***
### **Rule - crypto_enc_unapproved_alg_rijndael**

**Message**
<br/>
RijndaelManaged class is not approved for use for symmetric encryption
<br/>
<br/>
**Description**
<br/>
The RijndaelManaged class supports algorithm modes which are not FIPS approved. It has also been found weak against certain attacks. Use AesCryptoServiceProvider instead.
<br/>
<br/>
***
### **Rule - crypto_hash_weak_alg_md5**

**Message**
<br/>
The MD5 hash algorigthm is weak and must not be used.
<br/>
<br/>
**Description**
<br/>
The MD5 hash algorithm has been broken and many practical attacks have been found in scenarios using it. Use SHA256CryptoServiceProvider instead.
<br/>
<br/>
***
### **Rule - crypto_hash_weak_alg_sha1**

**Message**
<br/>
The SHA1 hash algorigthm is weak and must not be used.
<br/>
<br/>
**Description**
<br/>
The SHA1 hash algorithm has been broken and many practical attacks have been found in scenarios using it. Use SHA256CryptoServiceProvider instead.
<br/>
<br/>
***
### **Rule - crypto_pki_rsa_keysize**

**Message**
<br/>
Use a keysize of 2048 bits or more for RSA.
<br/>
<br/>
**Description**
<br/>
Using keys of size less than 2048 is not recommended for RSA. Crypto using small key sizes increases risk of getting compromised.
<br/>
<br/>
***
### **Rule - crypto_rng_weak_rng**

**Message**
<br/>
The Random class is a cryptographically weak random number generator.
<br/>
<br/>
**Description**
<br/>
When used in the context of crypto, random number generators should be cryptographically secure. The class Random does not meet the requirements and should not be used. Consider using RNGCryptoServiceProvider instead.
<br/>
<br/>
***
### **Rule - dp_use_https_baseaddress_httpclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_baseaddress_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_deleteasync_httpclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downfiletaskaasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downloaddata_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downloaddataasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downloaddatataskasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downloadfile_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downloadfileasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downloadstring_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downloadstringasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_downloadstringtaskasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_getasync_httpclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_getbytearrayasync_httpclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_getstreamasync_httpclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_getstringasync_httpclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_getwebrequest_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_httprequestmessage_1**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_httprequestmessage_2**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_postasync_httpclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_putasync_httpclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_requesturi_httprequestmessage**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploaddata_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploaddataasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploaddatataskasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadfile_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadfileasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadfiletaskasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadstring_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadstringasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadstringtaskasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadvalues_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadvaluesasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_uploadvaluestaskasync_webclient**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - dp_use_https_webrequest**

**Message**
<br/>
Use HTTPS instead of HTTP.
<br/>
<br/>
**Description**
<br/>
Using HTTPS ensures that the server is authentic and that the data transferred is encrypted in transit. Do not use plain HTTP.
<br/>
<br/>
***
### **Rule - inpval_file_name_from_user**

**Message**
<br/>
If using end user input to create a filename, please validate it carefully to defend against path traversal attacks.
<br/>
<br/>
**Description**
<br/>
When end user input is used to determine a filename, it is possible for malicious users to include metacharacters that can lead the code into opening/overwriting/executing an entirely different file than what was intended.
<br/>
<br/>
***
### **Rule - inpval_open_redirect_mvc**

**Message**
<br/>
If using end user input to create the redirect URL, please validate it carefully to defend against URL redirection attacks.
<br/>
<br/>
**Description**
<br/>
When end user input is used to determine a redirect URL, it is possible for malicious users to craft payloads that can lead to phishing and elevation of privilege attacks. Make sure you validate that the targetURL is local.
<br/>
<br/>
***
### **Rule - sqli_cmdtype_sp**

**Message**
<br/>
Careful! If user input is concatenated directly inside stored procedure when using dynamic queries it may lead to SQL Injection.
<br/>
<br/>
**Description**
<br/>
Validate user input being included as part of a SQL query. Do not concatenate user inputs directly into query strings...use parameterized queries instead.
<br/>
<br/>
***
### **Rule - sqli_cmdtype_text**

**Message**
<br/>
Careful! Using the Text commandType exposes code to risks of SQL injection.
<br/>
<br/>
**Description**
<br/>
Validate user input being included as part of a SQL query. Do not concatenate user inputs directly into query strings...use parameterized queries instead.
<br/>
<br/>
***
### **Rule - sqli_execsqlcmd_async_ef**

**Message**
<br/>
Careful! Using ExecuteSql with user input may lead to SQL Injection attacks.
<br/>
<br/>
**Description**
<br/>
Validate user input being included as part of a SQL query. Do not concatenate user inputs directly into query strings...use parameterized queries instead.
<br/>
<br/>
***
### **Rule - sqli_execsqlcmd_ef**

**Message**
<br/>
Careful! Using ExecuteSql with user input may lead to SQL Injection attacks.
<br/>
<br/>
**Description**
<br/>
Validate user input being included as part of a SQL query. Do not concatenate user inputs directly into query strings...use parameterized queries instead.
<br/>
<br/>
***
### **Rule - sqli_sqlcmd_create_settings_1**

**Message**
<br/>
Do an input validation before using the user input in a query. Do not concatenate user inputs directly. Use Parameterized queries.
<br/>
<br/>
**Description**
<br/>
Do an input validation before using the user input in a query. Do not concatenate user inputs directly. Use Parameterized queries.
<br/>
<br/>
***
### **Rule - sqli_sqlcmd_create_settings_2**

**Message**
<br/>
Do an input validation before using the user input in a query. Do not concatenate user inputs directly. Use Parameterized queries.
<br/>
<br/>
**Description**
<br/>
Do an input validation before using the user input in a query. Do not concatenate user inputs directly. Use Parameterized queries.
<br/>
<br/>
***
### **Rule - xss_raw_html_mvc_razor**

**Message**
<br/>
Try to avoid this method as it emits the HTML without encoding.
<br/>
<br/>
**Description**
<br/>
Try to avoid this method as it emits the HTML without encoding.
<br/>
<br/>
***
### **Rule - xss_web_validaterequest_flag**

**Message**
<br/>
ValidateRequest should not be set to false. It is a critical defense against XSS attacks in Asp.Net Web Forms.
<br/>
<br/>
**Description**
<br/>
ValidateRequest should not be set to false. It is a critical defense against XSS attacks in Asp.Net Web Forms.
<br/>
<br/>
***

