This documentation provides a high-level overview of the dataflow’s configuration and operations. For a detailed understanding, each step should be further elaborated with specifics from the actual implementation in synapse pipeline

1. Initialization of Dataflow:
- [ ] Dataflow Name: DF_BusinessCentral_full_delete_detection
- [ ] Folder Name: BusinessCentral
- [ ] Type: MappingDataFlow
2. Defining Sources:
- [ ] GenericInput: Reads data from the data landing zone using the linked service ls_ADLS_datalanding.
- [ ] ExistingDimensionTable: Reads existing data from Azure Storage using the linked service ls_AzureStorage.
3. Defining Sinks:
- [ ] ODSTableSinkdel: Writes data to Azure Storage with the linked service ls_AzureStorage.
- [ ] AuditInfoCache: Caches audit information, described as “Export data to cachet”.
4. Transformations:
- [ ] AddHashInput: Adds a hash to the input data.
- [ ] AddHashExisting: Adds a hash to the existing data.
- [ ] GetMaxSurrogateKey: Retrieves the maximum surrogate key from the existing data.
- [ ] FilterFordeletedValues: Filters out deleted values by comparing hashes.
- [ ] UpdateObsolete: Marks obsolete records for deletion.
- [ ] MarkAsDelete: Marks rows as deleted and adds expressions for deletion.
- [ ] DropUnwantedColumns: Removes unnecessary columns from the data.
- [ ] FilterForActive: Filters for active records.
- [ ] GetDeleteCount: Counts the number of deleted records.
- [ ] GetSourceCount: Counts the number of source records.
5. Script Execution:
- [ ] The script defines parameters such as primary key, columns, target path, file, source path, batch ID, source directory, and audit date.
- [ ] It then performs a series of operations such as reading from sources, deriving hashes, filtering, aggregating, and writing to sinks.
- [ ] Sink Operations:
- [ ] ODSTableSinkdel: Configured to handle schema drift, validate schema, and format data as ‘delta’. It is set to upsert data based on the RowKey.
- [ ] AuditInfoCache: Validates schema and stores the count of deleted records in the cache.
6. Parameters:
- [ ] Parameters like PrimaryKey, Columns, TargetPath, TargetFile, SourcePath, ODSBatchId, SourceDirectory, and AuditDate are used throughout the dataflow to dynamically configure the behavior of sources, transformations, and sinks.
7. Error Handling:
- [ ] The dataflow is configured to allow schema drift and to not validate the schema, which provides flexibility in handling different data formats and structures.
8. Optimization and Performance:
- [ ] Settings such as autoCompact, optimizedWrite, and vacuum are configured for performance tuning and storage optimization.
9. Audit and Monitoring:
- [ ] Audit information such as batch ID and source system is captured and stored for monitoring and tracking purposes.
[BC_data_landing.vsdx](/.attachments/BC_data_landing-3fc7a6c4-1db4-4991-946f-9beffad9c148.vsdx)
[Synapse dataflow SCD type2.docx](/.attachments/Synapse%20dataflow%20SCD%20type2-e800c488-c562-4ad2-befe-7b753a926562.docx)