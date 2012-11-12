Browser = require 'zombie'
cheerio = require 'cheerio'
_ = require 'underscore'
moment = require 'moment'

module.exports = (accountConfig, cb) ->

  browser = new Browser
    debug: true
    runScripts: false

  browser.visit "https://www.mechanicsbank.com/m", ->

    browser.fill "userid", accountConfig.username
    browser.fill "password", accountConfig.password
    browser.pressButton "[name=Login]", ->

      browser.fill "[name=ans]:eq(0)", accountConfig.answer1
      browser.fill "[name=ans]:eq(1)", accountConfig.answer2
      browser.fill "[name=ans]:eq(2)", accountConfig.answer3

      browser.pressButton "[name=continue]", ->

        parse_accounts(browser)

  accounts = []
  initialAccounts = []

  parse_accounts = (browser) ->

    $ = cheerio.load(browser.response.body)

    $("form[name=accountList] .S_stack").each (index, el) ->
      if $(this).find(".data a.BE").length > 0
        account =
          name: $(this).find(".data a.BE").text()
          balance: $(this).find(".data").text().match(/Account Balance \$([0-9\.\,]+)/)[1]
          transactions: []
          domIndex: index

        initialAccounts.push account

    return find_transactions(initialAccounts, browser)

  endDate = moment().format('MMDDYYYY')
  startDate = moment().subtract('days', 90).format('MMDDYYYY')

  find_transactions = (initialAccounts, browser) ->

    if initialAccounts.length is 0 then return cb(accounts)

    account = initialAccounts.shift()

    $ = cheerio.load(browser.response.body)

    browser.visit $("form[name=accountList] .S_stack").eq(account.domIndex).find("a.BE").attr('href'), ->
      browser.fill "startDate", startDate
      browser.fill "endDate", endDate

      browser.pressButton "form[name=accountHistory] input[type=image]", ->

        $ = cheerio.load(browser.response.body)

        $("form[name=accountHistory] .S_stack").each (index, el) ->

          rawDate = $(this).find("tr").eq(0).find("td").eq(0).text()

          transaction =
            amount: $(this).find("tr").eq(0).find("td").eq(1).text()
            name: $(this).find("tr").eq(1).find("td").eq(0).find("a").text()
            date: if rawDate is "Pending" then Date.now() else moment(rawDate, "MM-DD-YYYY").unix() * 1000

          console.log transaction
          account.transactions.push transaction

        accounts.push account

        browser.visit $(".tapMenu a").eq(0).attr('href'), ->
          find_transactions(initialAccounts, browser)