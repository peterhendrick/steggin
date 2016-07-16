Just steggin' bro!

steggin is a steganography tool written in the bash scripting language.

Author: Peter Hendrick

To use steggin, you need the Bourne Again Shell (bash).

To download, type the command, "git clone https://github.com/peterhendrick/steggin && cd steggin"

You need to give yourself permission to execute the steggin.sh file. Type "chmod u+x ./steggin.sh"

Currently, you must use files in the steggin directory. So copy your carrier and secret files to the steggin directory:

cd [PATH TO steggin DIRECTORY]

cp [PATH TO CARRIER FILE] ./

cp [PATH TO SECRET FILE] ./

Now you can start steggin' bro.

To hide a file in a carrier file, type:

./steggin.sh [CARRIER FILE] [SECRET FILE]

You just stegged bro. This command will create a file named "justStegginBro-[NAME OF CARRIER FILE]" and will contain your hidden file.

It is recommended (but not required) that you use an original image, movie or audio file as a carrier file. Original meaning one you created yourself.

Using an original file will make it much harder for unauthorized detection of the hidden message.

It is also recommended that you use GPG encryption on your secret file prior to steggin. Once the .gpg file is extracted, you can use GPG to decrypt it.


Using gpg to encrypt the secret file prior to steggin will ensure that even if the stegged message is discovered,
only the intended recipient will be able to view the extracted contents.


To extract a file that has been previously stegged, type:

./steggin.sh [PATH TO STEGGED FILE]

This will extract the hidden file into the current working directory and name the file "extractedFile". The file won't have an extension.

Then enter your password for your GPG secret key to decrypt the message.

You'll want to rename the extracted file immediately because if you try to extract from another stegged file, it will overwrite a previously extractedFile

To rename the file, type:

mv extractedFile [YOUR FILE NAME]

If the file was encrypted with GPG prior to steggin, then you will need to use GPG on extractedFile to decrypt it, type:

gpg [YOUR EXTRACTED FILE]

