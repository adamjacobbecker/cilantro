Browser = require 'zombie'
cheerio = require 'cheerio'
_ = require 'underscore'
moment = require 'moment'

config = require('./config')

browser = new Browser
  debug: true
  runScripts: false

browser.visit "https://www.mechanicsbank.com/m", ->

  browser.fill "userid", config.mechanics.username
  browser.fill "password", config.mechanics.password
  browser.pressButton "[name=Login]", ->
    console.log browser.text("title")

    browser.fill "[name=ans]:eq(0)", config.mechanics.answer1
    browser.fill "[name=ans]:eq(1)", config.mechanics.answer2
    browser.fill "[name=ans]:eq(2)", config.mechanics.answer3

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

  find_transactions(initialAccounts, browser)

endDate = moment().format('MMDDYYYY')
startDate = moment().subtract('days', 90).format('MMDDYYYY')

find_transactions = (initialAccounts, browser) ->

  console.log initialAccounts

  if initialAccounts.length is 0 then return console.log 'done'

  account = initialAccounts.shift()

  $ = cheerio.load(browser.response.body)

  browser.visit $("form[name=accountList] .S_stack").eq(account.domIndex).find("a.BE").attr('href'), ->
    browser.fill "startDate", startDate
    browser.fill "endDate", endDate

    browser.pressButton "form[name=accountHistory] input[type=image]", ->

      $ = cheerio.load(browser.response.body)

      $("form[name=accountHistory] .S_stack").each (index, el) ->
        transaction =
          amount: $(this).find("tr").eq(0).find("td").eq(1).text()
          name: $(this).find("tr").eq(1).find("td").eq(0).find("a").text()
          date: $(this).find("tr").eq(0).find("td").eq(0).text()

        account.transactions.push transaction

      console.log account
      accounts.push account

      browser.visit $(".tapMenu a").eq(0).attr('href'), ->

        find_transactions(initialAccounts, browser)

