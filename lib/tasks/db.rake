namespace :db do
  
  desc "Import People from GED file"
  
  task import: :environment do
        
    $nextline = ""

    $inds = {}
    $fams = {}

    def read(f)
    	$nextline = f.readline
    	#puts "READ: #{$nextline}"
    	d, t, k = parse($nextline)
    	#puts "RTRN: d:#{d} t:#{t} k:#{k}"
    	return d,t,k
    end

    def parse(line)
    	parts = line.split(' ')
    	depth = parts[0]

    	if parts[1] == 'HEAD'
    		return depth, 'HEAD', ''
    	end

    	if parts[1][0] == '@'
    		return depth, parts[2], parts[1]
    	end

    	return depth, parts[1], parts[2..10].join(' ')
    end

    def process_header(f)
    	puts "process header"
    	d, t, k = read(f)
    	while d != '0' 
    		# process body line here
    		d, t, k = read(f)
    	end
    end

    def process_individual(f)
    	# puts "process individual line=#{$nextline}"
      
    	d, t, key = parse($nextline)
    	d, t, rest = read(f)
    	while d != '0' 
    		name = rest if t=='NAME'
    		gender = rest if t== 'SEX'
    		fams = rest if t== 'FAMS'
    		famc = rest if t== 'FAMC'
        
        if t == 'TYPE'
          x = rest.split(' ');
          mail = x[1] if x[0] == 'Email:'
          puts "TYPE: #{rest}"
        end
        
        if t == 'BIRT'
          bdate, bplace = process_birth(f)
        	d, t, rest = parse($nextline)
        elsif t == 'DEAT'
          ddate, dplace = process_birth(f)
          d, t, rest = parse($nextline)
        elsif t == 'BURI'
          xdate, xplace = process_birth(f)
          d, t, rest = parse($nextline)
        else
    		  d, t, rest = read(f)
        end
    	end
      
      names = name.split('/')
      fname = names[0]
      lname = names[1]
    	$inds[key] = { 
        key: key, first_name: fname, 
        last_name: lname, gender: gender, 
        birth_place: bplace, birth_date_string: bdate, 
        death_place: dplace, death_date_string: ddate, 
        buried_place: xplace, buried_date_string: xdate, 
        email: mail,
        famc_key: famc, fams_key: fams 
      }
    	# puts ">>>> #{$inds[key]}"
    end
    
    def process_birth(f)
      date = ''
      place = ''
		  d, t, rest = read(f)
      while t=='DATE' || t=='PLAC'
        # puts "birth: #{t}: #{rest}"
        date = rest if t=='DATE'
        place = rest if t=='PLAC'
  		  d, t, rest = read(f)
        # puts "+++ #{$nextline}"
      end
      return date,place
    end

    def process_family(f)
    	d, t, key = parse($nextline)
    	# puts "process family: #{$nextline}"
    	d, t, rest = read(f)
    	while d != '0' 
    		husb = rest if t=='HUSB'
    		wife = rest if t=='WIFE'
    		d, t, rest = read(f)
    	end
    	$fams[key] = {key: key, husb: husb, wife: wife }
      # puts $fams[key]
    end

    def process_other(f)
    	#puts "process other: #{$nextline}"
    	d, t, k = read(f)
    	while d != '0' 
    		# process body line here
    		d, t, k = read(f)
    	end
    end
    
    ##### MAINLINE #######
    
    Person.delete_all

    File.open("#{Rails.root}/lib/tasks/data1.ged") do |f|
    #File.open("data1.ged", "r") do |f|
    	count = 0
    	d, t, k = read(f)

    	while d == '0'
    		# puts "#{count}: #{$nextline}"
    		# puts "d:#{d} t:#{t} k:#{k}"
    		case t
    		when "HEAD"
    			process_header(f)
    		when "INDI"
    			count += 1
    			process_individual(f)
    			# break if count > 200
    		when "TRLR" # trailer record
    			puts "*** end of file"
    			break
    		when "FAM" # submitter
    			process_family(f)
    		when "SUBM" # submitter
    			process_other(f)
    		else
    			process_other(f)
    		end
    		# process has read ahead
    		d,t,k = parse($nextline)
    	end
    end

    def father(ind)
    	da_fam = $fams[ind[:famc_key]]
    	da = $inds[da_fam[:husb]]
    	puts da
    	return da
    end

    ##### THE REPORT ######

    puts "\n--- Report\n"
    puts "ind count = #{$inds.count}"
    puts "fam count = #{$fams.count}"
    
    
    pjc = $inds['@I287@']
    puts pjc
    my_fam = $fams[pjc[:fams_key]]
    da_fam = $fams[pjc[:famc_key]]

    puts "da fam = #{da_fam}"
    puts "my fam = #{my_fam}"
    puts $inds[my_fam[:wife]]
    puts $inds[my_fam[:husband]]

    $inds.each do |k,v|
      puts v if v[:famc_key] == pjc[:fams_key]
    end

    gjc = father(pjc)
    tpc = father(gjc)
    jfc = father(tpc)
    pxc = father(jfc)
    top = father(pxc)
    
    #### THE CREATION ######
    
    $inds.each do |k,v|
      person = Person.create(v)
    end
     
  end

end
