require "arb/crawler/version"

require 'nokogiri'
require 'httpclient'
require 'arb/str'

module Arb
  module Crawler
    class << self
      client=HTTPClient.new
      methods=%w{delete get post put}
      ways=%w{css xpath}

      define_method :default_client do
        client
      end

      define_method :filter_str do |str, black_list=nil|
      black_list||=%w{\ / : * ? < > |} << "\n"
      black_list.each do |i|
        loop do
          break unless str.sub!(i,'')
        end
      end
      str
      end

      define_method :filename_of_url do |url|
        url && url[url.rindex('/')+1..-1]
      end

      define_method :download do |url,file|
        begin
          data=nil
          File.open file,'wb+' do |file|
            data=client.get(url).body
            file<<data
          end
        rescue Exception=>e
          $stderr.puts e
          nil
        end
        data.size
      end

      methods.each do |method|
        ways.each do |way|
          define_method "#{method}_by_#{way}_raw" do |url,css_or_xpath,&blk|
            begin
              ::Nokogiri.parse(client.send(method,url).body).send(way,css_or_xpath).tap do |res|
                if blk
                  res.each do |e|
                    blk[e]
                  end
                end
              end
            rescue Exception=>e
              $stderr.puts e
              nil
            end
          end

          #Make sure that the content_key distinct from those attribute keys
          define_method "#{method}_by_#{way}" do |url,css_or_xpath,content_key=:text,&blk|
            [].tap do |arr|
              raw=send("#{method}_by_#{way}_raw",url,css_or_xpath)
              raw && raw.each do |nokogiri_element|
                arr<<Hash.new.tap do |hash|
                  nokogiri_element.attributes.keys.each do |key|
                    hash[key.to_sym]=nokogiri_element.attribute(key).value
                  end
                  if hash.keys.include?(content_key.to_sym)
                    puts("Warning: Content key #{content_key} can not be used due to conflict!")
                  else
                    hash[content_key]=nokogiri_element.text
                  end
                  blk[hash] if blk
                end
              end
            end
          end

        end
      end
    end

  end
end
