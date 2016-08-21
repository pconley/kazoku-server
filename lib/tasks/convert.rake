namespace :db do
  
  desc "Convert GED to 2 JSON files"
  
  task convert: :environment do
            
    $inds = {}
    $fams = {}

    $nextline = ""
    
    def trace(s)
      # puts s
    end

    def read(f)
    	$nextline = f.readline
    	#trace "READ: #{$nextline}"
    	d, t, k = parse($nextline)
    	#trace "RTRN: d:#{d} t:#{t} k:#{k}"
    	return d, t, k
    end

    def parse(line)
    	parts = line.split(' ')
    	depth = parts[0]
    	return depth, 'HEAD', '' if parts[1]=='HEAD'
    	return depth, parts[2], parts[1] if parts[1][0] == '@'
    	return depth, parts[1], parts[2..100].join(' ')
    end

    def process_individual(f)
      note = '';
      trace "=indi: #{$nextline}"
      
    	d, t, key = parse($nextline)
    	d, t, rest = read(f)
    	while d != '0' 
        trace "+indi: #{$nextline}"
                    
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
            trace "*** TYPE: #{rest}"
          end
    		  read(f) 
        when 'OCCU'
          occu, odate, oplace = process_occupation(f)
          # trace "*** occu: #{occu} #{odate} #{oplace}"
        when 'DSCR'
          note += "; " if note.length > 0
          note = process_note(f)
          trace "#dscr: note = #{note}"
        when 'NOTE'
          note += "; " if note.length > 0
          note += process_note(f)
          trace "#note: note = #{note}"
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
          note += "; " if note.length > 0
          note += process_event(f)
          trace "#even: note = #{note}"
        else
          trace "***error: #{$nextline}"
    		  read(f)
        end
        
        d, t, rest = parse($nextline)
        
    	end
      trace "-indi:"
      
      names = name.split('/')
      fname = names[0]
      lname = names[1]
    	$inds[key] = { 
        key: key, first_name: fname.strip, 
        last_name: lname, gender: gender,
        chris_place: cplace, chris_date_string: cdate, 
        birth_place: bplace, birth_date_string: bdate, 
        death_place: dplace, death_date_string: ddate, 
        buried_place: xplace, buried_date_string: xdate, 
        email: mail, occupaton: occu, note: note,
        famc_key: famc, fams_key: fams 
      }
    	# trace ">>>> #{$inds[key]}"
    end
    
    def process_note(f)
    	#trace "=note: #{$nextline}"
      level, t, rest = parse($nextline)
    	date, place, note = process_subset(f)
      return rest+note
    end

    def process_event(f)
      result = ''
      trace "=even: #{$nextline}"
		  d, t, rest = read(f)
      while d.to_i > 1
        result += " " + rest
        trace "+even: #{d.to_i} #{t}: #{rest}"
  		  d, t, rest = read(f)  
      end
      return result
    end
    
    def process_occupation(f)
      # trace "=occu: #{$nextline}"
      d, t, occu = parse($nextline)
      date, place, note = process_subset(f,true)
      # trace "+occu: n:#{occu+note} d:#{date} p:#{place}"
      return occu+note, date, place
    end
    
    def process_subset(f, trace=false)
      # trace "=subset: #{$nextline}"
      level, t, rest = parse($nextline)
      date = ''
      place = ''
      note = ''
		  d, t, rest = read(f)
      # trace "/subset: :#{t}:"
      while d.to_i > level.to_i
        # trace "+subset: #{t}: #{rest}" # if trace
        case t
        when 'DATE'
          parts = rest.match(/(\d*)(.*)(\d\d\d\d)/)
          if parts
            day = parts[1].to_i
            mon = to_month(parts[2].strip)
            year = parts[3].to_i
          end
          date = "#{day}:#{mon}:#{year}"
        when 'PLAC'
          place = rest
        when 'NOTE'
          note = rest
        when 'CONC'
          note += rest
        when 'CONT'
          note += "  "+rest
        else
          trace "--- error #{$nextline}"
        end
  		  d, t, rest = read(f)
      end
      # trace "-subset #{$nextline}" # if trace
      return date,place,note
    end
    
    def to_month(text)
      return case text.downcase
      when 'jan'
        1
      when 'feb'
        2
      when 'mar'
        3
      when 'apr'
        4
      when 'may'
        5
      when 'jun'
        6
      when 'jul'
        7
      when 'aug'
        8
      when 'sep'
        9
      when 'oct'
        10
      when 'nov'
        11
      when 'dec'
        12
      else
        0
      end
    end

    def process_family(f)
    	d, t, key = parse($nextline)
    	# trace "process family: #{$nextline}"
    	d, t, rest = read(f)
    	while d != '0' 
    		husb = rest if t=='HUSB'
    		wife = rest if t=='WIFE'
    		d, t, rest = read(f)
    	end
    	$fams[key] = {key: key, husb: husb, wife: wife }
      # trace $fams[key]
    end

    def process_other(f)
    	trace "=other: #{$nextline}"
      level, t, k = parse($nextline)
    	d, t, k = read(f)
    	while d.to_i > level.to_i
      	trace "+other: #{$nextline}"
    		d, t, k = read(f)
    	end
    end
    
    def process_absorb(f)
    	# trace "=absorb: #{$nextline}"
      level, t, k = parse($nextline)
    	d, t, k = read(f)
    	while d.to_i > level.to_i
      	# trace "+absorb: #{$nextline}"
    		d, t, k = read(f)
    	end
    end
    
    ##### MAINLINE #######
    
    File.open("#{Rails.root}/lib/tasks/data1.ged") do |f|
    #File.open("data1.ged", "r") do |f|
    	count = 0
    	d, t, k = read(f)
    	while d == '0'
    		# trace "#{count}: #{$nextline}"
    		# trace "d:#{d} t:#{t} k:#{k}"
    		case t
    		when "HEAD"
    			process_absorb(f)
    		when "INDI"
    			count += 1
    			process_individual(f)
    			# break if count > 200
    		when "TRLR" # trailer record
    			trace "\nOk! End of File\n"
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
          trace "ERROR: #{$nextline}"
    			process_other(f)
    		end
    		d,t,k = parse($nextline)
        # break if count > 10
    	end
    end

    def father(ind)
    	da_fam = $fams[ind[:famc_key]]
    	da = $inds[da_fam[:husb]]
    	trace da
    	return da
    end
        
    ##### THE REPORT ######
    
    # pjc = $inds['@I287@']
    # pjc_fam = $fams[pjc[:fams_key]]
    # dad_fam = $fams[pjc[:famc_key]]
    #
    # trace "\ndad fam = #{dad_fam}"
    # trace "\npjc fam = #{pjc_fam}"
    # trace "\nwife = #{$inds[pjc_fam[:wife]]}"
    # trace "\nhusb = #{$inds[pjc_fam[:husb]]}\n"
    # $inds.each do |k,v|
    #   trace v if v[:famc_key] == pjc[:fams_key]
    # end
    #
    # trace pjc
    #
    # trace "\nTeacher1 = #{$inds['@I156@']}"
    # trace "\nTeacher2 = #{$inds['@I533@']}"
    # trace "\nAlice = #{$inds['@I240@']}"
    # trace "\n"
    # gjc = father(pjc)
    # tpc = father(gjc)
    # jfc = father(tpc)
    # pxc = father(jfc)
    # top = father(pxc)
    
    #### THE OUTPUT ######
       
    File.open("#{Rails.root}/lib/tasks/indi1.json",'w') do |s|
      $inds.each do |k,v|
        s.puts v.to_json
      end
    end

    File.open("#{Rails.root}/lib/tasks/fams1.json",'w') do |s|
      $fams.each do |k,v|
        s.puts v.to_json
      end
    end
    
    puts "ind count = #{$inds.count}"
    puts "fam count = #{$fams.count}"
    puts "\n\n"
    
  end

end
