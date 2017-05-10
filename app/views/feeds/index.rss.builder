xml.instruct!
xml.rss :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title 'WVU Libraries Daily Hours'
    xml.link root_url
    xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: feed_url
    xml.description 'WVU Libraries Daily Hours'
    xml.lastbuilddate Time.now.strftime('%a, %d %b %Y %H:%M:%S %Z')
    xml.language 'en-us'

    @resources.each do |resource|
      xml.item do
        xml.title resource[:name]
        xml.link hours_url('id' => resource[:id].to_s, 'type' => resource[:type])
        xml.guid hours_url('id' => resource[:id].to_s, 'type' => resource[:type])
        xml.url hours_url('id' => resource[:id].to_s, 'type' => resource[:type])
        xml.description do
          if resource[:open_close_time].nil?
            xml.cdata!(h(resource[:comment]))
          else
            xml.cdata!(h(resource[:open_close_time]))
          end
        end
        xml.library do
          xml.cdata! resource[:name]
        end
        xml.hours do
          if resource[:open_close_time].nil?
            xml.cdata!(h(resource[:comment]))
          else
            xml.cdata!(h(resource[:open_close_time]))
          end
        end
        xml.opentimestamp resource[:open_time_stamp]
        xml.closetimestamp resource[:close_time_stamp]
      end
    end
  end
end
