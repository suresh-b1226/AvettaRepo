<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Manager_New_Account_Assignment</fullName>
        <description>Account Manager (New Account Assignment)</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_Rep_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Emails_Templates/New_Assignment_to_Account_Manager</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Opp_Owner_on_Assignment</fullName>
        <description>Email to Opp Owner on Assignment</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Emails_Templates/Operator_Assignment</template>
    </alerts>
    <fieldUpdates>
        <fullName>Activate</fullName>
        <description>Temporary field update to set University Electric to Active whenever it is not set.  Reevaluate every week until it&apos;s been resolved.</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Activate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Health_Modified_by</fullName>
        <description>Populates the user that updated the field</description>
        <field>Health_Modified_by__c</field>
        <formula>$User.LastName</formula>
        <name>Health Modified by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_ID</fullName>
        <description>Populate Owner ID</description>
        <field>Owner_ID__c</field>
        <formula>OwnerId</formula>
        <name>Owner ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SER_CSAT_sent_date</fullName>
        <description>Sets the date of the last time a CSAT survey was sent.</description>
        <field>SER_CSAT_Survey_Last_Sent__c</field>
        <formula>TODAY()</formula>
        <name>SER CSAT sent date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Health_Modified_Date</fullName>
        <field>Health_Modified_Date__c</field>
        <formula>Today()</formula>
        <name>Update Health Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SER_Owner</fullName>
        <description>resets the Supplier Enablement Rep field to blank when the account is deactivated</description>
        <field>Supplier_Enablement_Rep__c</field>
        <name>Update SER Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sent_Deactivation_Notice</fullName>
        <field>Sent_Deactivation_Notification__c</field>
        <formula>Now()</formula>
        <name>Update Sent Deactivation Notice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>SER_Account_Pmt</fullName>
        <apiVersion>32.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/oppwon</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>rsmith@picsauditing.com</integrationUser>
        <name>SER Account Pmt</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>SER_CSAT_Outbound_Message</fullName>
        <apiVersion>48.0</apiVersion>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_5daWCM8DjJ1tN1b&amp;u=UR_8qfeQyrVJ0piaVv&amp;t=OC_21gmrci1x9FS8y4&amp;b=avetta</endpointUrl>
        <fields>BillingCountry</fields>
        <fields>BillingState</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>Organizer_ID__c</fields>
        <fields>Primary_Contact_Email__c</fields>
        <fields>Primary_Contact_Phone__c</fields>
        <fields>Primary_Contact__c</fields>
        <fields>Region__c</fields>
        <fields>Supplier_Enablement_Rep__c</fields>
        <fields>Vetify__c</fields>
        <fields>X18_Digit_ID__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>tgarcia@avetta.com</integrationUser>
        <name>SER CSAT Outbound Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Contractor Paid Checkbox to False</fullName>
        <actions>
            <name>Update_SER_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>used for identifying when a contractor account is deactivated.  The workflow will set the Contractor Paid checkbox to true.</description>
        <formula>AND(ISCHANGED(Status__c),PRIORVALUE(Status__c) = &quot;Active&quot;, RecordType.DeveloperName = &quot;Contractor&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SER CSAT Survey</fullName>
        <actions>
            <name>SER_CSAT_sent_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SER_CSAT_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends SER CSAT survey when account goes from pending to Active</description>
        <formula>AND( ISCHANGED(Status__c), ISPICKVAL(PRIORVALUE(Status__c), &apos;Pending&apos;),  ISPICKVAL(Status__c , &apos;Active&apos;), RecordTypeId = &apos;01270000000MRzn&apos;, NOT(ISBLANK(BillingCountry)), OR( UPPER(BillingCountry) = &apos;US&apos;, UPPER(BillingCountry) = &apos;USA&apos;, UPPER(BillingCountry) = &apos;UNITED STATES&apos;, UPPER(BillingCountry) = &apos;UNITED STATES OF AMERICA&apos; ), NOT(ISBLANK(Primary_Contact__c)), NOT(ISBLANK(Primary_Contact_Email__c)), OR( ISBLANK(SER_CSAT_Survey_Last_Sent__c), SER_CSAT_Survey_Last_Sent__c  &lt;= (TODAY() - 180) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sent Supplier Deactivation Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contractor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Deactivated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Sent_Deactivation_Notification__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Sent_Deactivation_Notice</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Test_Task</fullName>
        <assignedTo>tgarcia@avetta.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Test Task</subject>
    </tasks>
</Workflow>
