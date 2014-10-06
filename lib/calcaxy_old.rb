# encoding: utf-8

class CalcaxyOld

  DEFAULT_FILES = ["index.html", "index.htm", "index.php"]
  File = ::File

  def initialize(app, archive_path)
    @app = app
    @archive_path = archive_path
  end

  def call(env)
    req = Rack::Request.new(env)
    status, header, response = @app.call(env)
    resource_path = req.path

    if status == 404
      if  req.path.start_with? @archive_path
        absolute_resource_path = absolute_rails_path resource_path

        if File.directory?(absolute_resource_path)
          default_file = DEFAULT_FILES.first { |f| File.file?(File.join(absolute_resource_path,f)) }
          # extend requested path with a default file name
          resource_path = File.join(resource_path, default_file) unless default_file.nil?
        end
        return [301, {"Location" => resource_path, "Content-Type" => "text/html"}, "Redirecting to: #{resource_path}"]
      end
    end
    [status, header, response]
  end

  private

    def absolute_rails_path(path)
      File.join(Rails.root, "public", path)
    end
end
