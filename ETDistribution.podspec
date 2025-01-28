Pod::Spec.new do |spec|
  spec.name         = 'ETDistribution'
  spec.version      = '0.2.0'
  spec.summary      = 'iOS app installer.'
  spec.homepage     = 'https://github.com/EmergeTools/ETDistribution'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors = "Emerge Tools"
  spec.source       = { :git => 'https://github.com/EmergeTools/ETDistribution.git', :tag => 'v0.2.0' }
  spec.platform     = :ios, '13.0'
  spec.swift_version = '5.10'
  spec.source_files  = 'Sources/**/*.{swift,h,m}'
end
