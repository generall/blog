class ApisController < ApplicationController
  # retirn json stats
  def stats
    @stats = {
      records: Record.count,
      tags_count: Tag.count,
      record_per_tag: Tag.all.map { |x| { name: x.name, count: x.record.count }},
      cat_count: Cat.count,
      record_per_cat: Cat.all.map { |x| { name: x.name, count: x.record.count }}
    }
    render json: @stats
  end
  
  # data for graph rendering
  def graph
    records = Record.where(:rtype => [nil, "default"])
    index_lookup = records.map.with_index{|x, idx| [x, idx]}.to_h
    tag_groups = Tag.all.map { |x| x.record.map { |y| index_lookup[y] } }.select{|x| x.size > 1}
    links_by_tags = tag_groups.map{ |tg| tg.combination(2)}
    links = Hash.new(0)
    links_by_tags.each do |links_by_tag|
      links_by_tag.each do |link|
        links[link] += 1;
      end
    end

    @graph = {
      nodes:
      records.map do |rec|
        {
          name: rec.name,
          group: rec.cat.id,
          cat: rec.cat.name,
          cat_link: "/cat/" + rec.cat.name.gsub(/\s/, "_")
        }
      end,
      links: links.map do |key, val|
        {
          source: key[0],
          target: key[1],
          value:  val
        } 
      end,
      cats: Cat.all
            .select{|x| !["main","about","default"].include?(x.name)}
            .map.with_index {|x, num| {num: num,   name: x.name, id:x.id} }
    }
      render json: @graph
  end

  # records description
  def records
    @graph = Record.all.map do |rec|
      {
        name: rec.name,
        cat: rec.cat.name,
        tags: rec.tag.map{|x| x.name}
      }
    end
    render json: @graph
  end
end
