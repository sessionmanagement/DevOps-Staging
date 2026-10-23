# Issue Overview
When using the API to search for leave requests, **backdated requests** may not appear in the results due to system constraints. 


# Example of API Search Results

As shown in the example below, an employee, employee 'Road Runner', created a **backdated leave request** for last Wednesday to Friday (13th to 15th):

![==image_0==.png](/.attachments/==image_0==-5dc3b310-bd42-4361-b6b9-f5086cbda58f.png) 

When searching via API for leave requests greater or equal to 2024-12-01, the results only include leave requests with future dates and exclude the backdated request:

[{"leaveRequestId":"a19a1217-8f76-4ec5-9380-b2250099e3c3","employeeId":"ac6cb095-a538-4aa8-be18-accb011d09bd","startDateTime":"2024-12-23T08:00:00","endDateTime":"2024-12-24T16:30:00","defaultLeaveType":"cefbaa4c-753e-4a29-bbb6-acbf0098a7f3","status":"APPROVED"},{"leaveRequestId":"216d5b92-45a0-4224-aadd-b225009a0998","employeeId":"ac6cb095-a538-4aa8-be18-accb011d09bd","startDateTime":"2024-12-27T08:00:00","endDateTime":"2024-12-27T16:30:00","defaultLeaveType":"cefbaa4c-753e-4a29-bbb6-acbf0098a7f3","status":"APPROVED"}]

The **backdated leave request** for last Wednesday to Friday is missing from the results.

