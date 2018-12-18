## Scan Databricks using AzSK Job in workspace
### Contents
- [Overview](Readme.md#overview)
- [Setting up Job - Step by Step](Readme.md#setting-up-job---step-by-step)

## Overview
The basic idea behind setting up job in databricks workspace is to continuously validate security state of workspace. Support for Continuous Assurance lets us treat security truly as 
a 'state' as opposed to a 'point in time' achievement. This is particularly important in today's context 
when 'continuous change' has become a norm. Also We are exploring this as a general approach to expand AzSK scans into the ‘data’ plane for various cluster technologies.
>**Note:** This feature is currently in preview, changes are expected in upcoming releases.

## Setting up Job - Step by Step

In this section, we will walk through the steps of setting up a AzSK Job in workspace. 

To get started, we need the following:
1. The user setting up Job needs to have 'admin' access to the Databricks workspace.

2. User should have generated a personl access token(PAT).

**Step-1: Setup** 

0. Copy latest script from scripts section.
1. Open the PowerShell ISE and copy script. 
2. Run the script after updating required parameters.
3. When prompted enter personal access token(PAT).

**Step-2: Verifying that Job Setup is complete** 
**1:** Go to your Databricks workspace that was used above. In workspace you should see an folder created by the name 'AzSK'. Inside this folder, there will be a notebook by the name "AzSK_CA_Notebook", clicking on it will display the contents of the Notebook.
