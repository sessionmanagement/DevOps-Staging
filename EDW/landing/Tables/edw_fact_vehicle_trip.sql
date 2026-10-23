CREATE TABLE [landing].[edw_fact_vehicle_trip] (
    [vehicle_trip_id]                VARCHAR (100)  NULL,
    [vehicle_id]                     VARCHAR (40)   NULL,
    [is_processed]                   INT            NULL,
    [version]                        INT            NULL,
    [start_timestamp]                DATETIME       NULL,
    [start_point_latitude]           FLOAT (53)     NULL,
    [start_point_longitude]          FLOAT (53)     NULL,
    [start_address]                  NVARCHAR (MAX) NULL,
    [end_timestamp]                  DATETIME       NULL,
    [end_point_latitude]             FLOAT (53)     NULL,
    [end_point_longitude]            FLOAT (53)     NULL,
    [end_address]                    NVARCHAR (MAX) NULL,
    [is_towed]                       INT            NULL,
    [driver_full_name]               NVARCHAR (255) NULL,
    [driver_email_address]           NVARCHAR (255) NULL,
    [distance_meters]                FLOAT (53)     NULL,
    [distance_meters_offroad]        FLOAT (53)     NULL,
    [average_speed]                  FLOAT (53)     NULL,
    [max_speed]                      FLOAT (53)     NULL,
    [num_polls]                      INT            NULL,
    [on_road_within_speed_limit]     INT            NULL,
    [on_road_over_speed_limit_band1] INT            NULL,
    [on_road_over_speed_limit_band2] INT            NULL,
    [on_road_over_speed_limit_band3] INT            NULL,
    [on_road_over_speed_limit_band4] INT            NULL,
    [on_road_over_speed_limit_band5] INT            NULL,
    [offroad_within_speed_limit]     INT            NULL,
    [offroad_over_speed_limit_band1] INT            NULL,
    [offroad_over_speed_limit_band2] INT            NULL,
    [offroad_over_speed_limit_band3] INT            NULL,
    [offroad_over_speed_limit_band4] INT            NULL,
    [offroad_over_speed_limit_band5] INT            NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_vehicle_trip]
    ON [landing].[edw_fact_vehicle_trip]([vehicle_trip_id] ASC);

