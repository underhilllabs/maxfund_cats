Ruby app for viewing current adoptable cats at Maxfund. Also includes cats that have been adopted in a different background color.

## Download Dependencies
Run bundle install.
```
bundle install
```


## Running the Web Scraper

To run the webscraper to scrape the maxfund website and create the sqlite database in **data/maxfund_cats.rb**
```bash
ruby lib/maxfund-scraper.rb
```

## Running Web Application

To run the sinatra app locally
```bash
ruby app.rb
```
Next open up http://localhost:4567 in a browser.

To run the Sinatra app on a public webserver:
```bash
ruby app.rb -o 0.0.0.0
```
