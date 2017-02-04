#!/usr/bin/env ruby
require 'nokogiri'
require 'uri'
f = File.open("dump.xml")

provider_all  = File.open("dump-all.provider","w")
@provider_urls = File.open("urls.provider","w")
@provider_domains = File.open("domains.provider","w")
@provider_ip  = File.open("ip.provider","w")
@provider_http = File.open("http.provider","w")
@provider_https = File.open("https.provider","w")

def encode_urls (u)

        #@provider_urls.puts  URI::encode(u)
        @provider_urls.puts  u
#       @provider_urls.puts URI.unescape(u) 

end

def line_domain(d)
        if d["/"]
                then 
                d["/"] = ""
                #www_domain(d)
                  @provider_domains.puts d
        else
                #www_domain(d)
                  @provider_domains.puts d
        end
end

def www_domain(d)
        if  d["www."] 
                then 
                  d["www."] = ""
                  @provider_domains.puts d
        else  
                  @provider_domains.puts d
        end
end

def provider(urls)
                i = 1 
                k  = urls.index(/\//).to_i
                if k != 0 then
                        t = k + 1
                        #url = URI.unescape(urls)
                        encode_urls(urls) if  urls[t] != nil
                #       @provider_domains.puts "#{www_domain(urls)}" if  urls[t] == nil
                        line_domain(urls) if  urls[t] == nil
                        i = i + 1
                else
                        line_domain(urls) 
                end
end


def provider_http(url)
                i = 1 
                k  = url.index(/\//).to_i
                if k != 0 then
                        t = k + 1
                        @provider_urls.puts "http://#{url}" if  url[t] != nil
                        @provider_domains.puts "http://#{url}" if  url[t] == nil
                        i = i + 1
                else
                        @provider_domains.puts "http://#{url}" 
                end
end


def provider_https(url)
                i = 1
                k  = url.index(/\//).to_i
                if k != 0 then
                        t = k + 1
                        @provider_urls.puts "https://#{url}" if  url[t] != nil
                        @provider_domains.puts "https://#{url}" if  url[t] == nil
                        i = i + 1
                else
                        @provider_domains.puts "https://#{url}"
                end
end

doc = Nokogiri::XML(f) do |config|
        config.strict.nonet
end

doc.search('ip').each do |link|
         @provider_ip.puts link.content.gsub(",","\n")
end

doc.search('url').each do |link|
        mas = link.content
        case
        when mas["http://"]
             mas["http://"] = ""
        provider(mas)
        @provider_http.puts mas
        when mas["https://"]
             mas["https://"] = ""
        provider(mas)
        @provider_https.puts mas

        else
        provider(mas)

        end
end

provider_all.puts doc
f.close

