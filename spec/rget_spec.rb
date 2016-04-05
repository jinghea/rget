require_relative '../lib/rget'

class FakeClass
end

class FakeHttp


   def initialize(fake_segment)
   	@fake_segment = fake_segment
   end

   def request_get(anything)
   	 yield(FakeResponse.new(@fake_segment))
   end
end

class FakeResponse < Hash

	def initialize(fake_segment)
		self['Content-Length'] = 100
		@fake_segment = fake_segment
	end

	def read_body
		yield(@fake_segment)
	end
end

class FakeSegment
	def length
		10
	end
end

describe "calc_dest" do

	before(:each) do
		@fakeClass = FakeClass.new
		@fakeClass.extend(RGet)
    end

	it "calc dest when dest_opt is nil" do

		dest = @fakeClass.calc_dest URI("http://abc.com/aa.mp3?a=b"), nil

        expect(dest).to eq("./aa.mp3")

	end

	it "calc dest when dest_opt is folder" do

		allow(File).to receive(:directory?).and_return(true)

        dest = @fakeClass.calc_dest URI("http://abc.com/aa.mp3?a=b"), "/home/folder"

        expect(dest).to eq("/home/folder/aa.mp3")

	end

	it "calc dest when dest_opt is not folder" do

		allow(File).to receive(:directory?).and_return(false)

        dest = @fakeClass.calc_dest URI("http://abc.com/aa.mp3?a=b"), "/home/folder/qq"

        expect(dest).to eq("/home/folder/qq")

	end
	
end


describe "download" do

    before(:each) do
		@fakeClass = FakeClass.new
		@fakeClass.extend(RGet)
    end
  

    it "download with a url" do
        url = "http://abc.com/qq.mp3"

        allow(File).to receive(:directory?).and_return(true)

        fake_segment = FakeSegment.new
        
        allow(Net::HTTP).to receive(:new).and_return(FakeHttp.new(fake_segment))

        fake_file = double("FakeFile")

        expect(fake_file).to receive(:write).with(fake_segment)

        allow(File).to receive(:open).and_yield(fake_file)

        @fakeClass.download(url)       

    end

end



