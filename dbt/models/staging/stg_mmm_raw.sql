
-- Staging: Raw MMM data with basic cleaning
-- Source: mmm_dissertation_data.csv

SELECT
    date,
    sales,
    tv_spend,
    digital_spend,
    social_spend,
    search_spend,
    radio_spend,
    bounce_rate,
    session_duration,
    pages_per_session,
    nps_score,
    conversion_rate
FROM {{ source('dissertation', 'mmm_raw') }}
WHERE sales > 0
  AND date IS NOT NULL
