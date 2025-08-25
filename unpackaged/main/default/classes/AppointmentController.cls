/*public with sharing class AppointmentController {
    @AuraEnabled
    public static String createAppointment(
        String patientName,
        String doctorName,
        Date appointmentDate,
        String consultationType,
        Decimal fee
    ) {
        try {
            Appointment__c app = new Appointment__c(
                Patient_Name__c = patientName,
                Doctor_Name__c = doctorName,
                Appointment_Date__c = appointmentDate,
                Consultation_Type__c = consultationType,
                Fee__c = fee
            );
            insert app;
            return 'Appointment booked successfully! Patient: ' + app.Patient_Name__c;
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}*/

public with sharing class AppointmentController {
    @AuraEnabled
    public static String createAppointment(
        String patientName,
        String doctorName,
        Date appointmentDate,
        String consultationType,
        Decimal fee
    ) {
        try {
            Id patientAccountId = getPatientAccountId();
            if (patientAccountId == null) {
                throw new AuraHandledException('No patient account found for current user.');
            }

            Appointment__c app = new Appointment__c(
                Patient_Name__c = patientName,
                Doctor_Name__c = doctorName,
                Appointment_Date__c = appointmentDate,
                Consultation_Type__c = consultationType,
                Fee__c = fee,
                Patient__c = patientAccountId // 🔹 This links to the user’s account
            );
            insert app;

            return 'Appointment booked successfully! Patient: ' + app.Patient_Name__c;
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }

    private static Id getPatientAccountId() {
        User u = [
            SELECT ContactId, Contact.AccountId
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];
        return (u.ContactId != null) ? u.Contact.AccountId : null;
    }
}