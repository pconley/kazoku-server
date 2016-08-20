namespace :db do
  
  desc "Extract People & Families from GED file"
  
  task convert: :environment do
            
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

    	return depth, parts[1], parts[2..100].join(' ')
    end

    def process_header(f)
    	puts "=header"
    	d, t, k = read(f)
    	while d != '0' 
    		d, t, k = read(f)
    	end
    end

    def process_individual(f)
    	# puts "process individual line=#{$nextline}"
      
    	d, t, key = parse($nextline)
    	d, t, rest = read(f)
    	while d != '0' 
              
        case t
        when 'NAME'
          name = rest
    		  read(f)    
        when 'SEX'
          gender = rest
    		  read(f)     
        when 'FAMS'
          fams = rest
    		  read(f)      
        when 'FAMC'
          famc = rest
    		  read(f)
        when 'TYPE'
          x = rest.split(' ');
          if x[0] == 'Email:'
            mail = x[1]
          else
            puts "*** TYPE: #{rest}"
          end
    		  read(f) 
        when 'OCCU'
          occu, odate, oplace = process_occupation(f)
          # puts "*** occu: #{occu} #{odate} #{oplace}"
        when 'DSCR'
          desc = process_note(f)
          #puts "*** desc: #{desc}"
        when 'NOTE'
          note = process_note(f)
          #puts "*** note: #{note}"
        when 'CHR' # christened
          cdate, cplace, cnote = process_subset(f)
        when 'BAPM' # christened
          cdate, cplace, cnote = process_subset(f)
        when 'BIRT' # birth
          bdate, bplace, bnote = process_subset(f)
        when 'DEAT' # death
          ddate, dplace, dnote = process_subset(f)
        when 'BURI' # buried
          xdate, xplace, xnote = process_subset(f)
        when 'EVEN'
          e = process_event(f)
        else
          puts "***error: #{$nextline}"
    		  read(f)
        end
        
        d, t, rest = parse($nextline)
        
    	end
      
      names = name.split('/')
      fname = names[0]
      lname = names[1]
    	$inds[key] = { 
        key: key, first_name: fname, 
        last_name: lname, gender: gender, 
        chris_place: cplace, chris_date_string: cdate, 
        birth_place: bplace, birth_date_string: bdate, 
        death_place: dplace, death_date_string: ddate, 
        buried_place: xplace, buried_date_string: xdate, 
        email: mail, occupaton: occu, note: note,
        famc_key: famc, fams_key: fams 
      }
    	# puts ">>>> #{$inds[key]}"
    end
    
    def process_note(f)
    	#puts "=note: #{$nextline}"
      level, t, rest = parse($nextline)
    	date, place, note = process_subset(f)
      return rest+note
    end

    def process_event(f)
      # puts "=event: #{$nextline}"
		  d, t, rest = read(f)
      while d.to_i > 1
        # puts "+event: #{d.to_i} #{t}: #{rest}"
  		  d, t, rest = read(f)  
      end
      return "xxx"
    end
    
    def process_occupation(f)
      # puts "=occu: #{$nextline}"
      d, t, occu = parse($nextline)
      date, place, note = process_subset(f,true)
      # puts "+occu: n:#{occu+note} d:#{date} p:#{place}"
      return occu+note, date, place
    end
    
    def process_subset(f, trace=false)
      # puts "=subset: #{$nextline}"
      level, t, rest = parse($nextline)
      date = ''
      place = ''
      note = ''
		  d, t, rest = read(f)
      # puts "/subset: :#{t}:"
      while d.to_i > level.to_i
        # puts "+subset: #{t}: #{rest}" # if trace
        case t
        when 'DATE'
          date = rest
        when 'PLAC'
          place = rest
        when 'NOTE'
          note = rest
        when 'CONC'
          note += rest
        when 'CONT'
          note += "  "+rest
        else
          puts "--- error #{$nextline}"
        end
  		  d, t, rest = read(f)
      end
      # puts "-subset #{$nextline}" # if trace
      return date,place,note
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
    	puts "=other: #{$nextline}"
      level, t, k = parse($nextline)
    	d, t, k = read(f)
    	while d.to_i > level.to_i
      	puts "+other: #{$nextline}"
    		d, t, k = read(f)
    	end
    end
    
    def process_absorb(f)
    	# puts "=absorb: #{$nextline}"
      level, t, k = parse($nextline)
    	d, t, k = read(f)
    	while d.to_i > level.to_i
      	# puts "+absorb: #{$nextline}"
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
    			puts "*** trailer"
    			break
    		when "FAM" # family
    			process_family(f)
    		when "SUBM" # submitter
    			process_absorb(f)
    		when "@S0@" # submitter
    			process_absorb(f)
    		when "_EVENT_DEFN"
    			process_absorb(f)
    		else
          puts "OTHER: #{$nextline}"
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
    
    pjc = $inds['@I287@']
    pjc_fam = $fams[pjc[:fams_key]]
    dad_fam = $fams[pjc[:famc_key]]

    puts "\ndad fam = #{dad_fam}"
    puts "\npjc fam = #{pjc_fam}"
    puts "\nwife = #{$inds[pjc_fam[:wife]]}"
    puts "\nhusb = #{$inds[pjc_fam[:husb]]}\n"
    $inds.each do |k,v|
      puts v if v[:famc_key] == pjc[:fams_key]
    end

    puts pjc
    
    puts "\nTeacher1 = #{$inds['@I156@']}"
    puts "\nTeacher2 = #{$inds['@I533@']}"
    puts "\nAlice = #{$inds['@I240@']}"
    puts "\n"
    # gjc = father(pjc)
    # tpc = father(gjc)
    # jfc = father(tpc)
    # pxc = father(jfc)
    # top = father(pxc)
    
    #### THE OUTPUT ######
       
    File.open("#{Rails.root}/lib/tasks/indi1.json",'w') do |s|
      $inds.each do |k,v|
        s.puts v
      end
    end

    File.open("#{Rails.root}/lib/tasks/fams1.json",'w') do |s|
      $fams.each do |k,v|
        s.puts v
      end
    end
    
    puts "ind count = #{$inds.count}"
    puts "fam count = #{$fams.count}"
    puts "\n\n"
    
  end

end
