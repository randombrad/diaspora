#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe ActivityStreams::Photo do
  describe '.from_activity' do
    before do
      @json = JSON.parse <<JSON
        {"activity":{"actor":{"url":"http://cubbi.es/daniel","displayName":"daniel","objectType":"person"},"published":"2011-05-19T18:12:23Z","verb":"save","object":{"objectType":"photo","url":"http://i658.photobucket.com/albums/uu308/R3b3lAp3/Swagger_dog.jpg","image":{"url":"http://i658.photobucket.com/albums/uu308/R3b3lAp3/Swagger_dog.jpg","width":637,"height":469}},"provider":{"url":"http://cubbi.es/","displayName":"Cubbi.es"}}}
JSON
      @json = @json["activity"]
    end
    it 'marshals into an object' do
      photo = ActivityStreams::Photo.from_activity(@json)

      photo.image_url.should == @json["object"]["image"]["url"]
      photo.image_height.should == @json["object"]["image"]["height"]
      photo.image_width.should == @json["object"]["image"]["width"]
      photo.object_url.should == @json["object"]["url"]

      photo.provider_display_name.should == @json["provider"]["displayName"]
      photo.actor_url.should == @json["actor"]["url"]
    end

  end

  describe 'serialization' do
    it 'Diaspora::Parser should pick the right class' do
      photo = Factory(:activity_streams_photo)
      xml = photo.to_diaspora_xml.to_s
      Diaspora::Parser.from_xml(xml).class.should == ActivityStreams::Photo
    end
  end
end