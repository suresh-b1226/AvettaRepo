<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notice_of_Severe_Detractor</fullName>
        <description>Notice of Severe Detractor</description>
        <protected>false</protected>
        <recipients>
            <recipient>jvillaverde@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/NPX_Severe_Detractor_HTML</template>
    </alerts>
    <rules>
        <fullName>Severe Detractor Notification</fullName>
        <actions>
            <name>Notice_of_Severe_Detractor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NPX_Survey_Record__c.Primary_Score__c</field>
            <operation>lessOrEqual</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>NPX_Survey_Record__c.Survey_Name__c</field>
            <operation>equals</operation>
            <value>TX - CS AND CLIENT HELPDESK</value>
        </criteriaItems>
        <criteriaItems>
            <field>NPX_Survey_Record__c.Primary_Score__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
