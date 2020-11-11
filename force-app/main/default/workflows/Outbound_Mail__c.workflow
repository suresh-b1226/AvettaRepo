<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Outbound_Mailing_has_occurred2</fullName>
        <description>Outbound Mailing has occurred</description>
        <protected>false</protected>
        <recipients>
            <recipient>dcarter@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jwebster@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>masalone@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ncarr@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Emails_Templates/Outbound_Mail</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Close_Date</fullName>
        <field>CloseDate</field>
        <formula>Date_Mailed__c</formula>
        <name>Update Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Related_Opportunity_2__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Mailed_Date</fullName>
        <field>Mailed_Date__c</field>
        <formula>Date_Mailed__c</formula>
        <name>Update Mailed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Related_Opportunity_2__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Close_Won</fullName>
        <field>StageName</field>
        <literalValue>Closed Won</literalValue>
        <name>Update Stage to Close Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Related_Opportunity_2__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Outbound mail notification</fullName>
        <actions>
            <name>Outbound_Mailing_has_occurred2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Total_Contractors_Mailed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Mail__c.Mail_Effort__c</field>
            <operation>equals</operation>
            <value>First</value>
        </criteriaItems>
        <description>Sends email on creation of new first mailing</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Mailed Date</fullName>
        <actions>
            <name>Update_Mailed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Mailed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Total_Contractors_Mailed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This rule is designed to auto populate the &quot;Mailed Date&quot; field upon the creation of the first Outbound Mail related object.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
