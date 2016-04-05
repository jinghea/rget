require_relative '../lib/progress_runner'

describe "run" do 

	it "run the segment and display progress" do

		runner = ProgressRunner.new(2, {:title_part => true})

        2.times do
			runner.run(1) do

                sleep(1)

			end
		end
	end

	it "run the segment with exception" do
		runner = ProgressRunner.new(2, {:title_part => true})

        expect {
	        2.times do |i|
				runner.run(1) do

	                sleep(1)
	                raise "interupt" if i > 0

				end
		    end
		}.to raise_error("interupt")

	end

	it "run the segment make it larget than total" do
        
        runner = ProgressRunner.new(2, {:title_part => true})

        3.times do
			runner.run(1) do

                sleep(1)

			end
		end

	end
end