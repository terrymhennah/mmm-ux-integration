with base as (                                            
      select * from {{ ref('stg_mmm_weekly_data') }}
  ),                                                        
                                                            
  channel_performance as (                                  
      select                                                
          date,                                             
          sales,                                          
          total_media_spend,
          blended_roas,                                     
   
          -- individual channel ROAS                        
          round(sales / nullif(tv_spend, 0), 4)       as  
  tv_roas,                                                  
          round(sales / nullif(digital_spend, 0), 4)  as  
  digital_roas,                                             
          round(sales / nullif(social_spend, 0), 4)   as  
  social_roas,                                              
          round(sales / nullif(search_spend, 0), 4)   as  
  search_roas,                                              
          round(sales / nullif(radio_spend, 0), 4)    as  
  radio_roas,                                               
                                                          
          -- channel spend share                            
          round(tv_spend / nullif(total_media_spend, 0) * 
  100, 2)      as tv_spend_pct,                             
          round(digital_spend / nullif(total_media_spend, 0)
   * 100, 2) as digital_spend_pct,                          
          round(social_spend / nullif(total_media_spend, 0)
  * 100, 2)  as social_spend_pct,                           
          round(search_spend / nullif(total_media_spend, 0)
  * 100, 2)  as search_spend_pct,                           
          round(radio_spend / nullif(total_media_spend, 0) *
   100, 2)   as radio_spend_pct                             
                                                          
      from base                                             
  )                                                       
                                                            
  select * from channel_performance  