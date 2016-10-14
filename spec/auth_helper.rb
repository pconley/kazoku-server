module AuthHelper

	def invalid_token
  		"xxx"
  	end

  	def valid_token
  		# this value must be refreshed every 24 hours or so by copying from the client console log for pat1@conley.com
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2them9rdS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NTdkMjI2ZDlhMTY0YWY4YzNiZWUyYmVlIiwiYXVkIjoiNlZ0TldtU05YVnhMREN4aURRYUU2eEdiQkFiczROa2siLCJleHAiOjE0NzY1MTM1MzgsImlhdCI6MTQ3NjQ3NzUzOH0.2D3mU-_O0ARlDZwMPxHub8FEwzsJKX6ou0iK8DtkFxE'
  	end

  	def expired_token
  		'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2them9rdS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NTdkODA5OTU4Mzc0OTRhYjA2ODQ3NDNjIiwiYXVkIjoiNlZ0TldtU05YVnhMREN4aURRYUU2eEdiQkFiczROa2siLCJleHAiOjE0NzQzNjk1ODMsImlhdCI6MTQ3NDMzMzU4M30.jgDdLsjF3yoK5vFC1_IK-6EtkbLuufrkaolkrtbmvm8'
  	end

end