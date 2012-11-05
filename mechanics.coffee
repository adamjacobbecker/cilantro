Browser = require 'zombie'

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
      console.log browser.text("title")
