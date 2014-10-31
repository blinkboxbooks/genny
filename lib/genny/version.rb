module Genny
  VERSION = begin
    File.read(File.join(__dir__, "../../../VERSION")).strip
  rescue Errno::ENOENT
    "0.0.0-unknown"
  end
end
