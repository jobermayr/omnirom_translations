omniROM_translations
====================
This is a simple translation system for OmniROM inspired by KDE's translations system.

To add a file to translate simply add it to xmlfiles (containing the repo name):
  getmessages searches then in ../ for it. Also existing translation files will become updated via msgmerge.

To translate the file copy the pot file from templates (while renaming to *.po) to e. g. de/ and translate it.

To push translations back to the repositories:
  pushmessages
