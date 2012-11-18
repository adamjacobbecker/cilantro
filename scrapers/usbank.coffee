Browser = require 'zombie'
cheerio = require 'cheerio'
_ = require 'underscore'
moment = require 'moment'

module.exports = (accountConfig, cb) ->

  browser = new Browser
    userAgent: "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"
    runScripts: false

  browser.visit "https://m.usbank.com/mobile-web/index.asp?msg=", ->
    browser.fill "username", accountConfig["Personal ID"]
    browser.pressButton "Go", ->
      browser.fill "txtPassword", accountConfig.Password
      browser.pressButton "Log In", ->
        $ = cheerio.load(browser.response.body)

        account =
          name: $("#listAccounts").find("td").eq(0).text()
          balance: "-" + $("#listAccounts").find("td").eq(1).text()
          scraper_id: accountConfig.scraper_id
          transactions: []

        browser.clickLink "#listAccounts td:eq(0) a", ->
          $ = cheerio.load(browser.response.body)

          $("#listTransactions tr").each (index, element) ->
            rawDate = $(this).find("td").eq(0).text().match(/[0-9\/]*/)[0]

            transaction =
              date: moment(rawDate, "MM/DD/YYYY").unix() * 1000
              name: $(this).find("td").eq(0).text().replace(/[0-9\/]*/, "")
              amount: $(this).find("td").eq(1).text().replace(/\$|\,/g, "")

            account.transactions.push transaction

          return cb(null, [account])
