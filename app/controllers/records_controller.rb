class RecordsController < ApplicationController

  def initialize()
    super
    @d3_cats = "/categories"
  end

  def by_tag(tag)
    if tag.class == String
      tag = Tag.find_by(name: tag)
    end
    unless tag
      return nil
    end
    return tag.record
  end

  def by_cat(cat)
    if cat.class == String
      cat = Cat.find_by(name: cat)
    end
    unless cat
      return nil
    end
    return cat.record
  end

  def main( tag = nil, cat = nil, limit = 15, offset = 0 )
    @records = by_cat(cat.gsub('_',' ')) if cat
    @records = by_tag(tag.gsub('_',' ')) if tag
    @records = Record.where(:rtype => ["default", "widget", nil]) if !@records

    @records = @records.limit(limit).offset(offset).to_a
    @columns = 3
    @rec_per_col = @columns.times.map do |col|
      @records.select.with_index{ |x,i| i % @columns == col }
    end
    render template: "main.erb.html"
  end

  def view
    begin
      record_name = params[:name] || ( throw "No record name" )
      @record = Record.find_by!( url_name: record_name )
      type = params[:type] || @record.rtype
      case type || "default"
      when "default" # article
        @content = File.read("#{Blog::RECORDS_PATH}/#{@record.file}")
        render template: "record.erb.html"
      when "about"
        @content = File.read("#{Blog::RECORDS_PATH}/#{@record.file}")
        render template: "about.erb.html"
      when "main"
        main
      when "widget"
      end
    rescue ActiveRecord::RecordNotFound => e
      render_404
      false
    rescue Exception => e
      p e
      throw e
      # some redirect here
    end
  end

  def index
    main( params[:tag_name], params[:cat_name] )
  end

  def about
    params[:name] = "about"
    view
  end
end
