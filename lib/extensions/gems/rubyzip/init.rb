require File.expand_path("../lib/zip/zip", __FILE__)

::Zip::ZipFile.send(:include, ::Shrink::Zip::ZipFile)
