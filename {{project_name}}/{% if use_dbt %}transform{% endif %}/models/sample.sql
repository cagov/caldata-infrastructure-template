with
    dates as (
        select *
        from unnest(generate_date_array('2023-01-01', '2023-12-31')) as date
        with
        offset as
        offset
    )

select
offset as id, date, generate_uuid() as value
from dates
