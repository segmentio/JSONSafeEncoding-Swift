Pod::Spec.new do |s|
  s.name             = "JSONSafeEncoding"
  s.version          = "2.0.0"
  s.summary          = "The JSONEncoder wrapper"

  s.description      = <<-DESC 
  This library is a direct copy of JSONEncoder and it's associated types.  It expands upon JSONEncoder's `nonConformingFloatEncodingStrategy` to give developers more options in how to handle NaN / Infinity / -Infinity values.
                       DESC

  s.homepage         = "http://segment.com/"
  s.license          =  { :type => 'MIT' }
  s.author           = { "Segment" => "friends@segment.com" }
  s.source           = { :git => "https://github.com/CoachNow/JSONSafeEncoding-Swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/segment'

  s.swift_version = '4.0'
  s.platform     = :ios, '11.0'
  s.requires_arc = true

  s.source_files = 'Sources/JSONSafeEncoding/**/*'
  s.static_framework = true
end
