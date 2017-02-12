# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arb/crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "arb-crawler"
  spec.version       = Arb::Crawler::VERSION
  spec.authors       = ["arybin"]
  spec.email         = ["arybin@163.com"]

  spec.summary       = %q{Web page crawler.}
  spec.description   = %q{Web page crawler.}
  spec.homepage      = "https://github.com/arybin-cn/arb-crawler"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "arb-str"
  spec.add_dependency "nokogiri"
  spec.add_dependency "httpclient"
end
