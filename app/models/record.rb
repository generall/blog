require 'yaml'

RANDOM_IMAGES = ["/img/random1.jpg", "/img/random2.jpg", "/img/random3.jpg"]

class Record < ActiveRecord::Base

  belongs_to :cat
  has_and_belongs_to_many :tag

  def self.convert_name(name)
    name.downcase.gsub(/\s/, "-").gsub(/[^a-z0-9\-\s]/,"")
  end

  def self.parse_file(fname)
    html_doc = Nokogiri::HTML(File.open("#{Blog::RECORDS_PATH}/#{fname}"), nil, Encoding::UTF_8.to_s);
    snippet = html_doc.css("p").first.text rescue nil
    caption = html_doc.css("h1").first.text rescue nil
    image   = html_doc.css("img").first.attribute("src") rescue nil
    {"snippet" => snippet, "caption" => caption, "img" => image}
  end

  def self.reimport()
    Record.destroy_all
    Tag.destroy_all
    Cat.destroy_all
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, :fenced_code_blocks => true)
    ActiveRecord::Base.transaction do
      config = YAML.load( File.read( Blog::RECORDS_CONFIG_PATH ) )
      records = config['records']
      records.each do |record|
        dbrecord = Record.new
        dbrecord.name = record["name"]
        dbrecord.file = record["file"]
        # If file extension is Markdown - convert it to html first.
        if dbrecord.file && File.extname(dbrecord.file) == '.md'
          md = markdown.render(File.read("#{Blog::RECORDS_PATH}/#{dbrecord.file}"))
          File.write("#{Blog::RECORDS_PATH}/#{dbrecord.file}.html", md)
          dbrecord.file = "#{dbrecord.file}.html"
        end
        dbrecord.rtype = record["type"]
        dbrecord.url_name = convert_name( record["name"] )
        dbrecord.time = record["time"] || Date.today
        dbrecord.cat = Cat.find_or_create_by( name: record["cathegory"] || "default" )

        if dbrecord.file
          data = parse_file(dbrecord.file)
          dbrecord.snippet = data["snippet"] # first <p>
          dbrecord.caption = data["caption"] || record["name"] # first <h1>
          dbrecord.img     = record["img"] || data["img"] || RANDOM_IMAGES.sample # first img src or random image
        end

        tags = record["tags"] || []
        tags.each do |tag|
          dbrecord.tag.push Tag.find_or_create_by(name: tag);
        end
        dbrecord.save
      end
    end
  end

end
