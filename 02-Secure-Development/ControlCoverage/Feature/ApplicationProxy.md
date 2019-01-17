**Note:** You can scan your application proxy instance by executing [script](../Feature/Scripts/ADAppProxyScanScript.ps1.txt) in PowerShell.

<html>
<head>

</head><body>
<H2>ApplicationProxy</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>
<tr><td><b>Only security compliant apps should be onboarded to AAD App Proxy</b>
<br/>AAD App proxy facilitates remote access to your on-prem apps. If these apps have not been designed and implemented securely, then security issues of your apps get exposed to the internet.</td>
<td>High</td><td>No</td><td>No</td></tr>
<tr><td><b>AAD Authentication must be enabled as a pre-authentication method on your app</b>
<br/>Pre-authentication by its very nature, blocks a significant number of anonymous attacks, because only authenticated identities can access the back-end application.</td>
<td>High</td><td>No</td><td>No</td></tr>
<tr><td><b>Delete personal data captured in logs on connector machine periodically or turn off connector machine logging if not required</b>
<br/>Connector machine logs may contain personal data. This needs to be handled with care and purged when not needed in keeping with good privacy principles.</td>
<td>High</td><td>No</td><td>No</td></tr>
<tr><td><b>HTTP-Only cookie must be enabled while configuring App Proxy wherever possible</b>
<br/>Using an HTTP-Only cookie protects against cross site scripting (XSS) attacks by disallowing cookie access to client side scripts.</td>
<td>High</td><td>No</td><td>No</td></tr>
<tr><td><b>Use a security hardened, locked down OS image for the connector machine</b>
<br/>The connector machine is serving as a 'gateway' into the corporate environment allowing internet based client endpoints access to enterprise data. Using a locked-down, secure baseline configuration ensures that this machine does not get leveraged as an entry point to attack the applications/corporate network.</td>
<td>High</td><td>No</td><td>No</td></tr>
</table>
  
 
  
</body></html>
