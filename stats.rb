
PROJECT_ID = "569eb92ed2eaaa67e388d3b3"

READ_KEY = "8fd44a8395eaf4654e1515a3a9a7be2e1ffc20fa71c4bdc2fb2c4b76bcd75bb7651df2d8d8c6410a0925c34c9e681cf82e7221ac66722804f4c7f2d104622120afd18e3c6aff6b92a2e3b7b07bfd02f0a899ed4d69e0e51fd9514db3bfc42588"

EVENT_COLLECTION = 'document_views'

arg = "https://api.keen.io/3.0/projects/#{PROJECT_ID}/queries/count?api_key=#{READ_KEY}&event_collection=#{EVENT_COLLECTION}&timeframe=this_14_days"

cmd = "curl #{arg}"
puts cmd
exec cmd
