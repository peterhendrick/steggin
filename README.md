===============================================================================================


Just steggin' bro!
=======

steggin is a steganography tool for bash.

**Author:** Peter Hendrick

## Requirements and Downloading

To use steggin, you need the Bourne Again Shell (bash) to run it, the git content tracker to download and update, and GnuPG (optional) to verify your download and encrypt/decrypt files while steggin'.

To open bash in mac, do a spotlight search (or look in your Applications folder) for "Terminal" (I prefer "iTerm2" if you have it).

For Windows users, I heard Windows 10 was supposed to get bash. It's about time, because bash is decades old. Good luck if your on windows. Seriously, just get a linux iso and make a bootable usb.

To see if you have git installed type into bash:

```bash
which git
```
If there is a response that looks similar to this, then you have git installed already:

```bash
/usr/local/bin/git
```

If you don't have git, you can install it here: https://git-scm.com/downloads

Similarly, you can see if you have gpg installed. Type:

```bash
which gpg
```

If you see output similar to this, then you have gpg installed already:

```bash
/usr/local/bin/gpg
```

If you don't have gpg installed, you can download it here: https://www.gnupg.org/download/index.html

Once you have git. Type into bash:

```bash
git clone https://github.com/peterhendrick/steggin && cd steggin
```

The rest of this README will assume your bash commands are executed within the steggin directory (folder).


## Verifying Your Download

You are going to want to verify the file you download is legitimate. To do this, I've included a SHASUM file containing a sha256 hash of the steggin.sh script.

When using tools for things like hiding files, you want to have absolute confidence in the legitimacy of your tools. Verifying your downloads is a good habit to get into. Comparing sha256 hashes is good, and will help verify that downloads happen without corruption, but using GnuPG is the ultimate confidence in your tools. If the author uses gpg to sign their tools, you can be as absolutely certain as possible that your tools are legitimate.

After downloading, with your current working directory (cwd) being the steggin directory, type into bash:

```bash
shasum -a 256 steggin.sh && cat SHASUM
```

You should see output similar to this:

```bash
442298e67603b80d4db2e42ba98bb8bd9feb3c652840704e98163949cbbf6f01  steggin.sh
442298e67603b80d4db2e42ba98bb8bd9feb3c652840704e98163949cbbf6f01  steggin.sh
```

If both lines of lines of the output DO NOT match EXACTLY. Then STOP and reflect on what you've done so far. DELETE your steggin folder and re-download. It's possible that something went wrong while downloading.

If both output lines DO match EXACTLY, then that's good, but it is still not enough to be absolutely certain that your download is legitimate. A good hacker could give you a malicious steggin.sh file and update the SHASUM file to match their malicious file.

To defend against this type of attack, I have used GnuPG to sign the SHASUM file.

You are going to want to verify the SHASUM.sig file is a valid gpg signature for the SHASUM file. In order to do this, you will need to import my gpg public key. Type into bash:

```bash
gpg --keyserver hkp://keys.gnupg.net --recv-key EC3ED53D
```

You now have my public key imported on your machine. You can now verify the SHASUM.sig file. In bash type:

```bash
gpg --verify SHASUM.sig SHASUM
```
You should see the following as part of the output:

```bash
gpg: Good signature from "Peter Hendrick <myemail>"
```

If you see the "Good signature", you can be as certain as possible that the SHASUM file is the file I wrote. Verifying the gpg signature along with verifying that the sha256 hash matches the text in the SHASUM file means you can have near absolute certainty that the steggin file downloaded on your computer is Byte for Byte identical to file I wrote. GPG is military grade encryption, so there are no known hacks to break the encryption. The only way for someone to fake my signature is for them to digitally capture my gpg secret key and also know my passphrase for the secret key.


## Getting Started

Now that you've verified the authenticity of the steggin file, you need to give yourself permission to execute the steggin.sh file. Type the command:

```bash
chmod u+x ./steggin.sh
```

Currently, you must use files in the steggin directory. So copy your carrier and secret files to the steggin directory. With ./steggin/ as your cwd, in bash type:

```bash
cp <PATH TO CARRIER FILE> ./
cp <PATH TO SECRET FILE> ./
```

Now you can start steggin' bro.

**ATTENTION:** Do not use a text based file for the carrier file. This could result in the secret message becoming visible.

**ATTENTION:** It is highly recommended for your secret file to be encrypted with GnuPG prior to steggin'. Encrypting with GPG will ensure that even if your hidden file is discovered, it cannot be read by unauthorized people.

**ATTENTION:** It is highly recommended to personally create a movie, audio or photo file in which to use as the carrier file. If you use a personal, original file, it makes it much harder for an unauthorized person to detect that a hidden message exists.

To use steggin to hide a secret file of yours, type into bash:

```bash
./steggin.sh -c <CARRIER_FILE> -s <SECRET_FILE> -o <OUTPUT_FILE>
```

Alternatively, you can type:

```bash
./steggin.sh --carrier=<CARRIER_FILE> --secret=<SECRET_FILE> --output=<OUTPUT_FILE>
```

If all went well, you should see as part of the output:

```bash
!!!!! Sucess file <SECRET_FILE> is hidden in the file <OUTPUT_FILE> !!!!!
```

Congrats!! You just stegged bro. This command will create a new file with the filename you specified after the -o argument. This new file will contain the contents of your secret file, though the secret file will not be visible when hidden in photo, movie or audio files.

## Extracting from a Stegged File

To extract a file that has been previously stegged, type into bash:

```bash
./steggin.sh -e <STEGGED_FILE> -o <OUTPUT_FILE>
```

Alternatively you can type:

```bash
./steggin.sh --extract=<STEGGED_FILE> --output=<OUTPUT_FILE>
```

If all went well, you will see the message:

```bash
!!!!! SUCCESS: EXTRACTED FILE <OUTPUT_FILE> IS IDENTICAL TO ORIGINALLY STEGGED FILE !!!!!
```

steggin takes a SHA 256 hash of the secret file before steggin and compares it to the SHA 256 hash of the extracted file. If the extracted file has been tampered with or modified in any way, steggin will warn you that the file is not Byte for Byte identical to the originally stegged file.

If the file was encrypted with GPG prior to steggin, then you will need to use GPG on your extracted file to decrypt it, type:

```bash
gpg <YOUR_EXTRACTED_FILE>
```

Then enter your password for your GPG secret key to decrypt the message.

## API

-c|--carrier=
    The carrier file that will contain the hidden, secret file.

-s|--secret=
    The secret file you would like to hide in the carrier file.

-e|--extract=
    The name of a previously stegged file in which to extract out a hidden message.

-o|--output=
    The name of the file in which to output the stegged file containing the hidden message. Or in the case of extracting a file, the name of the file in which to extract the hidden, secret file.
