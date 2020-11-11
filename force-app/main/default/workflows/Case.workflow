<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Annual_Update_Submitted</fullName>
        <description>Annual Update Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Annual_Update_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Avetta</fullName>
        <description>Audit -  Notice for Waiting on Avetta</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs_FINAL_Waiting_on_Supplier</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Avetta_Dutch</fullName>
        <description>Audit -  Notice for Waiting on Avetta -  Dutch</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Documents_Supplied_for_Review_Waiting_on_Avetta_Dutch</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Avetta_Finnish</fullName>
        <description>Audit -  Notice for Waiting on Avetta -  Finnish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Documents_Supplied_for_Review_Waiting_on_Avetta_Finnish</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Avetta_French</fullName>
        <description>Audit -  Notice for Waiting on Avetta -  French</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Documents_Supplied_for_Review_Waiting_on_Avetta_French</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Avetta_German</fullName>
        <description>Audit -  Notice for Waiting on Avetta -  German</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Documents_Supplied_for_Review_Waiting_on_Avetta_German</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Avetta_Portuguese</fullName>
        <description>Audit -  Notice for Waiting on Avetta -  Portuguese</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Documents_Supplied_for_Review_Waiting_on_Avetta_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Avetta_Spanish</fullName>
        <description>Audit -  Notice for Waiting on Avetta -  Spanish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Documents_Supplied_for_Review_Waiting_on_Avetta_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Avetta_Swedish</fullName>
        <description>Audit -  Notice for Waiting on Avetta -  Swedish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Documents_Supplied_for_Review_Waiting_on_Avetta_Swedish</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Supplier_Dutch</fullName>
        <description>Audit - Notice for Waiting on Supplier - Dutch</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs_FINAL_Waiting_on_Supplier_Dutch</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Supplier_Finnish</fullName>
        <description>Audit - Notice for Waiting on Supplier - Finnish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs_FINAL_Waiting_on_Supplier_Finnish</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Supplier_French</fullName>
        <description>Audit - Notice for Waiting on Supplier - French</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs_FINAL_Waiting_on_Supplier_French</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Supplier_German</fullName>
        <description>Audit - Notice for Waiting on Supplier - German</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs_FINAL_Waiting_on_Supplier_German</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Supplier_Portuguese</fullName>
        <description>Audit - Notice for Waiting on Supplier - Portuguese</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs_FINAL_Waiting_on_Supplier_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Supplier_Spanish</fullName>
        <description>Audit - Notice for Waiting on Supplier - Spanish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs_FINAL_Waiting_on_Supplier_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_for_Waiting_on_Supplier_Swedish</fullName>
        <description>Audit - Notice for Waiting on Supplier - Swedish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs_FINAL_Waiting_on_Supplier_Swedish</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_of_Case_Closure</fullName>
        <description>Audit - Notice of Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Completed_FINAL</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_of_Case_Closure_Dutch</fullName>
        <description>Audit - Notice of Case Closure - Dutch</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Completed_FINAL_Closed_Dutch</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_of_Case_Closure_Finnish</fullName>
        <description>Audit - Notice of Case Closure - Finnish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Completed_FINAL_Closed_Finnish</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_of_Case_Closure_French</fullName>
        <description>Audit - Notice of Case Closure - French</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Completed_FINAL_Closed_French</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_of_Case_Closure_German</fullName>
        <description>Audit - Notice of Case Closure - German</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Completed_FINAL_Closed_German</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_of_Case_Closure_Portuguese</fullName>
        <description>Audit - Notice of Case Closure - Portuguese</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Completed_FINAL_Closed_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_of_Case_Closure_Spanish</fullName>
        <description>Audit - Notice of Case Closure - Spanish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Completed_FINAL_Closed_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Audit_Notice_of_Case_Closure_Swedish</fullName>
        <description>Audit - Notice of Case Closure - Swedish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Completed_FINAL_Closed_Swedish</template>
    </alerts>
    <alerts>
        <fullName>CASE_UPDATE_ALERT</fullName>
        <description>Case update alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Emails_Templates/Case_Updated_Custom</template>
    </alerts>
    <alerts>
        <fullName>CS_Outreach_Voicemail_Email</fullName>
        <description>CS Outreach Voicemail Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AU_and_IG_Auto_Emails/Annual_Update</template>
    </alerts>
    <alerts>
        <fullName>Case_Closure_Due_to_Inactivity</fullName>
        <description>Case Closure Due to Inactivity</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Case_Close_Warning_for_Inactivity</template>
    </alerts>
    <alerts>
        <fullName>Case_Test_for_above</fullName>
        <description>Alert Owner of Case that Case was CLOSED</description>
        <protected>false</protected>
        <recipients>
            <recipient>ncarr@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sdameron@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Legal_Email_Templates/CaseChangedprocessblder</template>
    </alerts>
    <alerts>
        <fullName>Client_Billing_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Client Billing Critcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cbuchanan@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Client_Case_Received_Notification</fullName>
        <description>Client: Case Received Notification</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/CS_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Client_Support_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Client Support Critcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jvillaverde@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Data_Quality_Waiting_on_Suppler_email</fullName>
        <description>Data Quality Waiting on Suppler email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>suppliersuccess@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Data_Quality_Classic_Email_Templates/Data_Quality_General_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Email_CaseAssigned</fullName>
        <description>Send email when a case owner is changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Emails_Templates/Case_Assigned_to_You</template>
    </alerts>
    <alerts>
        <fullName>Email_notication_to_Brett_of_case_creation</fullName>
        <description>Email notication to Brett of case creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nbangerter@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Organizer_Issues_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Other_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Other Critcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Product_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Product Critcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mmina@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Reporting_User_Responded_Alert</fullName>
        <description>Email alert to follow up with SF Team case owners</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Emails_Templates/Reporting_User_Responded</template>
    </alerts>
    <alerts>
        <fullName>Resolved_Client_Billing_Critical_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Resolved Client Billing Critical Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cbuchanan@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Resolved_Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Resolved_Client_Support_Critical_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Resolved Client Support Critical Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jvillaverde@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Resolved_Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Resolved_Other_Critical_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Resolved Other Critical Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Resolved_Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Resolved_Product_Critical_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Resolved Product Critical Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mmina@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Resolved_Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Resolved_Supplier_Billing_Critical_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Resolved Supplier Billing Critical Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>atiso@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Resolved_Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Resolved_Supplier_Sales_Critical_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Resolved Supplier Sales Critical Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eolsen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Resolved_Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Resolved_Supplier_Support_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Resolved Supplier Support Critcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jjensen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Resolved_Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Resolved_Worker_Management_Critical_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Resolved Worker Management Critical Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jitesh.chanchani@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Resolved_Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>SF_Case_Denied_Email_Alert</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>SF - Case Denied Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Reporting_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SF_Team_Templates/Denied_Case_Email</template>
    </alerts>
    <alerts>
        <fullName>SF_Closed_Case_Email_Alert</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>SF - Closed Case Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Reporting_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SF_Team_Templates/Closed_Case_Email</template>
    </alerts>
    <alerts>
        <fullName>SF_Deployed_ticket</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>SF - Deployed ticket</description>
        <protected>false</protected>
        <recipients>
            <field>Reporting_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SF_Team_Templates/Deployment_email</template>
    </alerts>
    <alerts>
        <fullName>SF_Ticket_Ready_for_UAT</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>SF - Ticket Ready for UAT</description>
        <protected>false</protected>
        <recipients>
            <field>Reporting_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SF_Team_Templates/Ready_for_UAT_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Customer_Email_on_Creation_of_Case_when_case_origin_is_Voicemail</fullName>
        <description>Send Customer Email on Creation of Case when case origin is Voicemail</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Case_Created_from_Voicemail</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_waiting_on_supplier</fullName>
        <description>Send email when waiting on supplier for additional documentation.</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>audits@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AuditGuard/Audits_Open_Reqs</template>
    </alerts>
    <alerts>
        <fullName>Supplier_Billing_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Supplier BillingCritcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>atiso@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Supplier_Case_received_notification</fullName>
        <description>Supplier: Case received notification</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/CS_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Supplier_Sales_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Supplier Sales Critcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eolsen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Supplier_Support_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Supplier Support Critcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jjensen@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>Used_for_Lafarge_CS_Outreach</fullName>
        <description>Used for Lafarge CS Outreach</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/CS_Outreach_Lafarge</template>
    </alerts>
    <alerts>
        <fullName>Worker_Management_Critcal_Case</fullName>
        <ccEmails>salesforcesupport@avetta.com</ccEmails>
        <description>Worker Management Critcal Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>bspencer@avetta.com.dev1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jitesh.chanchani@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pedro.ortiz@avetta.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcesupport@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/Critical_Complaint_Case</template>
    </alerts>
    <alerts>
        <fullName>X3x_Rejection_AU_IG</fullName>
        <description>3x Rejection - AU/IG</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>notifications@avetta.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Service/X3x_Rejection_AU_IG</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_to_EmployeeGuard_Queue</fullName>
        <description>Rule to assign cases of type EmployeeGuard to the EmployeeGuard queue.</description>
        <field>OwnerId</field>
        <lookupValue>EmployeeGUARD</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to EmployeeGuard Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_set_client_queue</fullName>
        <description>For community client cases set the owner to client cases queue.</description>
        <field>OwnerId</field>
        <lookupValue>Client_Case_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case set client queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_set_supplier_queue</fullName>
        <description>This action sets the case owner to the avetta support (supplier) queue.</description>
        <field>OwnerId</field>
        <lookupValue>Avetta_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case set supplier queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Deactivation_Cases</fullName>
        <description>Closes Deactivation Cases</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Deactivation Cases</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sent_Survey</fullName>
        <field>Supplier_Transactional_Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Sent Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_JIRA_Link</fullName>
        <field>JIRA_Link__c</field>
        <formula>&quot;https://picsauditing.jira.com/browse/&quot; +  JIRA_Ticket__c</formula>
        <name>Update JIRA Link</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Email_1</fullName>
        <description>Updates the date and time for the send email 1 field for use in vetify email automation triggers Dallin&apos;s class.</description>
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
        <description>Populates the send email 2 date/time field.</description>
        <field>Send_Email_2__c</field>
        <formula>now()</formula>
        <name>Update Send Email 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Email_3</fullName>
        <description>Populates the send email 3 field.</description>
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
        <description>Populates the send email 4 field.</description>
        <field>Send_Email_4__c</field>
        <formula>now()</formula>
        <name>Update Send Email 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Email_5</fullName>
        <description>Populates the send email 5 date/time field.</description>
        <field>Send_Email_5__c</field>
        <formula>now()</formula>
        <name>Update Send Email 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sent_Checkbox</fullName>
        <field>Supplier_Transactional_Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Sent Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Checkbox</fullName>
        <description>Anytime this workflow runs it will update the a checkbox on the case to prevent additional surveys from being sent.</description>
        <field>Supplier_Transactional_Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_owner_to_CSR_Netscribes_QA</fullName>
        <field>OwnerId</field>
        <lookupValue>Data_Quality</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update case owner to CSR: Netscribes QA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_type_to_CS</fullName>
        <field>Type</field>
        <literalValue>CS</literalValue>
        <name>Update type to CS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Auditing_Survey</fullName>
        <apiVersion>49.0</apiVersion>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_5iosMfaiOo07odn&amp;u=UR_8qfeQyrVJ0piaVv&amp;t=OC_2YL0mNHIL1BgPYc&amp;b=avetta</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Organizer_ID__c</fields>
        <fields>Account_Region__c</fields>
        <fields>Billing_country_from_account__c</fields>
        <fields>CaseNumber</fields>
        <fields>ClosedDate</fields>
        <fields>ContactEmail</fields>
        <fields>ContactId</fields>
        <fields>ContactPhone</fields>
        <fields>Id</fields>
        <fields>Origin</fields>
        <fields>OwnerId</fields>
        <fields>Owner_Role__c</fields>
        <fields>Owner_full_name__c</fields>
        <fields>Subject</fields>
        <fields>Vetify__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>pedro.ortiz@avetta.com</integrationUser>
        <name>Auditing Survey</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Brazil_Supplier_Transaction_Survey</fullName>
        <apiVersion>48.0</apiVersion>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_9HNWpJR6O98uBut&amp;u=UR_8qfeQyrVJ0piaVv&amp;t=OC_3DoLTNkNS7oenaX&amp;b=avetta</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Organizer_ID__c</fields>
        <fields>Account_Region__c</fields>
        <fields>Billing_country_from_account__c</fields>
        <fields>CaseNumber</fields>
        <fields>ClosedDate</fields>
        <fields>ContactEmail</fields>
        <fields>ContactId</fields>
        <fields>ContactPhone</fields>
        <fields>Id</fields>
        <fields>Origin</fields>
        <fields>OwnerId</fields>
        <fields>Owner_Role__c</fields>
        <fields>Vetify__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>tgarcia@avetta.com</integrationUser>
        <name>Brazil Supplier Transaction Survey</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Service_Recovery_Call_Survey</fullName>
        <apiVersion>47.0</apiVersion>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_dn8M82Gi1gwiBY9&amp;u=UR_8qfeQyrVJ0piaVv&amp;t=OC_3iwzW8xhniG1YYm&amp;b=avetta</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Organizer_ID__c</fields>
        <fields>Account_Region__c</fields>
        <fields>Billing_country_from_account__c</fields>
        <fields>CaseNumber</fields>
        <fields>ClosedDate</fields>
        <fields>ContactEmail</fields>
        <fields>ContactId</fields>
        <fields>ContactPhone</fields>
        <fields>Id</fields>
        <fields>Origin</fields>
        <fields>OwnerId</fields>
        <fields>Owner_Role__c</fields>
        <fields>Owner_full_name__c</fields>
        <fields>Vetify__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>qualtricsuser@avetta.com</integrationUser>
        <name>Service Recovery Call Survey</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Service_Recovery_OB</fullName>
        <apiVersion>48.0</apiVersion>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_dn8M82Gi1gwiBY9&amp;u=UR_8qfeQyrVJ0piaVv&amp;t=OC_1N3PIJXxcGnpC1y&amp;b=avetta</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Organizer_ID__c</fields>
        <fields>Account_Region__c</fields>
        <fields>Billing_country_from_account__c</fields>
        <fields>CaseNumber</fields>
        <fields>ClosedDate</fields>
        <fields>ContactEmail</fields>
        <fields>ContactId</fields>
        <fields>ContactPhone</fields>
        <fields>Id</fields>
        <fields>Origin</fields>
        <fields>OwnerId</fields>
        <fields>Owner_Role__c</fields>
        <fields>Owner_full_name__c</fields>
        <fields>Vetify__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>tgarcia@avetta.com</integrationUser>
        <name>Service Recovery OB</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Spanish_Supplier_Transaction_Survey</fullName>
        <apiVersion>48.0</apiVersion>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_cHecNAYXiWz8AYt&amp;u=UR_8qfeQyrVJ0piaVv&amp;t=OC_2gykU6QTQK31xqJ&amp;b=avetta</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Organizer_ID__c</fields>
        <fields>Account_Region__c</fields>
        <fields>Billing_country_from_account__c</fields>
        <fields>CaseNumber</fields>
        <fields>ClosedDate</fields>
        <fields>ContactEmail</fields>
        <fields>ContactId</fields>
        <fields>ContactPhone</fields>
        <fields>Id</fields>
        <fields>Origin</fields>
        <fields>OwnerId</fields>
        <fields>Owner_Role__c</fields>
        <fields>Owner_full_name__c</fields>
        <fields>Vetify__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>tgarcia@avetta.com</integrationUser>
        <name>Spanish Supplier Transaction Survey</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Supplier_Transaction_Survey</fullName>
        <apiVersion>46.0</apiVersion>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_bvVf8Wk7jhgod9j&amp;u=UR_8qfeQyrVJ0piaVv&amp;t=OC_aeNiksCidJft92p&amp;b=avetta</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Organizer_ID__c</fields>
        <fields>Account_Region__c</fields>
        <fields>Billing_country_from_account__c</fields>
        <fields>CaseNumber</fields>
        <fields>ClosedDate</fields>
        <fields>ContactEmail</fields>
        <fields>ContactId</fields>
        <fields>ContactPhone</fields>
        <fields>Id</fields>
        <fields>Origin</fields>
        <fields>OwnerId</fields>
        <fields>Owner_Role__c</fields>
        <fields>Owner_full_name__c</fields>
        <fields>Vetify__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>tgarcia@avetta.com</integrationUser>
        <name>Supplier Transaction Survey</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Vetify_Survey</fullName>
        <apiVersion>48.0</apiVersion>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_6z2JlWqsPlVXSxD&amp;u=UR_8qfeQyrVJ0piaVv&amp;t=OC_24edHnwBh7inH8t&amp;b=avetta</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Organizer_ID__c</fields>
        <fields>Account_Region__c</fields>
        <fields>Billing_country_from_account__c</fields>
        <fields>CaseNumber</fields>
        <fields>ClosedDate</fields>
        <fields>ContactEmail</fields>
        <fields>ContactId</fields>
        <fields>ContactPhone</fields>
        <fields>Id</fields>
        <fields>Origin</fields>
        <fields>OwnerId</fields>
        <fields>Owner_Role__c</fields>
        <fields>Owner_full_name__c</fields>
        <fields>Vetify__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>tgarcia@avetta.com</integrationUser>
        <name>Vetify Survey</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>60 Day Verify auto close</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Send_Email_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vetify</value>
        </criteriaItems>
        <description>Close Verify Cases 60 Days after first email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Case</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Send_Email_1__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Auditing Support Survey</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Auditing_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Created to send outbound messages to Qualtrics for manual audit cases.</description>
        <formula>AND( 				
	   NOT(ISBLANK(ContactId)),
				NOT(ISBLANK( Contact.Email)),
    IsClosed = True,	
				RecordTypeId = &quot;0120g0000009tWm&quot;, /*Connect*/ 				 
    ISPICKVAL(Type, &apos;auditGuard&apos;)				
			/*	OR( 
					  Account.BillingCountry = &apos;GB&apos;, 
							Account.BillingCountry = &apos;UK&apos;, 
							Account.BillingCountry = &apos;CA&apos;, 
							Account.BillingCountry = &apos;AU&apos;, 
							Account.BillingCountry = &apos;US&apos;, 
							Account.BillingCountry = &apos;USA&apos;, 
							Account.BillingCountry = &apos;United States&apos;, 
							Account.BillingCountry = &apos;Canada&apos;, 
							Account.BillingCountry = &apos;United Kingdom&apos;, 
							Account.BillingCountry = &apos;Australia&apos; 
				) 	*/	
			)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Auditing Support Survey Simple</fullName>
        <actions>
            <name>Update_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Auditing_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <description>Created to send outbound messages to Qualtrics for manual audit cases.</description>
        <formula>AND( 				ISPICKVAL(Status, &quot;Closed&quot;), 				 
				RecordTypeId = &quot;0120g0000009tWm&quot;, /*Connect*/ 				 
				CONTAINS(Subject, &quot;Manual Audit&quot;),
				Safety_Manual_Comment__c = &apos;Pedro Ortiz&apos; 
				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Auto Close IG case</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Valid_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Connect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>insureGuard</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Case</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Valid_End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Brazil Supplier Transactional Survey</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Brazil_Supplier_Transaction_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF(   				AND(   								NOT(ISNULL(ContactId)),   								Contact.Account.No_Marketing_to_this_Acct__c = FALSE, 								Supplier_Transactional_Survey_Sent__c = FALSE,  								NOT(ISNULL(AccountId)),  /*Contractor*/   								Account.RecordTypeId = &apos;01270000000MRzn&apos;,   								Account.No_Marketing_to_this_Acct__c = FALSE,   								ISPICKVAL(Account.Status__c, &apos;Active&apos;),  								Account.BillingCountry = &apos;BR&apos;, 								ISPICKVAL(Status, &apos;Closed&apos;),   								OR( 												RIGHT(CaseNumber, 1)= &apos;1&apos;, 												RIGHT(CaseNumber, 1)= &apos;3&apos;, 												RIGHT(CaseNumber, 1)= &apos;5&apos;, 												RIGHT(CaseNumber, 1)= &apos;7&apos;, 												RIGHT(CaseNumber, 1)= &apos;9&apos;), 								NOT(ISPICKVAL(Type, &apos;Account Change&apos;)),   								NOT(ISPICKVAL(Type, &apos;Billing&apos;)),   								NOT(ISPICKVAL(Type, &apos;Deactivation&apos;)), NOT(ISPICKVAL(Type, &apos;Chat - No Response&apos;)),   			NOT(ISPICKVAL(Type, &apos;Organizer System&apos;)),   								NOT(ISPICKVAL(Type, &apos;Finish Line&apos;)),   								NOT(ISPICKVAL(Sub_Type__c, &apos;CS Outreach&apos;)),   								NOT(ISPICKVAL(Sub_Type__c, &apos;Welcome Call/Email&apos;)),   								NOT(ISPICKVAL(Sub_Type__c, &apos;Chat - No Response&apos;)), NOT(ISPICKVAL(Resolution__c, &apos;Unable to Contact&apos;)), NOT(ISPICKVAL(Resolution__c, &apos;Voicemail&apos;)),   /*Supplier*/  								RecordTypeId = &apos;01270000000cebI&apos; ),  TRUE, FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Brazil Supplier Transactional Survey %28Increased Frequency%29</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Brazil_Supplier_Transaction_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Created for 02613976</description>
        <formula>IF(   				 				AND( 								Owner:User.Increased_Survey_Frequency__c = TRUE, 								NOT(ISNULL(ContactId)), 								Contact.Account.No_Marketing_to_this_Acct__c = FALSE, 								Supplier_Transactional_Survey_Sent__c = FALSE, 								NOT(ISNULL(AccountId)), 								/*Contractor*/Account.RecordTypeId = &apos;01270000000MRzn&apos;, 								Account.No_Marketing_to_this_Acct__c = FALSE, 								ISPICKVAL(Account.Status__c, &apos;Active&apos;), 								Account.BillingCountry = &apos;BR&apos;, 								ISPICKVAL(Status, &apos;Closed&apos;), 								OR( 												 												RIGHT(CaseNumber, 1)= &apos;2&apos;, 												RIGHT(CaseNumber, 1)= &apos;6&apos;), 								NOT(ISPICKVAL(Type, &apos;Account Change&apos;)), 								NOT(ISPICKVAL(Type, &apos;Billing&apos;)), 								NOT(ISPICKVAL(Type, &apos;Deactivation&apos;)), 								NOT(ISPICKVAL(Type, &apos;Chat - No Response&apos;)), 								NOT(ISPICKVAL(Type, &apos;Organizer System&apos;)), 								NOT(ISPICKVAL(Type, &apos;Finish Line&apos;)), 								NOT(ISPICKVAL(Sub_Type__c, &apos;CS Outreach&apos;)), 								NOT(ISPICKVAL(Sub_Type__c, &apos;Welcome Call/Email&apos;)), 								NOT(ISPICKVAL(Sub_Type__c, &apos;Chat - No Response&apos;)), 								NOT(ISPICKVAL(Resolution__c, &apos;Unable to Contact&apos;)), 								NOT(ISPICKVAL(Resolution__c, &apos;Voicemail&apos;)), 								/*Supplier*/RecordTypeId = &apos;01270000000cebI&apos; ), 				TRUE, 				FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Community Client Case</fullName>
        <actions>
            <name>Client_Case_Received_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_set_client_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Community</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>This workflow will assign client community cases to the appropriate queue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Community Supplier Case</fullName>
        <actions>
            <name>Supplier_Case_received_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_set_supplier_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Community</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Supplier</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Assigns community supplier cases to the avetta support queue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EmployeeGuard</fullName>
        <actions>
            <name>Assign_to_EmployeeGuard_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>EmployeeGUARD</value>
        </criteriaItems>
        <description>Assigns any cases of type EmployeeGUARD to the EmployeeGUARD queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Organizer Issue Case Notification</fullName>
        <actions>
            <name>Email_notication_to_Brett_of_case_creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Organizer System Issue</value>
        </criteriaItems>
        <description>Used to notify Brett when a supplier Organizer issue case is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service Recovery Survey</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Service_Recovery_OB</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF(  				AND(  								NOT(ISNULL(ContactId)),  								Contact.Account.No_Marketing_to_this_Acct__c = FALSE,  								Supplier_Transactional_Survey_Sent__c = FALSE,  								NOT(ISNULL(AccountId)), /*Contractor*/ Account.RecordTypeId = &apos;01270000000MRzn&apos;,  								Account.No_Marketing_to_this_Acct__c = FALSE,  								ISPICKVAL(Account.Status__c, &apos;Active&apos;),  								Account.BillingState != &apos;Quebec&apos;,  								Account.BillingState != &apos;QC&apos;,  								Account.BillingState != &apos;Québec&apos;,  								OR(Account.BillingCountry = &apos;GB&apos;,  											Account.BillingCountry = &apos;UK&apos;,  											Account.BillingCountry = &apos;CA&apos;,  											Account.BillingCountry = &apos;AU&apos;,  											Account.BillingCountry = &apos;US&apos;,  											Account.BillingCountry = &apos;USA&apos;,  											Account.BillingCountry = &apos;United States&apos;,  											Account.BillingCountry = &apos;Canada&apos;,  											Account.BillingCountry = &apos;United Kingdom&apos;,  											Account.BillingCountry = &apos;Australia&apos;),  								ISPICKVAL(Status, &apos;Closed&apos;),  								ISPICKVAL(Resolution__c, &apos;Resolved&apos;),	  								RecordTypeId = &apos;0120g000000UTq6&apos; ), TRUE, FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Spanish Supplier Transactional Survey</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Spanish_Supplier_Transaction_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF(   				AND(   								NOT(ISNULL(ContactId)),   								Contact.Account.No_Marketing_to_this_Acct__c = FALSE,   								Supplier_Transactional_Survey_Sent__c = FALSE,   								NOT(ISNULL(AccountId)),  /*Contractor*/   								Account.RecordTypeId = &apos;01270000000MRzn&apos;,   								Account.No_Marketing_to_this_Acct__c = FALSE,   								ISPICKVAL(Account.Status__c, &apos;Active&apos;),  																OR(Account.BillingCountry = &apos;GT&apos;, 																			Account.BillingCountry = &apos;HN&apos;, 																			Account.BillingCountry = &apos;MX&apos;, 																			Account.BillingCountry = &apos;NI&apos;, 																			Account.BillingCountry = &apos;PA&apos;, 																			Account.BillingCountry = &apos;AR&apos;, 																			Account.BillingCountry = &apos;CL&apos;, 																			Account.BillingCountry = &apos;CO&apos;, 																			Account.BillingCountry = &apos;CR&apos;, 																			Account.BillingCountry = &apos;DO&apos;, 																			Account.BillingCountry = &apos;EC&apos;, 																			Account.BillingCountry = &apos;SV&apos;, 																			Account.BillingCountry = &apos;PE&apos;, 																			Account.BillingCountry = &apos;ES&apos;, 																			Account.BillingCountry = &apos;PR&apos;, 																			Account.BillingCountry = &apos;BO&apos;, 																			Account.BillingCountry = &apos;UY&apos;, 																			Account.BillingCountry = &apos;PY&apos;), 																			ISPICKVAL(Status, &apos;Closed&apos;),   								OR( 												RIGHT(CaseNumber, 1)= &apos;1&apos;, 												RIGHT(CaseNumber, 1)= &apos;3&apos;, 												RIGHT(CaseNumber, 1)= &apos;5&apos;, 												RIGHT(CaseNumber, 1)= &apos;7&apos;, 												RIGHT(CaseNumber, 1)= &apos;9&apos;), 								NOT(ISPICKVAL(Type, &apos;Account Change&apos;)),  NOT(ISPICKVAL(Type, &apos;Chat - No Response&apos;)), 								NOT(ISPICKVAL(Type, &apos;Billing&apos;)),   								NOT(ISPICKVAL(Type, &apos;Deactivation&apos;)),   								NOT(ISPICKVAL(Type, &apos;Organizer System&apos;)),   								NOT(ISPICKVAL(Type, &apos;Finish Line&apos;)),   								NOT(ISPICKVAL(Sub_Type__c, &apos;CS Outreach&apos;)),   								NOT(ISPICKVAL(Sub_Type__c, &apos;Welcome Call/Email&apos;)),   								NOT(ISPICKVAL(Sub_Type__c, &apos;Chat - No Response&apos;)), NOT(ISPICKVAL(Resolution__c, &apos;Unable to Contact&apos;)), NOT(ISPICKVAL(Resolution__c, &apos;Voicemail&apos;)),   /*Supplier*/  								RecordTypeId = &apos;01270000000cebI&apos; ),  TRUE, FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Spanish Supplier Transactional Survey %28Increased Frequency%29</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Spanish_Supplier_Transaction_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Created for 02613976</description>
        <formula>IF(   				 				AND( 								Owner:User.Increased_Survey_Frequency__c = TRUE, 								NOT(ISNULL(ContactId)), 								Contact.Account.No_Marketing_to_this_Acct__c = FALSE, 								Supplier_Transactional_Survey_Sent__c = FALSE, 								NOT(ISNULL(AccountId)), 								/*Contractor*/Account.RecordTypeId = &apos;01270000000MRzn&apos;, 								Account.No_Marketing_to_this_Acct__c = FALSE, 								ISPICKVAL(Account.Status__c, &apos;Active&apos;), 								OR(Account.BillingCountry = &apos;GT&apos;, 											Account.BillingCountry = &apos;HN&apos;, 											Account.BillingCountry = &apos;MX&apos;, 											Account.BillingCountry = &apos;NI&apos;, 											Account.BillingCountry = &apos;PA&apos;, 											Account.BillingCountry = &apos;AR&apos;, 											Account.BillingCountry = &apos;CL&apos;, 											Account.BillingCountry = &apos;CO&apos;, 											Account.BillingCountry = &apos;CR&apos;, 											Account.BillingCountry = &apos;DO&apos;, 											Account.BillingCountry = &apos;EC&apos;, 											Account.BillingCountry = &apos;SV&apos;, 											Account.BillingCountry = &apos;PE&apos;, 											Account.BillingCountry = &apos;ES&apos;, 											Account.BillingCountry = &apos;PR&apos;, 											Account.BillingCountry = &apos;BO&apos;, 											Account.BillingCountry = &apos;UY&apos;, 											Account.BillingCountry = &apos;PY&apos;), 								ISPICKVAL(Status, &apos;Closed&apos;), 								OR( 												RIGHT(CaseNumber, 1)= &apos;2&apos;, 												RIGHT(CaseNumber, 1)= &apos;6&apos;), 								NOT(ISPICKVAL(Type, &apos;Account Change&apos;)), 								NOT(ISPICKVAL(Type, &apos;Chat - No Response&apos;)), 								NOT(ISPICKVAL(Type, &apos;Billing&apos;)), 								NOT(ISPICKVAL(Type, &apos;Deactivation&apos;)), 								NOT(ISPICKVAL(Type, &apos;Organizer System&apos;)), 								NOT(ISPICKVAL(Type, &apos;Finish Line&apos;)),  								NOT(ISPICKVAL(Sub_Type__c, &apos;CS Outreach&apos;)), 								NOT(ISPICKVAL(Sub_Type__c, &apos;Welcome Call/Email&apos;)), 								NOT(ISPICKVAL(Sub_Type__c, &apos;Chat - No Response&apos;)), 								NOT(ISPICKVAL(Resolution__c, &apos;Unable to Contact&apos;)), 								NOT(ISPICKVAL(Resolution__c, &apos;Voicemail&apos;)), 								/*Supplier*/RecordTypeId = &apos;01270000000cebI&apos; ), 				TRUE, 				FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Supplier Transactional Survey</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Supplier_Transaction_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF(  AND(  NOT(ISNULL(ContactId)),  Contact.Account.No_Marketing_to_this_Acct__c = FALSE,  Supplier_Transactional_Survey_Sent__c = FALSE,  NOT(ISNULL(AccountId)),  /*Contractor*/  Account.RecordTypeId = &apos;01270000000MRzn&apos;,  Account.No_Marketing_to_this_Acct__c = FALSE,  ISPICKVAL(Account.Status__c, &apos;Active&apos;), Account.BillingState != &apos;Quebec&apos;, Account.BillingState != &apos;QC&apos;, Account.BillingState != &apos;Québec&apos;, OR(Account.BillingCountry = &apos;GB&apos;, Account.BillingCountry = &apos;UK&apos;, Account.BillingCountry = &apos;CA&apos;, Account.BillingCountry = &apos;AU&apos;, Account.BillingCountry = &apos;US&apos;, Account.BillingCountry = &apos;USA&apos;, Account.BillingCountry = &apos;United States&apos;, Account.BillingCountry = &apos;Canada&apos;, Account.BillingCountry = &apos;United Kingdom&apos;, Account.BillingCountry = &apos;Australia&apos;),  ISPICKVAL(Status, &apos;Closed&apos;),  RIGHT(CaseNumber, 1)= &apos;1&apos;,  NOT(ISPICKVAL(Type, &apos;Account Change&apos;)),  NOT(ISPICKVAL(Type, &apos;Billing&apos;)),  NOT(ISPICKVAL(Type, &apos;Deactivation&apos;)),  NOT(ISPICKVAL(Type, &apos;Organizer System&apos;)),  NOT(ISPICKVAL(Type, &apos;Chat - No Response&apos;)), NOT(ISPICKVAL(Type, &apos;Finish Line&apos;)),  NOT(ISPICKVAL(Sub_Type__c, &apos;CS Outreach&apos;)),  NOT(ISPICKVAL(Sub_Type__c, &apos;Welcome Call/Email&apos;)),  NOT(ISPICKVAL(Sub_Type__c, &apos;Chat - No Response&apos;)),  NOT(ISPICKVAL(Resolution__c, &apos;Unable to Contact&apos;)), NOT(ISPICKVAL(Resolution__c,  &apos;Voicemail&apos;)),    /*Supplier*/ RecordTypeId = &apos;01270000000cebI&apos; ),  TRUE, FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Supplier Transactional Survey Increased Frequency</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Supplier_Transaction_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF(  						 				AND( 											  								NOT(ISNULL(ContactId)), Owner:User.Increased_Survey_Frequency__c = TRUE, 												 								Contact.Account.No_Marketing_to_this_Acct__c = FALSE, Supplier_Transactional_Survey_Sent__c = FALSE, 												 								NOT(ISNULL(AccountId)), 												/*Contractor*/ 												 								Account.RecordTypeId = &apos;01270000000MRzn&apos;, 												 								Account.No_Marketing_to_this_Acct__c = FALSE, 									 	  								ISPICKVAL(Account.Status__c, &apos;Active&apos;),  								Account.BillingState != &apos;Quebec&apos;,  								Account.BillingState != &apos;QC&apos;,  								Account.BillingState != &apos;Québec&apos;,												 								OR(  																		 												Account.BillingCountry = &apos;GB&apos;, 																		 												Account.BillingCountry = &apos;UK&apos;, 																		 												Account.BillingCountry = &apos;CA&apos;, 																		 												Account.BillingCountry = &apos;AU&apos;, 																		 												Account.BillingCountry = &apos;US&apos;, 																		 												Account.BillingCountry = &apos;USA&apos;, 																		 												Account.BillingCountry = &apos;United States&apos;, 																		 												Account.BillingCountry = &apos;Canada&apos;, 																		 												Account.BillingCountry = &apos;United Kingdom&apos;, 																		 												Account.BillingCountry = &apos;Australia&apos; 												), 												 								ISPICKVAL(Status, &apos;Closed&apos;),  								OR( 											 												RIGHT(CaseNumber, 1)= &apos;3&apos;,  												RIGHT(CaseNumber, 1)= &apos;5&apos;,  												RIGHT(CaseNumber, 1)= &apos;7&apos;,  												RIGHT(CaseNumber, 1)= &apos;9&apos;), 								 												 								NOT(ISPICKVAL(Type, &apos;Account Change&apos;)),  								NOT(ISPICKVAL(Type, &apos;Chat - No Response&apos;)),												 								NOT(ISPICKVAL(Type, &apos;Billing&apos;)), 												 								NOT(ISPICKVAL(Type, &apos;Deactivation&apos;)), 												 								NOT(ISPICKVAL(Type, &apos;Organizer System&apos;)), 												 								NOT(ISPICKVAL(Type, &apos;Finish Line&apos;)), 												 								NOT(ISPICKVAL(Sub_Type__c, &apos;CS Outreach&apos;)), 												 								NOT(ISPICKVAL(Sub_Type__c, &apos;Welcome Call/Email&apos;)), 												 								NOT(ISPICKVAL(Sub_Type__c, &apos;Chat - No Response&apos;)), NOT(ISPICKVAL(Resolution__c, &apos;Unable to Contact&apos;)), NOT(ISPICKVAL(Resolution__c, &apos;Voicemail&apos;)), 																														/*Supplier*/ 																	RecordTypeId = &apos;01270000000cebI&apos;),   						TRUE, 						FALSE  			)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update QA Case Owner to CS</fullName>
        <actions>
            <name>Update_case_owner_to_CSR_Netscribes_QA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_type_to_CS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalate to CS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Vetify Survey</fullName>
        <actions>
            <name>Update_Survey_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Vetify_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF( 
				AND
				( NOT
					(ISNULL(ContactId)), 
					Contact.Account.No_Marketing_to_this_Acct__c = FALSE,
					Supplier_Transactional_Survey_Sent__c = FALSE, 
					NOT(ISNULL(AccountId)), 
					/*Contractor*/ Account.RecordTypeId = &apos;01270000000MRzn&apos;, 
					Account.No_Marketing_to_this_Acct__c = FALSE, 
					ISPICKVAL(Account.Status__c, &apos;Active&apos;), 
					Account.BillingState != &apos;Quebec&apos;, 
					Account.BillingState != &apos;QC&apos;, 
					Account.BillingState != &apos;Québec&apos;, 
					OR(Account.BillingCountry = &apos;CA&apos;, Account.BillingCountry = &apos;US&apos;, Account.BillingCountry = &apos;USA&apos;, Account.BillingCountry = &apos;United States&apos;, Account.BillingCountry = &apos;Canada&apos;), ISPICKVAL(Status, &apos;Completed&apos;), RecordTypeId = &apos;01270000000cejh&apos; ), TRUE, FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Vetify%3A Populate Send Email 1 Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vetify</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>Populates the Vetify send email date time for the appropriate</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Send_Email_1</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Vetify%3A Populate Send Email 2 Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vetify</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sent_Email_1__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Populates the Vetify send email 2 date/time.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Send_Email_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Send_Email_1__c</offsetFromField>
            <timeLength>168</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Vetify%3A Populate Send Email 3 Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vetify</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sent_Email_2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Populates the Vetify send email 3 date/time.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Send_Email_3</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Send_Email_2__c</offsetFromField>
            <timeLength>168</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Vetify%3A Populate Send Email 4 Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vetify</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sent_Email_3__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Populates the Vetify send email 4 date/time.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Send_Email_4</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Send_Email_3__c</offsetFromField>
            <timeLength>168</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Vetify%3A Populate Send Email 5 Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vetify</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sent_Email_4__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Populates the Vetify send email 5 date/time.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Send_Email_5</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Send_Email_4__c</offsetFromField>
            <timeLength>576</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Email_Sent_CS_Outreach_Lafarge_Voicemail_Follow_Up</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.ClosedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Sent: CS Outreach Lafarge Voicemail Follow Up</subject>
    </tasks>
    <tasks>
        <fullName>Email_Sent_CS_Outreach_Voicemail_Follow_Up</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.ClosedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Sent: CS Outreach Voicemail Follow Up</subject>
    </tasks>
</Workflow>
