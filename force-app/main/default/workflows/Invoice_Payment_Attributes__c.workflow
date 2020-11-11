<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Manager_Two</fullName>
        <field>Account_Manager_2__c</field>
        <name>Account Manager Two</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Intitialize_Final_Payment_Basis</fullName>
        <field>Final_Basis_Amount__c</field>
        <formula>Net_Payment_Basis__c</formula>
        <name>Intitialize Final Payment Basis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Initialize final payment basis</fullName>
        <actions>
            <name>Intitialize_Final_Payment_Basis</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_Payment_Attributes__c.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/2018 1:00 AM</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
