<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ClicktoEmail_Type_Update</fullName>
        <field>Type</field>
        <literalValue>Email</literalValue>
        <name>ClicktoEmail Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Bad_Contact_Message</fullName>
        <apiVersion>32.0</apiVersion>
        <description>sets url for bad contact</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/disqlld</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>rsmith@picsauditing.com</integrationUser>
        <name>Bad Contact Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>SER_Live_Connection_Tracking</fullName>
        <apiVersion>32.0</apiVersion>
        <description>fires msg for each live connection</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/corcntcts</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>rsmith@picsauditing.com</integrationUser>
        <name>SER Live Connection Tracking</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ClicktoEmail Type Update</fullName>
        <actions>
            <name>ClicktoEmail_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>Email:</value>
        </criteriaItems>
        <description>updates the activity type to Email when click to email is used</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
