Pod::Spec.new do |s|
  s.name     = 'NSMutableURLRequest+ApiAuth'
  s.version  = '0.1.1'
  s.summary  = 'ApiAuth support for NSMutableURLRequest.'
  s.homepage = 'https://github.com/FWKamil/NSMutableURLRequest-ApiAuth'
  s.author   = { 'Kamil Kocemba' => 'kamil@futureworkshops.com' }
  s.source   = { :git => 'git@github.com:FWKamil/NSMutableURLRequest-ApiAuth.git', :tag => '0.1.1' }
  s.source_files = '*.{h,m}'
  s.requires_arc = true
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
end
