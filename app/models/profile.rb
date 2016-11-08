class Profile

  	attr_accessor :role
  	attr_accessor :name
  	attr_accessor :email

  	def initialize(options = {})
  		puts "***Profile#init options = #{options}"
    	@role = options.fetch(:role, 'guest') || 'guest'
    	@name = options[:name]
    	@email = options[:email]
    end

    def to_s
    	"<Profile role=#{role} name=#{name} email=#{email}>"
    end

end