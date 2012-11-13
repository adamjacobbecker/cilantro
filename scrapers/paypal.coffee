Browser = require 'zombie'
moment = require 'moment'
cheerio = require 'cheerio'

module.exports = (accountConfig, cb) ->

  browser = new Browser
    runScripts: false
  browser.visit "https://www.paypal.com/", ->

    browser.fill "login_email", accountConfig.username
    browser.fill "login_password", accountConfig.password
    browser.pressButton "Log in", ->
      browser.clickLink "click here", ->

        browser.clickLink "View all of my transactions", ->

          parseResults()


  parseResults = ->
    $ = cheerio.load(browser.response.body)

    account =
      name: "Paypal"
      balance: $(".amount p").text().replace(/[A-Z\s\$]/g, "")
      transactions: []

    $("#transactionTable tr").each ->
      if $(this).find(".dateInfo").text()

        transaction =
          bank_id: $(this).attr('id')
          amount: $(this).find(".cur_val").eq(2).text().replace(/[A-Z\s\$]/g, "")
          name: $(this).find(".wrapEmail").text()
          date: moment($(this).find(".dateInfo").text(), "MMM DD, YYYY").unix() * 1000

        account.transactions.push transaction

    return cb(null, [account])