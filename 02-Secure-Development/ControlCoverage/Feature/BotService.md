<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

</head><body>
<H2>BotService</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr><tr><td><b>Bot Service API must only be accessible over HTTPS</b><br/>Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks.</td><td>High</td><td>No</td><td>No</td></tr><tr><td><b>Ensure to use own storage adapter instead of Bot Framework State Service API.</b><br/>Using this feature ensures that sensitive data is stored encrypted at rest. This minimizes the risk of data loss from physical theft and also helps meet regulatory compliance requirements.</td><td>High</td><td>No</td><td>No</td></tr><tr><td><b>Secrets in Bot Service must be handled properly.</b><br/>Keeping secrets such as passwords, keys, etc. in clear text can lead to easy compromise at various avenues during an application's lifecycle.</td><td>High</td><td>No</td><td>No</td></tr><tr><td><b>Make sure important activities and events during Bot interactions are logged.</b><br/>Analytics can be useful to detect unusual usage behavior patterns.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>Only specific/required channels must be configured to allow traffic to bot service.</b><br/>Each channel a bot is configured for, exposes the bot to activity on that channel. If a channel that is not actually required is enabled for the bot, it introduces unnecessary avenues for attack.</td><td>High</td><td>Yes</td><td>No</td></tr></table>
<table>
</table>
</body></html>
