Pod::Spec.new do |s|
  s.name         = "DSFLabelledTextField"
  s.version      = "1.1.0"
  s.summary      = "A simple macOS labelled text field using Swift"
  s.description  = <<-DESC
    A simple macOS labelled text field using Swift
  DESC
  s.homepage     = "https://github.com/dagronf/DSFLabelledTextField"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Darren Ford" => "dford_au-reg@yahoo.com" }
  s.social_media_url   = ""
  s.osx.deployment_target = "10.11"
  s.source       = { :git => ".git", :tag => s.version.to_s }
  s.source_files  = "Sources/DSFLabelledTextField/*.swift"
  s.frameworks  = "AppKit"
  s.swift_version = "5.2"
end
