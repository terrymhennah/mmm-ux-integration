
-- Mart: Engineered features for MMM modelling
-- Includes: media channels, UX metrics, derived features

WITH base AS (
    SELECT * FROM {{ ref('stg_mmm_raw') }}
),

enriched AS (
    SELECT
        date,
        sales,

        -- Media
        tv_spend,
        digital_spend,
        social_spend,
        search_spend,
        radio_spend,
        tv_spend + digital_spend + social_spend +
            search_spend + radio_spend           AS total_media_spend,

        -- UX Metrics
        bounce_rate,
        session_duration,
        pages_per_session,
        nps_score,
        conversion_rate,

        -- UX Composite Score
        ROUND((1 - bounce_rate) * 0.3 +
              (session_duration / 420.0) * 0.2 +
              (pages_per_session / 8.0) * 0.2 +
              ((nps_score + 100) / 200.0) * 0.15 +
              (conversion_rate / 0.08) * 0.15, 4) AS ux_composite_score,

        -- Time features
        YEAR(date)    AS year,
        MONTH(date)   AS month,
        QUARTER(date) AS quarter,
        WEEK(date)    AS week_num

    FROM base
)

SELECT * FROM enriched
ORDER BY date
