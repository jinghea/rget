require "uri"
require 'net/http'
require 'net/https'
require 'fileutils'
require File.join(File.dirname(__FILE__), 'progress_runner')


module RGet

	def calc_dest uri, dest_opt

	    if dest_opt.nil?
	        return "./#{File.basename(uri.path)}"
	        
	    elsif File.directory?(dest_opt)
	    	return "#{dest_opt}/#{File.basename(uri.path)}"

	    else
	    	return dest_opt
	    end
	    	
	end

	def prepare_dest dest
		dirname = File.dirname(dest)
        unless File.directory?(dirname)
             FileUtils.mkdir_p(dirname)
        end
	end

	def download(url, options={})

		uri = URI(url)

		dest = calc_dest(uri, options[:dest])

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if options === {:use_ssl => true}
		http.request_get("#{uri.path}?#{uri.query}") do |response|

			length = response['Content-Length'].to_i

			progress_runner = ProgressRunner.new(length, {:title_part => true})

            prepare_dest dest
			File.open(dest, "wb") do |file|

				response.read_body do |segment|
	               
	               progress_runner.run(segment.length) do
	               	  file.write(segment)
	               end
	               
	            end
		    end
		end

	end

end

def main()
  self.extend RGet

  download ARGV[0]
end

if($0 == __FILE__)
	
	main()
end