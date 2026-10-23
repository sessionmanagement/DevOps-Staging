Reference Datafactory adf-prod-aus-datalanding-01 

The Extract_DataPay_Data_by_Company pipeline in the datalanding may well fail if the Datacom servers are busy. It can get a restful API timeout on various extracts

The solution to this is to re-run the pipeline


<details>
<summary><b>01 The solution to this is to re-run the pipeline <br/>
</summary>

![image.png](/.attachments/image-645cb4de-67c3-4fbb-986d-19b3e28a9262.png)

</details>
<br/>

Then you will need to check the dependencies of the datapay data.

<details>
<summary><b>01 The solution to this is to re-run the pipeline <br/>
</summary>

![image.png](/.attachments/image-645cb4de-67c3-4fbb-986d-19b3e28a9262.png)

</details>
<br/>




