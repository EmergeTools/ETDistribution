Pod::Spec.new do |spec|
  spec.name         = 'ETDistribution'
  spec.version      = '0.1.1'
  spec.summary      = 'iOS app installer.'
  spec.homepage     = 'https://github.com/EmergeTools/ETDistribution'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'YourName' => 'youremail@example.com' }
  spec.source       = { :git => 'https://github.com/EmergeTools/ETDistribution.git', :tag => 'v0.1.1' }
  spec.platform     = :ios, '13.0'
  spec.swift_version = '5.10'
  spec.source_files  = 'Sources/**/*.{swift,h,m}'
end
