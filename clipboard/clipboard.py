#!/usr/bin/env python

import pygtk, gtk, gobject

clipboard_file = "/var/share/clipboard"

class Clipboard:
    def __init__(self):
        #self.clipboard = gtk.clipboard_get(gtk.gdk.SELECTION_CLIPBOARD)
        #self.clipboard = gtk.clipboard_get()
        self.clipboard = gtk.clipboard_get("PRIMARY")
        self.clipboard.connect('owner-change', self.on_my_change)

    def on_my_change(self, clipboard, event):
        text = self.unicode_or_none(self.clipboard.wait_for_text())
        if text is not None:
            f = open(clipboard_file, "w")
            f.write(text)
            f.close()

    @staticmethod
    def unicode_or_none(bytes_utf8):
        if bytes_utf8 is None:
            return None
        else:
            return unicode(bytes_utf8, 'UTF-8')

if __name__ == '__main__':
    board = Clipboard()
    gtk.main()
