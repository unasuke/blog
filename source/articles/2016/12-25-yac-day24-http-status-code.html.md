---
title: 'やぎすけ Advent Calendar 24日目 status codeの修正'
date: 2016-12-25 10:30 JST
tags:
- programming
- advent_calendar
- yac
- ruby
- rails
---

![pull request](2016/yac_day24_pullrequest.png)

## やぎすけ Advent Calendar
[やぎすけ Advent Calendar 2016 - Adventar](http://www.adventar.org/calendars/1800)

24日目です。遅れましたがやっていきましょう。

## serachにparamsがない場合

> まず最初に必須パラメータのnameがあるかチェック、ない場合はエラーなjsonを返却。

[やぎ小屋 | Ruby on RailsでつくってみるAPI（2日目）](https://blog.yagi2.com/2016/12/22/rails-api-day2.html)

とのことですが、エラーの場合はHTTP status codeもそれ相応のものを返してやったほうがいいと思うので、そうします。

この場合だと400が適当でしょうか。

[List of HTTP status codes - Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

なので、このように書き替えます。

```ruby
def search
  if params[:name].blank?
    render status: 400,  json: [{"error": "100", "msg": "必須パラメーターがありません", "required": {"key": "name"}}]
  else 
    @result = Character.where("name like ?", "%" + params[:name] + "%")

    if @result.empty?
      @result = Character.where("phonetic like ?", "%" + params[:name] + "%")
    end

    render json: @result
  end
end
```

[Return 400 if params is not present · unasuke/imas\_api\_rails@07185c5](https://github.com/unasuke/imas_api_rails/commit/07185c5b29b5083095b5fe10bdc7a58d0f6034dc)
