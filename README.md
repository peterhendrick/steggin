Just steggin' bro!

steggin is a steganography tool written in the bash scripting language.

Author: Peter Hendrick

To use steggin, you need the Bourne Again Shell (bash).

To download, type the command, "git clone https://github.com/peterhendrick/steggin && cd steggin"

You need to give yourself permission to execute the steggin.sh file. Type "chmod u+x ./steggin.sh"

Now you can start steggin' bro.

To hide a file in a carrier file, type:

./steggin.sh [PATH TO CARRIER FILE] [PATH TO FILE TO HIDE]

You just stegged bro. This command will create a file named "justStegginBro-[NAME OF CARRIER FILE]" and will contain your hidden file.

It is recommended (but not required) that you use an original image, movie or audio file as a carrier file. Original meaning one you created yourself.

Using an original file will make it much harder to detect that the file contains a hidden message.

It is also recommended that you use gpg encryption on your secret file prior to steggin. Once the .gpg file is extracted, you can use gpg to decrypt it.


Using gpg to encrypt the secret file prior to steggin will ensure that even if the stegged message is discovered,
only the intended recipient will be able to view the extracted contents.


To extract a file that has been previously stegged, type:

./steggin.sh [PATH TO STEGGED FILE]

This will extract the hidden file into the current working directory and name the file "extractedFile".

You'll want to rename the extracted file immediately because if you try to extract from another stegged file, it will overwrite a previously extractedFile

