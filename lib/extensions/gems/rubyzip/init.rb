require File.expand_path(File.dirname(__FILE__) + "/lib/zip/zip")

::Zip::ZipFile.send(:include, ::Shrink::Zip::ZipFile)
