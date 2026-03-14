with source as (
      select * from public.mmm_weekly_data                  
  ),
                                                            
  staged as (                                             
      select                                                
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
          -- derived metrics                                
          tv_spend + digital_spend + social_spend +         
  search_spend + radio_spend as total_media_spend,          
          round(sales / nullif(tv_spend + digital_spend +   
  social_spend + search_spend + radio_spend, 0), 4) as      
  blended_roas                                            
      from source                                           
  )                                                       

  select * from staged