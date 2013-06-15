module FBPhoto
  def get_timeline(access_token, year)
    from = Time.new(year, 01, 01).to_i
    to = Time.new(year+1, 01, 01).to_i
    api = Koala::Facebook::API.new(access_token)
    res = api.fql_multiquery(
      photos: "SELECT object_id, pid, src_big, created, caption, like_info.like_count, comment_info.comment_count, src_big_height, src_big_width FROM photo WHERE
          pid IN (SELECT pid FROM photo_tag WHERE subject=me() AND created > #{from} AND created < #{to} LIMIT 1000) OR
          pid IN (SELECT pid FROM photo WHERE owner=me() AND created > #{from} AND created < #{to} LIMIT 1000)
        ORDER BY like_info.like_count DESC LIMIT 150",
      comments: "SELECT object_id, text FROM comment WHERE object_id IN (SELECT object_id FROM #photos)"
      )

    return_photos = []
    comments = res["comments"]
    photos = res["photos"]

    res["photos"].each do |r|
      width = 400 + 3*[r["like_info"]["like_count"]*10, 100].min
      caption = r["caption"]
      height = r["src_big_height"]*width/r["src_big_width"]

      if caption.empty?
        t = res["comments"].keep_if { |elem| elem["object_id"]==r["object_id"] }.first
        caption = t["text"] if t.present?
      end

      return_photos << {src: r["src_big"], caption: caption, width: width, height: height, created: r["created"], like_count: r["like_info"]["like_count"], comment_count: r["comment_info"]["comment_count"]}
    end

    return_photos.sort { |x,y| y[:caption].length <=> x[:caption].length }.first(30)
  end

  def get_yearrange(access_token)
    api = Koala::Facebook::API.new(access_token)
    res = api.fql_query("SELECT modified FROM photo WHERE owner=me() ORDER BY modified ASC LIMIT 1")
    to = Time.now.year
    from = Time.at(res[0]["modified"]).year
    (from..to).to_a
  end
end
