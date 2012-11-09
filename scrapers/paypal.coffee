Browser = require 'zombie'

config = require('./config')

browser = new Browser
  debug: true
  runScripts: false
browser.visit "https://www.paypal.com/", ->

  browser.fill "login_email", config.paypal.username
  browser.fill "login_password", config.paypal.password
  browser.pressButton "Log in", ->
    console.log browser.text("title")
    browser.clickLink "click here", ->
      console.log browser.text("span.balance strong")

      browser.clickLink "View all of my transactions", ->
        console.log browser.text("title")

        browser.select "#download_file_type", "Tab Delimited - All Activity", ->
          browser.pressButton "#noScriptDownload input.button", ->
            console.log browser.response.body
