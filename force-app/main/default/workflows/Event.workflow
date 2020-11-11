<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSM_Support_Request</fullName>
        <description>CSM Support Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>amitagupta@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>coltencarter@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jlang@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jvillaverde@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tgarcia@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Events_Automation/CSM_Request</template>
    </alerts>
    <alerts>
        <fullName>IPM_Support_Request</fullName>
        <description>IPM Support Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>eorozco@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tgarcia@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Events_Automation/IPM_Request</template>
    </alerts>
    <alerts>
        <fullName>QHSSE_Support_Request_Email_Alert</fullName>
        <description>QHSSE Support Request Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>dshields@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.ford@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Events_Automation/QHSSE_Support_Request</template>
    </alerts>
    <alerts>
        <fullName>Solution_Engineer_Request</fullName>
        <description>Solution Engineer Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>anna-louise.hammar@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>creimond@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dshields@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.bajema@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sarah.blevins@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Events_Automation/SE_Support_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Assigned_by</fullName>
        <description>when the criteia are met the assigned by field is set to the ADR alias</description>
        <field>Assigned_by__c</field>
        <formula>$User.FirstName &amp;&quot; &quot;&amp;  $User.LastName</formula>
        <name>Update Assigned by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_by_Role</fullName>
        <field>Assigned_By_Role__c</field>
        <formula>$UserRole.Name</formula>
        <name>Update Assigned by Role</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>ADR_Appointment_Set</fullName>
        <apiVersion>32.0</apiVersion>
        <description>sends msg to is.com for appointment tracking</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/apptsset</endpointUrl>
        <fields>Id</fields>
        <fields>RecordTypeId</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>rsmith@picsauditing.com</integrationUser>
        <name>ADR Appointment Set</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>ADR_Update_Email_after_demo</fullName>
        <apiVersion>32.0</apiVersion>
        <endpointUrl>https://apps.drawloop.com/package/111</endpointUrl>
        <fields>Drawloop_Next__c</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>msheppard@avetta.com</integrationUser>
        <name>ADR Update Email after demo</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Qualified_Lead_Appointment</fullName>
        <apiVersion>32.0</apiVersion>
        <description>tracks the qualified appointments set by the ADR team</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/qualopp</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>rsmith@picsauditing.com</integrationUser>
        <name>Qualified Lead Appointment</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Create a Task With Event</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Event.Type</field>
            <operation>equals</operation>
            <value>Account Review</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Account_Review_Due_in_Two_Weeks</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Event.StartDateTime</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>IS%2Ecom - ADR Appointment Set</fullName>
        <actions>
            <name>ADR_Appointment_Set</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.RecordTypeId</field>
            <operation>equals</operation>
            <value>Solution Demonstration</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>startsWith</operation>
            <value>ADR</value>
        </criteriaItems>
        <description>tracks appointments set for Insidesales ADR Dashboard</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IS%2Ecom - ADR Qualified Leads</fullName>
        <actions>
            <name>Qualified_Lead_Appointment</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.RecordTypeId</field>
            <operation>equals</operation>
            <value>Solution Demonstration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event.Appointment_Status__c</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <description>tracks qualified appointments set for Insidesales ADR Dashboard</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Assigned by</fullName>
        <actions>
            <name>Update_Assigned_by</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Assigned_by_Role</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule updates the assigned by field  when a new demo is scheduled by an ADR</description>
        <formula>AND( ISBLANK(Assigned_by__c) , Owner:User.Id  &lt;&gt;  $User.Id)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Complete_Demo_Review</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Event.StartDateTime</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Account_Review_Due_in_Two_Weeks</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Event.StartDateTime</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Account Review Due in Two Weeks</subject>
    </tasks>
    <tasks>
        <fullName>Complete_Demo_Review</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please update the Demo Status for the demonstration you just completed.  If this was not a qualified sales ready demo, you must identify why the lead was not qualified.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Event.EndDateTime</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Complete Demo Review</subject>
    </tasks>
    <tasks>
        <fullName>Update_Lead_Appointment_been_completed</fullName>
        <assignedToType>owner</assignedToType>
        <description>used to notify ADR that the appointment status was updated</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Update Lead - Appointment has been completed</subject>
    </tasks>
</Workflow>
