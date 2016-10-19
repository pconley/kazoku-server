module ApiHelper

	include AuthHelper # example tokens

	def api_get(action,args,token=valid_token)
		url = "/api/v1/#{action}"
  		get url, params: args, headers: { 'HTTP_AUTHORIZATION' => token }, xhr: true 
  	end

end