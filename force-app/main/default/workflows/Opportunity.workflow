<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Auto_Upgrade_Opportunity_Email</fullName>
        <description>Auto Upgrade Opportunity Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Service/Auto_Upgrade_Opportunity_Email</template>
    </alerts>
    <alerts>
        <fullName>Client_Opp_Target_mail_date_IPM_expected_mail_date</fullName>
        <description>Client Opp - Target mail date &lt;&gt; IPM expected mail date</description>
        <protected>false</protected>
        <recipients>
            <recipient>jwebster@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ncarr@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Emails_Templates/Opp_mail_date_IPM_date</template>
    </alerts>
    <alerts>
        <fullName>Deal_Closed_Won_Mailed</fullName>
        <description>Deal Closed Won &amp; Mailed</description>
        <protected>false</protected>
        <recipients>
            <recipient>Deal_Won_Mailed</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opp_Automation_Emails/Close_Won_Deals</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Dennis_Truitt_on_Closed_Won</fullName>
        <description>New Client Win Announcement for Sales Management</description>
        <protected>false</protected>
        <recipients>
            <recipient>msheppard@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ncarr@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Emails_Templates/Closed_Won_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Alert_to_Create_PICS_Org_ID_and_Assign_CSM_Manager</fullName>
        <description>Opportunity Alert to Create PICS Org ID and Assign CSM Manager</description>
        <protected>false</protected>
        <recipients>
            <recipient>Global_Solutions_Consulting</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Legal_Email_Templates/Oppty_nego_alert_email</template>
    </alerts>
    <alerts>
        <fullName>Phase_1_10_day_Alert</fullName>
        <description>Phase 1 - 10 day Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>eolsen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mmacias@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>msheppard@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rsmith@picsauditing.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Legal_Email_Templates/Phase_1_10_day_Alert</template>
    </alerts>
    <alerts>
        <fullName>Phase_2_10_day_Alert</fullName>
        <description>Phase 2 - 10 day Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>eolsen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mmacias@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>msheppard@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rsmith@picsauditing.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Legal_Email_Templates/Phase_2_10_day_Alert</template>
    </alerts>
    <alerts>
        <fullName>Phase_2_15_day_Alert</fullName>
        <description>Phase 2 - 15 day Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>eolsen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mmacias@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>msheppard@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rsmith@picsauditing.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Legal_Email_Templates/Phase_2_15day_Alert</template>
    </alerts>
    <alerts>
        <fullName>Phase_3_10_day_Alert</fullName>
        <description>Phase 3 - 10 day Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>eolsen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mmacias@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>msheppard@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rsmith@picsauditing.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Legal_Email_Templates/Phase_3_10_day_Alert</template>
    </alerts>
    <alerts>
        <fullName>Phase_3_15_day_Alert</fullName>
        <description>Phase 3 - 15 day Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>eolsen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mmacias@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>msheppard@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rsmith@picsauditing.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Legal_Email_Templates/Phase_3_15_day_Alert</template>
    </alerts>
    <alerts>
        <fullName>Phase_I_Minus10_Day_Alert_Email_to_SER</fullName>
        <description>Phase I MINUS 10 Day Alert Email to SER</description>
        <protected>false</protected>
        <recipients>
            <recipient>eolsen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mmacias@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>msheppard@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rsmith@picsauditing.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Legal_Email_Templates/Phase_1_10_day_Alert</template>
    </alerts>
    <alerts>
        <fullName>Registration_Request_de_Email_Alert</fullName>
        <description>Registration Request - de (Email Alert)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opp_Automation_Emails/Registration_Request_de</template>
    </alerts>
    <alerts>
        <fullName>Registration_Request_en_Email_Alert</fullName>
        <description>Registration Request - en (Email Alert)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opp_Automation_Emails/Registration_Request_en</template>
    </alerts>
    <alerts>
        <fullName>Registration_Request_es_Email_Alert</fullName>
        <description>Registration Request - es (Email Alert)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opp_Automation_Emails/Registration_Request_es</template>
    </alerts>
    <alerts>
        <fullName>Registration_Request_fr_Email_Alert</fullName>
        <description>Registration Request - fr (Email Alert)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opp_Automation_Emails/Registration_Request_fr</template>
    </alerts>
    <alerts>
        <fullName>Registration_Request_fr_ca_Email_Alert</fullName>
        <description>Registration Request - fr_ca (Email Alert)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opp_Automation_Emails/Registration_Request_fr_ca</template>
    </alerts>
    <alerts>
        <fullName>Registration_Request_pt_Email_Alert</fullName>
        <description>Registration Request - pt (Email Alert)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opp_Automation_Emails/Registration_Request_pt</template>
    </alerts>
    <alerts>
        <fullName>Retention_Deactivation_Request_Received_Notification</fullName>
        <description>Retention Deactivation Request Received Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Retention_Team/X3_To_Be_Deactivated</template>
    </alerts>
    <alerts>
        <fullName>Supplier_Final_Attempt_Email</fullName>
        <description>Supplier Final Attempt Email</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>registrations@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Global_Supplier_Enablement_English/X3_3_Aged</template>
    </alerts>
    <fieldUpdates>
        <fullName>Amount_to_Total_Opp_value</fullName>
        <description>Updated opportunity &quot;Amount&quot; field to &quot;Total Opportunity&quot; value.</description>
        <field>Amount</field>
        <formula>Total_Opportunity_New__c</formula>
        <name>Amount to Total Opp value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dormant_Date_back_to_Null</fullName>
        <field>Dormant_Date__c</field>
        <name>Dormant Date back to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eligible_for_Deactivation</fullName>
        <field>Eligible_for_Deactivation__c</field>
        <literalValue>1</literalValue>
        <name>Eligible for Deactivation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forecasted_Total_Amount_New</fullName>
        <field>Forecasted_Total_Amount_New__c</field>
        <formula>Forecasted_Activation_Amount2__c + Forecasted_Upgrade_Amount__c + Client_Fee__c</formula>
        <name>Forecasted Total Amount New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Implementation_Complete_Date</fullName>
        <description>Updates the field, when the workflow evaluates to true</description>
        <field>Implementation_Complete_Date__c</field>
        <formula>Today()</formula>
        <name>Implementation Complete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Update_Description</fullName>
        <field>Description</field>
        <formula>IF( ISPICKVAL(Result__c,&quot;No Response&quot;), &quot;Multiple attempts have been made to help the supplier with registration for Avetta and no progress has been made.  A final contact email advising how to contact Avetta has been sent.&quot;, &quot;This supplier has been deemed out of scope by &quot;+Client_Account_Name__c+&quot; and is exempt from enrolling in Avetta at this time.&quot;)</formula>
        <name>Opportunity:Update Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_opportunity_close_date_Client_opp</fullName>
        <field>CloseDate</field>
        <formula>Now()+270</formula>
        <name>Set opportunity close date - Client opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Oppportunity_calculated</fullName>
        <field>Total_Opportunity_New__c</field>
        <formula>DocuGUARD_Rev__c + InsureGUARD_Rev__c + AuditGUARD_Rev__c + EmployeeGUARD_Rev__c + Registration_Fee_Rev_New__c + Client_Fee__c</formula>
        <name>Total Oppportunity calculated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amount_from_Total_Amt</fullName>
        <field>Amount</field>
        <formula>Total_Opportunity_New__c</formula>
        <name>Update Amount from Total Amt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bid_Given_Date</fullName>
        <description>Update Bid Given to today&apos;s date</description>
        <field>Bid_Given_Date__c</field>
        <formula>IF(
ISPICKVAL(PRIORVALUE(StageName),&quot;Bid Given&quot;) &amp;&amp; 
NOT(ISPICKVAL(StageName, &quot;Closed Lost&quot;) ) &amp;&amp; 
NOT( ISPICKVAL(StageName, &quot;Dormant&quot;) ) 
,TODAY(), Null
)</formula>
        <name>Update Bid Given Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Lost_Date_Field</fullName>
        <field>Closed_Lost_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Closed Lost Date Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_Negotiation_Date</fullName>
        <field>Contract_Negotiation_Date__c</field>
        <formula>IF(
ISPICKVAL(PRIORVALUE(StageName),&quot;Contract Negotiation&quot;) &amp;&amp;
NOT(ISPICKVAL(StageName, &quot;Closed Lost&quot;) ) &amp;&amp;
NOT( ISPICKVAL(StageName, &quot;Dormant&quot;) )
,TODAY(), Null
)</formula>
        <name>Update Contract Negotiation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_Signed_Date_Field</fullName>
        <field>Contract_Siged_Date__c</field>
        <formula>IF(
ISPICKVAL(PRIORVALUE(StageName),&quot;Contract Signed&quot;) &amp;&amp;
NOT(ISPICKVAL(StageName, &quot;Closed Lost&quot;) ) &amp;&amp;
NOT( ISPICKVAL(StageName, &quot;Dormant&quot;) )
,TODAY(), Null
)</formula>
        <name>Update Contract Signed Date Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contractors_Forecast</fullName>
        <field>TotalOpportunityQuantity</field>
        <formula>Number_of_Contractors__c</formula>
        <name>Update Quantity (Forecast)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dormant_Date_field</fullName>
        <field>Dormant_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Dormant Date field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Eligible_for_Deactivation</fullName>
        <field>Eligible_for_Deactivation__c</field>
        <literalValue>1</literalValue>
        <name>Update Eligible for Deactivation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Follow_Up_Field</fullName>
        <field>Follow_Up_Date__c</field>
        <formula>CASE(
Follow_Up__c , 
&quot;1 Month&quot;,  TODAY()  + 30,
&quot;2 Months&quot;, TODAY()  + 60,
&quot;3 Months&quot;, TODAY()  + 90, 
&quot;4 Months&quot;, TODAY()  + 120,
&quot;5 Months&quot;, TODAY()  + 150,
&quot;6 Months&quot;, TODAY()  + 180,
&quot;7 Months&quot;, TODAY()  + 210,
&quot;8 Months&quot;, TODAY()  + 240,
&quot;9 Months&quot;, TODAY()  + 270,
&quot;10 Months&quot;, TODAY()  + 300,
&quot;11 Months&quot;, TODAY()  + 330,
&quot;12 Months&quot;, TODAY()  + 360,
TODAY()+ 270

)</formula>
        <name>Update Follow Up Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Implemented_Date</fullName>
        <field>Implementation_Kick_Off_Meeting_Date__c</field>
        <formula>Today()</formula>
        <name>Update Implemented Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Mailed</fullName>
        <field>Mailed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Mailed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Email_1</fullName>
        <field>Send_Email_1__c</field>
        <formula>now()</formula>
        <name>Update Send Email 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Email_2</fullName>
        <field>Send_Email_2__c</field>
        <formula>Now()</formula>
        <name>Update Send Email 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Email_3</fullName>
        <field>Send_Email_3__c</field>
        <formula>now()</formula>
        <name>Update Send Email 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Email_4</fullName>
        <field>Send_Email_4__c</field>
        <formula>Now()</formula>
        <name>Update Send Email 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Start_Automated_Email_Send</fullName>
        <field>Start_Automated_Email_Send__c</field>
        <formula>Datetimevalue(Text(TODAY() +
CASE(
MOD( TODAY() - DATE(1900, 1, 7), 7),
5, 3,
6, 2,
1)) &amp; &quot; &quot; &amp; &quot;13:13:00&quot;)</formula>
        <name>Update Start Automated Email Send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Start_Deact_Saves_Send_Email</fullName>
        <field>Start_Saves_Deactivation_Email_Send__c</field>
        <formula>now()</formula>
        <name>Update Start Deact Saves Send Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verbal_Commit_Update</fullName>
        <description>Record Verbal Commit Date as Today when the stage is left (and not Close Lost)</description>
        <field>Verbal_Commit_Date__c</field>
        <formula>IF(
ISPICKVAL(PRIORVALUE(StageName),&quot;Verbal Commitment&quot;) &amp;&amp; 
NOT(ISPICKVAL(StageName, &quot;Closed Lost&quot;) )  &amp;&amp; 
NOT( ISPICKVAL(StageName, &quot;Dormant&quot;) ) 
,TODAY(), Null
)</formula>
        <name>Verbal Commit Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Clear Dormant Date</fullName>
        <actions>
            <name>Dormant_Date_back_to_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When PreviousValue(Opportunity Stage) = Closed - Marketing Nurture, populate “Dormant Date” with “” (blank it out when the opportunity is moved out of Dormant stage</description>
        <formula>IF( ISPICKVAL(PRIORVALUE(StageName),&quot;Closed - Marketing Nurture&quot;),  True, False  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contract Negotiation Populate</fullName>
        <actions>
            <name>Update_Contract_Negotiation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Negotiation_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Negotiating</value>
        </criteriaItems>
        <description>When the opportunity moves into Negotiating statge, populate the “Contract Negotiation Date” with today()</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Eligible Deactivation Request - Time Based</fullName>
        <active>false</active>
        <description>--Replaced by batch Apex-- Indicates to the Retention team that a deactivation request is eligible for deactivation  Within 30 days of renewal, or renewed within the last 14 days. Time Based for those who request more than 30 days before Term Start Date.</description>
        <formula>AND(IF(DateValue(CreatedDate) &lt; Term_Start_Date__c - 30,True,False), RecordType.DeveloperName = &quot;Retention&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Eligible_for_Deactivation</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Term_Start_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Implemented Date</fullName>
        <actions>
            <name>Update_Implemented_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Implementation_Stage__c</field>
            <operation>equals</operation>
            <value>Implementation Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Initial Population of Quantity</fullName>
        <actions>
            <name>Update_Contractors_Forecast</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Bid Given Field</fullName>
        <actions>
            <name>Update_Bid_Given_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the stage moves to Preparing, populate the bid given date.</description>
        <formula>AND(
ISBLANK( Bid_Given_Date__c),  
ISPICKVAL(StageName, &quot;Preparing&quot;)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Saves Deactivation%3A Start Saves Deactivation Send Email</fullName>
        <actions>
            <name>Update_Start_Deact_Saves_Send_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Eligible_for_Deactivation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Start_Saves_Deactivation_Email_Send__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Retention</value>
        </criteriaItems>
        <description>On a &apos;retention&apos; opty -&gt; If the eligible for deactivation checkbox is checked -&gt; update the &apos;start saves deactivation send email&apos; field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Implementation Complete Date</fullName>
        <actions>
            <name>Implementation_Complete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Implementation_Meeting_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set default close date on client opps</fullName>
        <actions>
            <name>Set_opportunity_close_date_Client_opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Task for Opp Follow Up %28Dormant%29</fullName>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Follow_Up_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed - Marketing Nurture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Competitor_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Task to follow up on dormant .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Follow_Up_With_Opportunity</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.Follow_Up_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Tasks at Contract Negotiation Stage</fullName>
        <actions>
            <name>Assign_an_Account_Manager</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Prep_the_Account_Setup</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Negotiating</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Close Lost Date</fullName>
        <actions>
            <name>Update_Closed_Lost_Date_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed - Lost to Competitor</value>
        </criteriaItems>
        <description>When Opportunity Stage = Closed - Lost to Competitor, populate “Closed Lost Date” with today()</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Dormant Date</fullName>
        <actions>
            <name>Update_Dormant_Date_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed - Marketing Nurture</value>
        </criteriaItems>
        <description>When Opportunity Stage = Closed - Marketing Nurture, populate “Closed Lost Date” with today()</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Follow Up Date</fullName>
        <actions>
            <name>Update_Follow_Up_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Follow_Up__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Total Opp Amount</fullName>
        <actions>
            <name>Forecasted_Total_Amount_New</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Total_Oppportunity_calculated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Amount_from_Total_Amt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client</value>
        </criteriaItems>
        <description>Updates Total Opp and Total Forecasted Opp Amounts</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Assign_an_Account_Manager</fullName>
        <assignedTo>bspencer@avetta.com.dev1</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please assign and account manager for this opportunity that has entered the Contract Negotiation stage.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Assign an Account Manager</subject>
    </tasks>
    <tasks>
        <fullName>Complete_the_Account_Setup</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please complete the account setup for this opportunity.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Complete the Account Setup</subject>
    </tasks>
    <tasks>
        <fullName>Email_Supplier_Final_Attempt</fullName>
        <assignedTo>integration@avetta.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email: Supplier Final Attempt</subject>
    </tasks>
    <tasks>
        <fullName>Follow_Up_With_Opportunity</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please follow up with this opportunity.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Follow_Up_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow Up With Opportunity</subject>
    </tasks>
    <tasks>
        <fullName>Prep_the_Account_Setup</fullName>
        <assignedTo>Global_Solutions_Consulting</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Please start preparing the account setup for this opportunity.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Prep the Account Setup</subject>
    </tasks>
</Workflow>
