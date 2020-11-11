<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Article_Past_Due_for_Publishing</fullName>
        <ccEmails>pthomas@avetta.com</ccEmails>
        <description>Article Past Due for Publishing</description>
        <protected>false</protected>
        <recipients>
            <recipient>Training</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_and_Workflow_Emails/Article_Publish_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Article_has_been_approved</fullName>
        <description>Article has been approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_and_Workflow_Emails/Article_Approved</template>
    </alerts>
    <alerts>
        <fullName>Article_has_been_rejected</fullName>
        <description>Article has been rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_and_Workflow_Emails/Article_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Article_Qualification</fullName>
        <description>Initial Phase of the approval process may be removed at some point.</description>
        <field>Status__c</field>
        <literalValue>Article Qualification</literalValue>
        <name>Article Qualification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Ready_for_Edit</fullName>
        <description>Updates the article status to Ready for Edit.</description>
        <field>Status__c</field>
        <literalValue>Ready for Edit</literalValue>
        <name>Status: Ready for Edit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Ready_for_Review</fullName>
        <description>Updates the status field to Ready for Review</description>
        <field>Status__c</field>
        <literalValue>Ready for Review</literalValue>
        <name>Status: Ready for Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Ready_to_Publish</fullName>
        <description>Updates the status to Ready to Publish.</description>
        <field>Status__c</field>
        <literalValue>Ready to Publish</literalValue>
        <name>Status: Ready to Publish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Waiting_on_Revision</fullName>
        <description>Updates the status to Waiting for Revision.</description>
        <field>Status__c</field>
        <literalValue>Waiting for Revision</literalValue>
        <name>Status: Waiting on Revision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VStatus_Validated</fullName>
        <description>Updates the validation status to validated.</description>
        <field>ValidationStatus</field>
        <literalValue>Validated</literalValue>
        <name>VStatus: Validated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Article Publish Reminder</fullName>
        <actions>
            <name>Article_Past_Due_for_Publishing</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Reminder to the training team to publish an article or update the target publish date.</description>
        <formula>AND(isPICKVAL(Status__c, &quot;Ready to Publish&quot;), (Target_Publish_Date__c - Today()) &gt; 0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
