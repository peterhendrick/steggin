Just steggin' bro!

steggin is a steganography tool written in the bash scripting language.

Author: Peter Hendrick

To use steggin, you need the Bourne Again Shell (bash).

To download, type the command:
git clone https://github.com/peterhendrick/steggin && cd steggin

The Commands used in this README file assume your current working directory is the steggin folder.

You are going to want to verify the file you download is legitimate. To do
this, I've included a SHASUM file.

Type the command:

shasum -a 256 steggin.sh && cat SHASUM

If both lines of the output match exactly, then you can be confident that the steggin.sh file you've
downloaded matches the steggin.sh file that I wrote. If they do not match, you may have a corrupt download.
Delete the project, and redownload.

If they do match, this is not enough to be certain that the SHASUM and steggin.sh file you have is legitimate.
An attacker could replace the steggin.sh file and the SHASUM file to match their malicious steggin.sh file.

To defend against this type of attack, I've included a signature file, and I've signed it with my gpg private key.

You'll need to import my public GPG key. Type the command:

gpg --keyserver hkp://keys.gnupg.net --recv-key EC3ED53D

Then to verify the SHASUM file has not been tampered with, type:

gpg --verify SHASUM.sig SHASUM

The following should be part of the output:

gpg: Good signature from "Peter Hendrick <peterjhendrick@gmail.com>"

If you see the "Good signature", you can be as certain as possible that the SHASUM file is the file I wrote.
Verifying the gpg signature along with verifying that the sha256 hash matches the text in the SHASUM file means
you can have absolute certainty that the steggin file downloaded on your computer is Byte for Byte identical to
file I wrote. GPG is military grade encryption, so there are no known hacks to break the encryption.

Now that you've verified the authenticity of the steggin file, you need to give yourself permission to execute the steggin.sh file. Type the command:

chmod u+x ./steggin.sh"


Currently, you must use files in the steggin directory. So copy your carrier and secret files to the steggin directory:

cp [PATH TO CARRIER FILE] ./

cp [PATH TO SECRET FILE] ./

Now you can start steggin' bro.

Attention: Do not use a text based file for the carrier file. This could result in the secret message
becoming visible.

To hide a file in a carrier file, type:

./steggin.sh [CARRIER FILE] [SECRET FILE]

You just stegged bro. This command will create a file named "justStegginBro-[NAME OF CARRIER FILE]" and will contain your hidden file.

It is recommended (but not required) that you use an original photo, movie or audio file as a carrier file. Original meaning one you created yourself. Using an original file will make it much harder for unauthorized detection of the hidden message.

It is also recommended that you use GPG encryption on your secret file prior to steggin. Once the .gpg file is extracted, you can use GPG to decrypt it.


Using gpg to encrypt the secret file prior to steggin will ensure that even if the stegged message is discovered,
only the intended recipient will be able to view the extracted contents.


To extract a file that has been previously stegged, type:

./steggin.sh [PATH TO STEGGED FILE]

If all went well, you will see the message:

"SUCCESS: EXTRACTED FILE IS IDENTICAL TO ORIGINALLY STEGGED FILE"

steggin takes a SHA 256 hash of the secret file before steggin and compares it to the SHA 256 hash of the extracted file. If the extracted file has been tampered with, steggin will still extract the file, but it will warn you of the tampering.

This will extract the hidden file into the current working directory and name the file "extractedFile". The file won't have an extension.

You'll want to rename the extracted file immediately because if you try to extract from another stegged file, it will overwrite a previously extractedFile

To rename the file, type:

mv extractedFile [YOUR FILE NAME]

If the file was encrypted with GPG prior to steggin, then you will need to use GPG on extractedFile to decrypt it, type:

gpg [YOUR EXTRACTED FILE]

Then enter your password for your GPG secret key to decrypt the message.

===============================================================================================


Bitcore
=======

[![NPM Package](https://img.shields.io/npm/v/bitcore.svg?style=flat-square)](https://www.npmjs.org/package/bitcore)
[![Build Status](https://img.shields.io/travis/bitpay/bitcore.svg?branch=master&style=flat-square)](https://travis-ci.org/bitpay/bitcore)

Infrastructure to build Bitcoin and blockchain-based applications for the next generation of financial technology.

**Note:** If you're looking for the Bitcore Library please see: https://github.com/bitpay/bitcore-lib

## Getting Started

Before you begin you'll need to have Node.js v4 or v0.12 installed. There are several options for installation. One method is to use [nvm](https://github.com/creationix/nvm) to easily switch between different versions, or download directly from [Node.js](https://nodejs.org/).

```bash
npm install -g bitcore
```

Spin up a full node and join the network:

```bash
npm install -g bitcore
bitcored
```

You can then view the Insight block explorer at the default location: `http://localhost:3001/insight`, and your configuration file will be found in your home directory at `~/.bitcore`.

Create a transaction:
```js
var bitcore = require('bitcore');
var transaction = new bitcore.Transaction();
var transaction.from(unspent).to(address, amount);
transaction.sign(privateKey);
```

## Applications

- [Node](https://github.com/bitpay/bitcore-node) - A full node with extended capabilities using Bitcoin Core
- [Insight API](https://github.com/bitpay/insight-api) - A blockchain explorer HTTP API
- [Insight UI](https://github.com/bitpay/insight) - A blockchain explorer web user interface
- [Wallet Service](https://github.com/bitpay/bitcore-wallet-service) - A multisig HD service for wallets
- [Wallet Client](https://github.com/bitpay/bitcore-wallet-client) - A client for the wallet service
- [CLI Wallet](https://github.com/bitpay/bitcore-wallet) - A command-line based wallet client
- [Angular Wallet Client](https://github.com/bitpay/angular-bitcore-wallet-client) - An Angular based wallet client
- [Copay](https://github.com/bitpay/copay) - An easy-to-use, multiplatform, multisignature, secure bitcoin wallet

## Libraries

- [Lib](https://github.com/bitpay/bitcore-lib) - All of the core Bitcoin primatives including transactions, private key management and others
- [Payment Protocol](https://github.com/bitpay/bitcore-payment-protocol) - A protocol for communication between a merchant and customer
- [P2P](https://github.com/bitpay/bitcore-p2p) - The peer-to-peer networking protocol
- [Mnemonic](https://github.com/bitpay/bitcore-mnemonic) - Implements mnemonic code for generating deterministic keys
- [Channel](https://github.com/bitpay/bitcore-channel) - Micropayment channels for rapidly adjusting bitcoin transactions
- [Message](https://github.com/bitpay/bitcore-message) - Bitcoin message verification and signing
- [ECIES](https://github.com/bitpay/bitcore-ecies) - Uses ECIES symmetric key negotiation from public keys to encrypt arbitrarily long data streams.

## Documentation

The complete docs are hosted here: [bitcore documentation](http://bitcore.io/guide/). There's also a [bitcore API reference](http://bitcore.io/api/) available generated from the JSDocs of the project, where you'll find low-level details on each bitcore utility.

- [Read the Developer Guide](http://bitcore.io/guide/)
- [Read the API Reference](http://bitcore.io/api/)

To get community assistance and ask for help with implementation questions, please use our [community forums](http://bitpaylabs.com/c/bitcore).

## Security

We're using Bitcore in production, as are [many others](http://bitcore.io#projects), but please use common sense when doing anything related to finances! We take no responsibility for your implementation decisions.

If you find a security issue, please email security@bitpay.com.

## Contributing

Please send pull requests for bug fixes, code optimization, and ideas for improvement. For more information on how to contribute, please refer to our [CONTRIBUTING](https://github.com/bitpay/bitcore/blob/master/CONTRIBUTING.md) file.

This will generate files named `bitcore.js` and `bitcore.min.js`.
