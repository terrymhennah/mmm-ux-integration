MODEL (                                                                  
    name dissertation.mmm_channel_performance,                             
    kind FULL,                                                             
    cron '@weekly',                                                        
    grain date                                                             
  );                                                                       
                                                                           
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
    conversion_rate,                                                       
                                                                           
    -- total spend                                                         
    tv_spend + digital_spend + social_spend + search_spend + radio_spend AS
   total_media_spend,                                                      
                                                            
    -- blended ROAS                                                        
    ROUND(sales / NULLIF(tv_spend + digital_spend + social_spend +
  search_spend + radio_spend, 0), 4) AS blended_roas,                      
                                                            
    -- channel ROAS                                                        
    ROUND(sales / NULLIF(tv_spend, 0), 4)       AS tv_roas, 
    ROUND(sales / NULLIF(digital_spend, 0), 4)  AS digital_roas,           
    ROUND(sales / NULLIF(social_spend, 0), 4)   AS social_roas,            
    ROUND(sales / NULLIF(search_spend, 0), 4)   AS search_roas,            
    ROUND(sales / NULLIF(radio_spend, 0), 4)    AS radio_roas              
                                                                           
  FROM public.mmm_weekly_data      