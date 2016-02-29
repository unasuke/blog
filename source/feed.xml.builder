xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = "https://blog.unasuke.com/"
  xml.title "うなすけとあれこれ"
  xml.subtitle "うなすけとあれこれ"
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name "うなすけ" }

  xml.entry do
    xml.title blog.articles[0].title
    xml.link "rel" => "alternate", "href" => URI.join(site_url, blog.articles[0].url)
    xml.id URI.join(site_url, blog.articles[0].url)
    xml.published blog.articles[0].date.to_time.iso8601
    xml.updated File.mtime(blog.articles[0].source_file).iso8601
    xml.author { xml.name "うなすけ" }
    # xml.summary article.summary, "type" => "html"
    xml.content blog.articles[0].body, "type" => "html"
  end
end
