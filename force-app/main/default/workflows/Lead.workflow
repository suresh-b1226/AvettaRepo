<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Appointment_Status_Update</fullName>
        <description>Used to notify ADR that the Appointment Status field has been updated and action is required on the lead</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Emails_Templates/Appointment_Status_Update</template>
    </alerts>
    <alerts>
        <fullName>Demo_Schedule_Date_Field_has_Content_for_Selected_Account</fullName>
        <description>Demo Schedule Date Field on a LEAD has been changed for &lt;&lt;Lead&gt;&gt;</description>
        <protected>false</protected>
        <recipients>
            <recipient>mketchmere@picsauditing.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>msheppard@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ncarr@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sspencer@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Emails_Templates/Demo_Trigger_Alert_email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Contractor_Lead_Owner_to_Queue</fullName>
        <description>time bound ownership change</description>
        <field>OwnerId</field>
        <lookupValue>SER_3_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Contractor Lead Owner to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_MQL</fullName>
        <field>Date_MQL__c</field>
        <formula>today()</formula>
        <name>Date MQL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>From_Working_Contacted_to_Unresponsive</fullName>
        <description>changes status to Unresponsive from Working Contacted</description>
        <field>Status</field>
        <literalValue>UnResponsive</literalValue>
        <name>From Working Contacted to Unresponsive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Check_off_Sync_to_Marketo_box</fullName>
        <description>This rule automatically checks off the Sync to Marketo box when a new lead is created</description>
        <field>Sync_With_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>Lead: Check off Sync to Marketo box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Lifecycle_Update_to_SAL</fullName>
        <description>Updates the lead lifecycle status to SAL when an AE identifies the Demo Task as Qualified</description>
        <field>Lifecycle_Status__c</field>
        <literalValue>SAL</literalValue>
        <name>Lead Lifecycle Update to SAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Field_Sales_Convert</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_to_Stalled</fullName>
        <description>moves the status from Pending to stalled for contractors that have been pending more than 3 days</description>
        <field>Status</field>
        <literalValue>Stalled</literalValue>
        <name>Pending to Stalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change_from_Mailed_to_Open</fullName>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Status Change from Mailed to Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_with_Marketo_Field_True</fullName>
        <description>Sync to Marketo field check marked upon lead creation.</description>
        <field>Sync_With_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>Sync with Marketo Field True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Acocunt_Type</fullName>
        <field>Account_Type__c</field>
        <literalValue>Contractor</literalValue>
        <name>Update Acocunt Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Region</fullName>
        <description>This field is populated via a filed update based on Country</description>
        <field>Region3__c</field>
        <formula>CASE( Country, 
&quot;Australia&quot;, &quot;APAC&quot;,
&quot;AU&quot;, &quot;APAC&quot;,
&quot;Bangladesh&quot;, &quot;APAC&quot;,
&quot;Brunei Darussalam&quot;, &quot;APAC&quot;,
&quot;Cambodia&quot;, &quot;APAC&quot;,
&quot;China&quot;, &quot;APAC&quot;,
&quot;Fiji&quot;, &quot;APAC&quot;,
&quot;India&quot;, &quot;APAC&quot;,
&quot;Indonesia&quot;, &quot;APAC&quot;,
&quot;Japan&quot;, &quot;APAC&quot;,
&quot;Malaysia&quot;, &quot;APAC&quot;,
&quot;New Zealand&quot;, &quot;APAC&quot;,
&quot;Philippines&quot;, &quot;APAC&quot;,
&quot;Singapore&quot;, &quot;APAC&quot;,
&quot;Korea, Republic of&quot;, &quot;APAC&quot;,
&quot;Sri Lanka&quot;, &quot;APAC&quot;,
&quot;Chinese Taipei&quot;, &quot;APAC&quot;,
&quot;CHINA&quot;, &quot;APAC&quot;,
&quot;Thailand&quot;, &quot;APAC&quot;,
&quot;Viet Nam&quot;, &quot;APAC&quot;,
&quot;Vietnam&quot;, &quot;APAC&quot;,
&quot;Antigua and Barbuda&quot;, &quot;LATAM&quot;,
&quot;Argentina&quot;, &quot;LATAM&quot;,
&quot;Brazil&quot;, &quot;LATAM&quot;,
&quot;Chile&quot;, &quot;LATAM&quot;,
&quot;Colombia&quot;, &quot;LATAM&quot;,
&quot;Costa Rica&quot;, &quot;LATAM&quot;,
&quot;Cuba&quot;, &quot;LATAM&quot;,
&quot;Dominican Republic&quot;, &quot;LATAM&quot;,
&quot;Ecuador&quot;, &quot;LATAM&quot;,
&quot;Jamaica&quot;, &quot;LATAM&quot;,
&quot;Mexico&quot;, &quot;LATAM&quot;,
&quot;Nicaragua&quot;, &quot;LATAM&quot;,
&quot;Panama&quot;, &quot;LATAM&quot;,
&quot;Paraguay&quot;, &quot;LATAM&quot;,
&quot;Peru&quot;, &quot;LATAM&quot;,
&quot;Trinidad and Tobago&quot;, &quot;LATAM&quot;,
&quot;Uruguay&quot;, &quot;LATAM&quot;,
&quot;Venezuela, Bolivarian Republic of&quot;, &quot;LATAM&quot;,
&quot;Venezuela&quot;, &quot;LATAM&quot;,
&quot;United States&quot;, &quot;NORAM&quot;,
&quot;US&quot;, &quot;NORAM&quot;,
&quot;USA&quot;, &quot;NORAM&quot;,
&quot;U.S.A.&quot;, &quot;NORAM&quot;,
&quot;Bahamas&quot;, &quot;NORAM&quot;,
&quot;Bermuda&quot;, &quot;NORAM&quot;,
&quot;Canada&quot;, &quot;NORAM&quot;,
&quot;CA&quot;, &quot;NORAM&quot;,
&quot;Afghanistan&quot;, &quot;EMEA&quot;,
&quot;Albania&quot;, &quot;EMEA&quot;,
&quot;Azerbaijan&quot;, &quot;EMEA&quot;,
&quot;Bahrain&quot;, &quot;EMEA&quot;,
&quot;Belgium&quot;, &quot;EMEA&quot;,
&quot;Bulgaria&quot;, &quot;EMEA&quot;,
&quot;Croatia&quot;, &quot;EMEA&quot;,
&quot;Cyprus&quot;, &quot;EMEA&quot;,
&quot;Czech Republic&quot;, &quot;EMEA&quot;,
&quot;Denmark&quot;, &quot;EMEA&quot;,
&quot;Egypt&quot;, &quot;EMEA&quot;,
&quot;Ethiopia&quot;, &quot;EMEA&quot;,
&quot;France&quot;, &quot;EMEA&quot;,
&quot;GB&quot;, &quot;EMEA&quot;,
&quot;Ghana&quot;, &quot;EMEA&quot;,
&quot;Germany&quot;, &quot;EMEA&quot;,
&quot;Iran, Islamic Republic of&quot;, &quot;EMEA&quot;,
&quot;Ireland&quot;, &quot;EMEA&quot;,
&quot;Italy&quot;, &quot;EMEA&quot;,
&quot;Kenya&quot;, &quot;EMEA&quot;,
&quot;Kuwait&quot;, &quot;EMEA&quot;,
&quot;Poland&quot;, &quot;EMEA&quot;,
&quot;Romania&quot;, &quot;EMEA&quot;,
&quot;Qatar&quot;, &quot;EMEA&quot;,
&quot;Russian Federation&quot;, &quot;EMEA&quot;,
&quot;South Africa&quot;, &quot;EMEA&quot;,
&quot;Spain&quot;, &quot;EMEA&quot;,
&quot;Sweden&quot;, &quot;EMEA&quot;,
&quot;United Kingdom&quot;, &quot;EMEA&quot;,
&quot;United Arab Emirates&quot;, &quot;EMEA&quot;,
&quot;Zimbabwe&quot;, &quot;EMEA&quot;,
&quot;Zambia&quot;, &quot;EMEA&quot;,
&quot;NORAM&quot;)</formula>
        <name>Update Lead - Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Region_Value</fullName>
        <description>this will update the lead region value based upon the country identified in the address field</description>
        <field>Region2__c</field>
        <name>Update Lead Region Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Status</fullName>
        <description>When an activity is recorded this updates the lead status field to &quot;Working-Contacted&quot;</description>
        <field>Status</field>
        <literalValue>Working - Contacted</literalValue>
        <name>Update Lead Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_MQL_date_to_today</fullName>
        <field>MQL_Date__c</field>
        <formula>Today()</formula>
        <name>Update MQL date to today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Registered_Date</fullName>
        <field>Registered_Status_Date__c</field>
        <formula>Today()</formula>
        <name>Update Registered Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Activation_Type</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/oppwon</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>Registration_Type__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>msheppard@avetta.com</integrationUser>
        <name>Activation Type</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>IS_com_SER_One_Time_Close</fullName>
        <apiVersion>33.0</apiVersion>
        <description>sends msg to IS.com for one time revenue event when criteria aare met for leader board</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/one_time_rev</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>rsmith@picsauditing.com</integrationUser>
        <name>IS.com - SER One Time Close</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>New_Contractor_Activation</fullName>
        <apiVersion>31.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/one_time_rev</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>rsmith@picsauditing.com</integrationUser>
        <name>New Contractor Activation</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>SER_Live_Connection_Tracking</fullName>
        <apiVersion>32.0</apiVersion>
        <description>IS.com workflow to track live connections</description>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/corcntcts</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>rsmith@picsauditing.com</integrationUser>
        <name>SER Live Connection Tracking</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Field Sales to Field Sales Convert</fullName>
        <actions>
            <name>Lead_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Client_Pain__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Demo_Given_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When the Field Sales lead has the pain identified and the Demo Given date entered, updates the Record Type to be “Field Sales – Convert”.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IS%2Ecom - Contractor Activated</fullName>
        <actions>
            <name>New_Contractor_Activation</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contractor Mailing</value>
        </criteriaItems>
        <description>Rule to capture new contractor activations in KPI Dashboard</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IS%2Ecom - SER One Time Close</fullName>
        <actions>
            <name>IS_com_SER_One_Time_Close</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contractor Mailing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Registered</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Registration_Type__c</field>
            <operation>equals</operation>
            <value>Activation,Reactivation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Amount_Paid__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>intended to capture the transactions that are closed by the SER while on the phone with the contractor</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IS%2Ecom Registration Type</fullName>
        <actions>
            <name>Activation_Type</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Registration_Type__c</field>
            <operation>equals</operation>
            <value>Activation,Reactivation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Region Assignment</fullName>
        <actions>
            <name>Update_Lead_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Region_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Country</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>this rule assigns the region to a lead based  upon the country value in the address field.  leads are assigned to 4 primary regions: APAC, EMEA, LATAM, NORAM</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead to MQL status set MQL date to today</fullName>
        <actions>
            <name>Date_MQL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_MQL_date_to_today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>MQL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_MQL__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sync Leads to Marketo Checkmark</fullName>
        <actions>
            <name>Sync_with_Marketo_Field_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Field Sales,Field Sales,Field Sales - Convert,Contractor Mailing,Partner Referral,Partner Application</value>
        </criteriaItems>
        <description>Newly created Leads get an automatic checkmark of the field Sync to Marketo</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>A_Pending_Lead_has_Stalled</fullName>
        <assignedToType>owner</assignedToType>
        <description>Hey a contractor lead in Pending status has stalled, call them today.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>A Pending Lead has Stalled</subject>
    </tasks>
    <tasks>
        <fullName>X3_Day_Lead_Asking_For_Some_Attention</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please process this lead as soon as possible.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>3 Day Lead Asking For Some Attention</subject>
    </tasks>
</Workflow>
