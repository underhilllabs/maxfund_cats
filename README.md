Ruby app for viewing current adoptable cats at Maxfund. Also includes cats that have been adopted in a different background color.


To run the webscraper to scrape the maxfund website and create the sqlite database in **data/maxfund_cats.rb**
```bash
ruby lib/maxfund-scraper.rb
```

To run the sinatra app, point the webserver at:
```bash
ruby app.rb
```
