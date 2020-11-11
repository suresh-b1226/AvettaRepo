<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>External_Refund_Request_Rejected</fullName>
        <description>External Refund Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>atiso@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_and_Workflow_Emails/Refund_Request_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Refund_has_been_Processed</fullName>
        <description>Refund has been Processed</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_of_Refund__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_and_Workflow_Emails/Refund_Request_Approval_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>updateStatusApproved</fullName>
        <description>updates status to Approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>updateStatusApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatusCompleted</fullName>
        <description>Update the external refund status to Completed.</description>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>updateStatusCompleted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatusDenied</fullName>
        <description>Update status field to denied.</description>
        <field>Status__c</field>
        <literalValue>Denied</literalValue>
        <name>updateStatusDenied</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatusSubmitted</fullName>
        <description>Update the status field to submitted.</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>updateStatusSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
