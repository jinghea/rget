require 'ruby-progressbar'

class ProgressRunner

	def initialize(total, options = {})
         @options = options
         @progress  = 0
         @total = total
         @progress_bar = ProgressBar.create(:total => @total)
         set_title
	end

	def run(segment)
        
        begin
			yield
			
			if @progress < @total
				@progress += segment
				@progress = @total if @progress > @total 
				set_title
				@progress_bar.progress = @progress
			end
			
		rescue
			@progress_bar.stop
			raise
		end

	end
    
    def set_title
    	if @options === {:title_part => true}
            @progress_bar.title = "#{@progress}/#{@total}"
        end    
    end

end