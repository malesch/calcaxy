# encoding: utf-8

class CalcaxyOld

	DEFAULT_FILES = ["index.html", "index.htm", "index.php"]
  File = ::File

  def initialize(app, archive_path)
    @app = app
		@archive_path = archive_path
  end

  def call(env)
    status, header, response = @app.call(env)
		path = env['PATH_INFO']
    if status == 404
			if  path.start_with? @archive_path
				path = path[@archive_path.length .. -1]
	      absolute_file = absolute_rails_path path
	      # extend with first found default file name if a directory
				Rails.logger.info "*** Checking #{path}... Directory? #{File.directory?(absolute_file)}"
				default_file = nil
	      if File.directory?(absolute_file)
	      	default_file = DEFAULT_FILES.first { |f| File.file?(File.join(@absolute_path,f)) }
					Rails.logger.info "*** Found default file #{default_file}"
					# extend requested path with a default file name
					path = File.join(path, default_file) unless default_file.nil?
	      end
				Rails.logger.info "*** New file: #{path}!"

	      if File.exists?(absolute_rails_path(path))
	        return [301, {"Location" => path, "Content-Type" => "text/html"}, "Redirecting to: #{path}"]
	#        content = File.read(file)
	#        length = "".respond_to?(:bytesize) ? content.bytesize.to_s : content.size.to_s
	#        [503, {'Content-Type' => 'text/html', 'Content-Length' => length}, [content]]
				end
			end
    end
		[status, header, response]
  end

	private

	  def absolute_rails_path(path)
			File.join(Rails.root, "public", path)
		end
end
