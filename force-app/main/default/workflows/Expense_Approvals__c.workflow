<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Solutions_Consultant_Travel_Denied</fullName>
        <description>Solutions Consultant Travel Denied</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_and_Workflow_Emails/Travel_Authorization_SCDenied</template>
    </alerts>
    <alerts>
        <fullName>Travel_Authorization_Approval</fullName>
        <description>Travel Authorization Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Additional_Avetta_Employee__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Solutions_Consultant__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_and_Workflow_Emails/Travel_Authorization_Approval</template>
    </alerts>
    <alerts>
        <fullName>Travel_Authorization_Denied</fullName>
        <description>Travel Authorization Denied</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Additional_Avetta_Employee__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Solutions_Consultant__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_and_Workflow_Emails/Travel_Authorization_Denied</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_field_update</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Approval field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_to_Approved</fullName>
        <description>Changes Approved Checkbox to Approved</description>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Field Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approved_to_False</fullName>
        <description>when submittting for approval set the Approved checkbox to false</description>
        <field>Approved__c</field>
        <literalValue>0</literalValue>
        <name>Set Approved to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_for_Approval_Checkbox_updaete</fullName>
        <field>Submitted_for_approval__c</field>
        <literalValue>1</literalValue>
        <name>Submitted for Approval Checkbox update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Approved</fullName>
        <description>updates the Approved Checkbox to True</description>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>approved_field_update</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>approved field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>approved_update_field</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>approved update field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
