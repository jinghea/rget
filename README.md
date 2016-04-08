# rget
Simple ruby download tool with progress bar

Usage for command line: 
$ ruby rget.rb [TARGET_URL]

Usage for ruby:
include RGet
download([TARGET_URL], [OPTIONS])

Options is a hash with
:dest => The path or file to download to. If :dest is a folder, will create files under that folder
:use_ssl => true or false

The progress runner in the package can be used not only for download but any other tasks.

Usage
progress_runner = ProgressRunner.new(total_of_tasks, {:title_part => true})
progress_runner.run(part_of_tasks) do
	  ...
end

Thanks to 'ruby-progressbar' gem
