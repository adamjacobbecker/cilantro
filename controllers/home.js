// Generated by CoffeeScript 1.3.3
(function() {
  var Account, Transaction, fs, moment, _;

  Account = require('../models').account;

  Transaction = require('../models').transaction;

  moment = require('moment');

  fs = require('fs');

  _ = require('underscore');

  exports.index = function(req, res) {
    return Account.find({}, function(err, accounts) {
      var lastUpdated, total;
      total = 0;
      lastUpdated = 0;
      _.each(accounts, function(account) {
        total = total + account.balance;
        if (account.updated_at > lastUpdated) {
          return lastUpdated = account.updated_at;
        }
      });
      return Transaction.find().populate('_account').exec(function(err, transactions) {
        var transactionsJson;
        transactionsJson = [];
        _.each(transactions, function(transaction) {
          return transactionsJson.push(transaction.toObject());
        });
        return res.render("home/index", {
          accounts: accounts,
          total: "$" + total,
          transactions: JSON.stringify(transactionsJson),
          lastUpdated: lastUpdated
        });
      });
    });
  };

  exports.sync = function(req, res) {
    var account, accounts, parseTransactions, saveResults, useDevMode, _i, _len, _results;
    accounts = require('../accounts');
    parseTransactions = function(account, transactions, results) {
      var resultTransaction;
      if (transactions.length === 0) {
        return saveResults(results);
      }
      resultTransaction = transactions.shift();
      return Transaction.findOneAndUpdate({
        _account: account._id,
        bank_id: resultTransaction.bank_id || (resultTransaction.date + resultTransaction.name)
      }, {
        date: resultTransaction.date,
        name: resultTransaction.name,
        amount: parseFloat(resultTransaction.amount.replace(",", ""))
      }, {
        upsert: true
      }, function(err, transaction) {
        return parseTransactions(account, transactions, results);
      });
    };
    useDevMode = req.param('dev') ? true : false;
    _results = [];
    for (_i = 0, _len = accounts.length; _i < _len; _i++) {
      account = accounts[_i];
      saveResults = function(results) {
        var result;
        if (results.length === 0) {
          return res.send("Done!");
        }
        result = results.shift();
        return Account.findOneAndUpdate({
          name: result.name
        }, {
          balance: parseFloat(result.balance.replace(",", "")),
          updated_at: Date.now()
        }, {
          upsert: true
        }, function(err, account) {
          return parseTransactions(account, result.transactions, results);
        });
      };
      _results.push((function() {
        var scraper;
        if (useDevMode) {
          return saveResults(JSON.parse(fs.readFileSync("scrapers/example_output/" + account.file + ".json", 'utf-8')));
        } else {
          scraper = require("../scrapers/" + account.file);
          return scraper(account, saveResults);
        }
      })());
    }
    return _results;
  };

}).call(this);
