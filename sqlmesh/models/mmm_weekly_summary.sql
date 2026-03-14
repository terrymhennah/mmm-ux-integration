
MODEL (
  name dissertation.mmm_weekly_summary,
  kind FULL,
  cron '@weekly',
  grain date,
  description 'Weekly MMM summary with UX composite score for dissertation analysis'
);

SELECT
    date,
    sales,
    tv_spend + digital_spend + social_spend +
        search_spend + radio_spend             AS total_media_spend,
    ROUND((1 - bounce_rate) * 0.3 +
          (session_duration / 420.0) * 0.2 +
          (pages_per_session / 8.0)  * 0.2 +
          ((nps_score + 100) / 200.0)* 0.15 +
          (conversion_rate / 0.08)   * 0.15, 4) AS ux_composite_score,
    nps_score,
    conversion_rate,
    bounce_rate,
    YEAR(date)    AS year,
    QUARTER(date) AS quarter
FROM dissertation.mmm_raw
WHERE sales > 0
ORDER BY date
